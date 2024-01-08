# syntax=docker/dockerfile:1
ARG UID=1001
ARG VERSION=master

### Build
FROM registry.access.redhat.com/ubi9/go-toolset:1.19 as build

ARG VERSION
RUN CGO_ENABLED=0 go install github.com/Kethsar/ytarchive@$VERSION

### Final
FROM registry.access.redhat.com/ubi9/ubi-micro as final

ARG UID

# ffmpeg
COPY --link --from=mwader/static-ffmpeg:6.1.1 /ffmpeg /usr/local/bin/ffmpeg

# UBI micro image doesn't contain CA trust store
COPY --link --from=build /etc/pki/ca-trust /etc/pki/ca-trust

# ytarchive
COPY --link --chown=$UID:0 --chmod=774 \
    --from=build /opt/app-root/src/go/bin/ytarchive /usr/local/bin/ytarchive

USER $UID
WORKDIR /download
VOLUME ["/download"]

ENTRYPOINT [ "/usr/local/bin/ytarchive" ]
CMD [ "-h" ]