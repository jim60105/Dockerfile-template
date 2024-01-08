# syntax=docker/dockerfile:1
ARG UID=1001
ARG VERSION=master

### Build
FROM golang:1.19 as build

ARG VERSION
RUN CGO_ENABLED=0 go install github.com/Kethsar/ytarchive@$VERSION

### Final
FROM scratch as final

ARG UID

# ffmpeg
COPY --link --from=mwader/static-ffmpeg:6.1.1 /ffmpeg /bin/

# scratch image doesn't contain CA trust store
COPY --link --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# ytarchive
COPY --link --chown=$UID:0 --chmod=774 \
    --from=build /go/bin/ytarchive /bin/

USER $UID
WORKDIR /download
VOLUME ["/download"]

ENTRYPOINT [ "/bin/ytarchive" ]
CMD [ "-h" ]