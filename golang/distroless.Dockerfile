# syntax=docker/dockerfile:1

### Build
FROM golang:1.19 as build

ARG VERSION=master

RUN CGO_ENABLED=0 go install github.com/Kethsar/ytarchive@$VERSION

### Final
FROM gcr.io/distroless/static-debian12 as final

# ffmpeg
COPY --link --from=mwader/static-ffmpeg:6.0 /ffmpeg /usr/local/bin/ffmpeg

# ytarchive
COPY --from=build /go/bin/ytarchive /usr/local/bin/ytarchive

WORKDIR /download

VOLUME ["/download"]

ENTRYPOINT ["/usr/local/bin/ytarchive"]
