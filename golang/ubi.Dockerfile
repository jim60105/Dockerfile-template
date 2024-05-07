# syntax=docker/dockerfile:1
ARG UID=1001
ARG VERSION=master
ARG RELEASE=0

### Build
FROM registry.access.redhat.com/ubi9/go-toolset:1.19 as compress

ARG VERSION
ARG TARGETARCH
RUN CGO_ENABLED=0 go install github.com/Kethsar/ytarchive@$VERSION && \
    # Get upx
    wget -qO - https://github.com/upx/upx/releases/download/v4.2.3/upx-4.2.3-${TARGETARCH}_linux.tar.xz | tar -Jx upx-4.2.3-${TARGETARCH}_linux/upx && \
    # Compress ytarchive
    upx-4.2.3-${TARGETARCH}_linux/upx --best --lzma go/bin/ytarchive || true; \
    rm -rf upx-4.2.3-${TARGETARCH}_linux && \
    # Make an empty directory for final stage
    mkdir -p newdir

### Final
FROM registry.access.redhat.com/ubi9/ubi-micro as final

ARG UID

# Create directories with correct permissions
COPY --link --chown=$UID:0 --chmod=775 --from=compress /opt/app-root/src/newdir /download
COPY --link --chown=$UID:0 --chmod=775 --from=compress /opt/app-root/src/newdir /licenses

# ffmpeg
COPY --link --from=ghcr.io/jim60105/static-ffmpeg-upx:7.0-1 /ffmpeg /
# COPY --link --from=ghcr.io/jim60105/static-ffmpeg-upx:7.0-1 /ffprobe /

# dumb-init
COPY --link --from=ghcr.io/jim60105/static-ffmpeg-upx:7.0-1 /dumb-init /

# Copy licenses (OpenShift Policy)
COPY --link --chown=$UID:0 --chmod=775 LICENSE /licenses/Dockerfile.LICENSE
COPY --link --chown=$UID:0 --chmod=775 ytarchive/LICENSE /licenses/ytarchive.LICENSE

# UBI micro image doesn't contain CA trust store
COPY --link --from=compress /etc/pki/ca-trust /etc/pki/ca-trust

# Copy dist and support arbitrary user ids (OpenShift best practice)
# https://docs.openshift.com/container-platform/4.14/openshift_images/create-images.html#use-uid_create-images
COPY --link --chown=$UID:0 --chmod=775 --from=compress /opt/app-root/src/go/bin/ytarchive /ytarchive

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
