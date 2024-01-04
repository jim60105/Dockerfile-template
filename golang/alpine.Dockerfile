# syntax=docker/dockerfile:1

### Build
FROM golang:1.19-alpine as build

ARG VERSION=master

RUN go install github.com/Kethsar/ytarchive@$VERSION

### Final
FROM alpine:3.18 as final

# ffmpeg
COPY --link --from=mwader/static-ffmpeg:6.0 /ffmpeg /usr/local/bin/ffmpeg

# ytarchive
COPY --link --chown=1001:1001 --from=build /go/bin/ytarchive /usr/local/bin/ytarchive
USER 1001

WORKDIR /download

VOLUME ["/download"]

ENTRYPOINT [ "/usr/local/bin/ytarchive" ]
