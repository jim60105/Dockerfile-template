# syntax=docker/dockerfile:1
ARG UID=1001
ARG VERSION=master
ARG RELEASE=0
ARG NAME=app

########################################
# Chef base stage
########################################
FROM lukemathwalker/cargo-chef:latest-rust-alpine AS chef
WORKDIR /app

# Create directories with correct permissions
ARG UID
RUN install -d -m 775 -o $UID -g 0 /newdir

# The Rust team is planning to change the meaning of *-unknown-linux-musl from "+crt-static" to "-crt-static"
# https://github.com/rust-lang/compiler-team/issues/422#issuecomment-1767659770
ENV RUSTFLAGS="-C target-feature=+crt-static"

########################################
# Planner stage
# Generate a recipe for the project, containing all dependencies information for cooking
########################################
FROM chef AS planner
RUN --mount=source=src,target=src \
    --mount=source=Cargo.toml,target=Cargo.toml \
    --mount=source=Cargo.lock,target=Cargo.lock \
    cargo chef prepare --recipe-path recipe.json

########################################
# Cook stage
# Build the project dependencies, so that they can be cached at seprate layer
########################################
FROM chef AS cook

# RUN mount cache for multi-arch: https://github.com/docker/buildx/issues/549#issuecomment-1788297892
ARG TARGETARCH
ARG TARGETVARIANT
RUN --mount=type=cache,id=apk-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/apk \
    # dependencies for git2-rs
    apk add pkgconfig libressl-dev

RUN --mount=source=/app/recipe.json,target=recipe.json,from=planner \
    cargo chef cook --release --target x86_64-unknown-linux-musl --recipe-path recipe.json --all-targets --locked

########################################
# Test stage
########################################
FROM cook AS test

RUN --mount=source=src,target=src \
    --mount=source=Cargo.toml,target=Cargo.toml \
    --mount=source=Cargo.lock,target=Cargo.lock \
    cargo test --release --target x86_64-unknown-linux-musl --all-targets --locked

########################################
# Builder stage
########################################
FROM test AS builder

ARG NAME
RUN --mount=source=src,target=src \
    --mount=source=Cargo.toml,target=Cargo.toml \
    --mount=source=Cargo.lock,target=Cargo.lock \
    cargo build --release --target x86_64-unknown-linux-musl --bin ${NAME} --locked

#######################################
# Compress stage
########################################
FROM chef AS compress

# RUN mount cache for multi-arch: https://github.com/docker/buildx/issues/549#issuecomment-1788297892
ARG TARGETARCH
ARG TARGETVARIANT

# Compress dist and dumb-init with upx
ARG NAME
RUN --mount=type=cache,id=apk-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/apk \
    --mount=from=builder,source=/app/target/x86_64-unknown-linux-musl/release/${NAME},target=/tmp/app \
    apk update && apk add -u \
    -X "https://dl-cdn.alpinelinux.org/alpine/edge/community" \
    upx dumb-init && \
    cp /tmp/app /${NAME} && \
    #! UPX will skip small files and large files
    # https://github.com/upx/upx/blob/5bef96806860382395d9681f3b0c69e0f7e853cf/src/p_unix.cpp#L80
    # https://github.com/upx/upx/blob/b0dc48316516d236664dfc5f1eb5f2de00fc0799/src/conf.h#L134
    upx --best --lzma /${NAME} || true; \
    upx --best --lzma /usr/bin/dumb-init || true; \
    apk del upx

########################################
# Binary stage
# How to: docker build --output=. --target=binary .
########################################
FROM scratch AS binary

ARG NAME
COPY --link --chown=0:0 --chmod=777 --from=compress /${NAME} /${NAME}

########################################
# Final stage
########################################
FROM scratch AS final

ARG UID

# Create directories with correct permissions
COPY --link --chown=$UID:0 --chmod=775 --from=chef /newdir /tmp

# Copy CA trust store
#COPY --link --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# Rust seems to use this one:
# https://stackoverflow.com/a/57295149/8706033
COPY --link --from=chef /etc/ssl/cert.pem /etc/ssl/

# dumb-init
COPY --link --chown=$UID:0 --chmod=775 --from=compress /usr/bin/dumb-init /dumb-init

# Copy dist
ARG NAME
COPY --link --chown=$UID:0 --chmod=775 assets /assets
COPY --link --chown=$UID:0 --chmod=775 --from=compress /${NAME} /app

ENV PATH="/"

WORKDIR /

VOLUME [ "/tmp" ]

EXPOSE 8080

USER $UID

STOPSIGNAL SIGINT

# Use dumb-init as PID 1 to handle signals properly
ENTRYPOINT ["dumb-init", "--", "app"]
#CMD [ "-h" ]

ARG VERSION
ARG RELEASE
LABEL name=${NAME} \
    # Authors for this application
    vendor="" \
    # Maintainer for this docker image
    maintainer="jim60105" \
    # Dockerfile source repository
    url="" \
    version=${VERSION} \
    # This should be a number, incremented with each change
    release=${RELEASE} \
    io.k8s.display-name=${NAME} \
    summary="" \
    description=" For more information about this tool, please visit the following website: "
