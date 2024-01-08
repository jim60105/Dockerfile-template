# syntax=docker/dockerfile:1
ARG VERSION=master

### Build
FROM golang:1.19 as build

ARG VERSION
RUN CGO_ENABLED=0 go install github.com/Kethsar/ytarchive@$VERSION

### Final
FROM gcr.io/distroless/static-debian12:nonroot as final

# ffmpeg
COPY --link --from=mwader/static-ffmpeg:6.1.1 /ffmpeg /bin/ffmpeg

# ytarchive
COPY --link --chown=65532:0 --chmod=774 \
    --from=build /go/bin/ytarchive /bin/ytarchive

WORKDIR /download
VOLUME ["/download"]

ENTRYPOINT [ "/bin/ytarchive" ]
CMD [ "-h" ]