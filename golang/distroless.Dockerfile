# syntax=docker/dockerfile:1
ARG VERSION=master
ARG RELEASE=0

########################################
# Compress stage
########################################
FROM golang:1.19 as compress

# RUN mount cache for multi-arch: https://github.com/docker/buildx/issues/549#issuecomment-1788297892
ARG TARGETARCH
ARG TARGETVARIANT

ARG VERSION
RUN --mount=type=cache,id=apt-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,id=aptlists-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/lib/apt/lists \
    # Install ytarchive
    CGO_ENABLED=0 go install github.com/Kethsar/ytarchive@$VERSION && \
    # Install upx
    echo 'deb http://deb.debian.org/debian bookworm-backports main' > /etc/apt/sources.list.d/backports.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    upx-ucl && \
    # Compress ytarchive
    upx --best --lzma /go/bin/ytarchive || true; \
    # Remove upx
    apt-get purge -y upx-ucl && \
    # Make an empty directory for final stage
    mkdir -p /newdir

### Final
FROM gcr.io/distroless/static-debian12:nonroot as final

ARG UID=65532

# Create directories with correct permissions
COPY --link --chown=$UID:0 --chmod=775 --from=compress /newdir /download
COPY --link --chown=$UID:0 --chmod=775 --from=compress /newdir /licenses

# ffmpeg
COPY --link --from=ghcr.io/jim60105/static-ffmpeg-upx:7.0-1 /ffmpeg /
# COPY --link --from=ghcr.io/jim60105/static-ffmpeg-upx:7.0-1 /ffprobe /

# dumb-init
COPY --link --from=ghcr.io/jim60105/static-ffmpeg-upx:7.0-1 /dumb-init /

# Copy licenses (OpenShift Policy)
COPY --link --chown=$UID:0 --chmod=775 LICENSE /licenses/Dockerfile.LICENSE
COPY --link --chown=$UID:0 --chmod=775 ytarchive/LICENSE /licenses/ytarchive.LICENSE

# Copy dist and support arbitrary user ids (OpenShift best practice)
# https://docs.openshift.com/container-platform/4.14/openshift_images/create-images.html#use-uid_create-images
COPY --link --chown=$UID:0 --chmod=775 --from=compress /go/bin/ytarchive /

ENV PATH="/"

WORKDIR /download

VOLUME [ "/download" ]

USER $UID

STOPSIGNAL SIGINT

# Use dumb-init as PID 1 to handle signals properly
ENTRYPOINT [ "dumb-init", "--", "ytarchive" ]
CMD [ "-h" ]

ARG VERSION
ARG RELEASE
LABEL name="jim60105/docker-ytarchive" \
    # Authors for ytarchive
    vendor="Kethsar" \
    # Maintainer for this docker image
    maintainer="jim60105" \
    # Dockerfile source repository
    url="https://github.com/jim60105/docker-ytarchive" \
    version=${VERSION} \
    # This should be a number, incremented with each change
    release=${RELEASE} \
    io.k8s.display-name="ytarchive" \
    summary="ytarchive: Garbage Youtube livestream downloader" \
    description="Attempt to archive a given Youtube livestream from the start. This is most useful for streams that have already started and you want to download, but can also be used to wait for a scheduled stream and start downloading as soon as it starts. For more information about this tool, please visit the following website: https://github.com/Kethsar/ytarchive"
