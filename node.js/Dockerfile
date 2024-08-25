# syntax=docker/dockerfile:1
ARG UID=1001
ARG VERSION=EDGE
ARG RELEASE=0

FROM node:lts-alpine AS build

WORKDIR /app

RUN --mount=source=SillyTavern/package.json,target=package.json \
    --mount=source=SillyTavern/package-lock.json,target=package-lock.json \
    --mount=source=SillyTavern/post-install.js,target=post-install.js \
    npm ci && npm cache clean --force

COPY SillyTavern/. /app/.

FROM node:lts-alpine AS final

# RUN mount cache for multi-arch: https://github.com/docker/buildx/issues/549#issuecomment-1788297892
ARG TARGETARCH
ARG TARGETVARIANT

ARG UID

# Create directories with correct permissions
RUN install -d -m 775 -o $UID -g 0 /licenses && \
    install -d -m 775 -o $UID -g 0 /app && \
    install -d -m 775 -o $UID -g 0 /app/data

# Runtime dependencies
RUN --mount=type=cache,id=apk-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/apk \
    apk update && apk add -u \
    dumb-init=1.2.5-r3 \
    # Needed for runtime plugin installation
    git=2.45.2-r0

# Copy licenses (OpenShift Policy)
COPY --link --chown=$UID:0 --chmod=775 LICENSE /licenses/Dockerfile.LICENSE
COPY --link --chown=$UID:0 --chmod=775 SillyTavern/LICENSE /licenses/LICENSE

# Copy dist
COPY --from=build --chown=$UID:0 --chmod=775 /app /app

# Copy default config
COPY --from=build --chown=$UID:0 --chmod=775 /app/default/config.yaml /app/

RUN \
    # Listen for connections on all interfaces
    sed -i 's/listen: false/listen: true/' /app/config.yaml && \
    # Disable whitelist mode
    # Container orchestrators usually connect containers using runtime-generated IPs.
    # There are strong reasons to avoid implementing a whitelist inside the container.
    # This should be done in an external firewall.
    sed -i 's/whitelistMode: true/whitelistMode: false/' /app/config.yaml && \
    # Enable multi-user mode
    sed -i 's/enableUserAccounts: false/enableUserAccounts: true/' /app/config.yaml && \
    # Workaround for user.css not found
    touch /app/public/css/user.css

WORKDIR /app

EXPOSE 8000

VOLUME [ "/app/data" ]

# Use dumb-init as PID 1 to handle signals properly
ENTRYPOINT [ "dumb-init", "--", "node", "server.js" ]
# CMD [ ]

ARG VERSION
ARG RELEASE
LABEL name="jim60105/docker-SillyTavern" \
    # Authors for SillyTavern
    vendor="SillyTavern" \
    # Maintainer for this docker image
    maintainer="jim60105" \
    # Dockerfile source repository
    url="https://github.com/jim60105/docker-SillyTavern" \
    version=${VERSION} \
    # This should be a number, incremented with each change
    release=${RELEASE} \
    io.k8s.display-name="SillyTavern" \
    summary="SillyTavern: LLM Frontend for Power Users." \
    description="Mobile-friendly layout, Multi-API (KoboldAI/CPP, Horde, NovelAI, Ooba, OpenAI, OpenRouter, Claude, Scale), VN-like Waifu Mode, Stable Diffusion, TTS, WorldInfo (lorebooks), customizable UI, auto-translate, and more prompt options than you'd ever want or need + ability to install third-party extensions. For more information about this tool, please visit the following website: https://github.com/SillyTavern/SillyTavern"
