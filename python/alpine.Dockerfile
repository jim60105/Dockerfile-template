# syntax=docker/dockerfile:1
ARG UID=1001

FROM python:3.11-alpine as build

# RUN mount cache for multi-arch: https://github.com/docker/buildx/issues/549#issuecomment-1788297892
ARG TARGETARCH
ARG TARGETVARIANT

# Install build dependencies
RUN apk add --no-cache build-base libffi-dev

WORKDIR /app

# Install under /root/.local
ENV PIP_USER="true"

RUN --mount=type=cache,id=pip-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/root/.cache/pip \
    --mount=source=fc2-live-dl/requirements.txt,target=requirements.txt \
    pip install -r requirements.txt

RUN --mount=type=cache,id=pip-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/root/.cache/pip \
    --mount=source=fc2-live-dl,target=.,rw \
    pip install . && \
    # Cleanup
    find "/root/.local" -name '*.pyc' -print0 | xargs -0 rm -f || true ; \
    find "/root/.local" -type d -name '__pycache__' -print0 | xargs -0 rm -rf || true ;

FROM python:3.11-alpine as final

ARG UID

RUN pip3.11 uninstall -y setuptools pip wheel && \
    rm -rf /root/.cache/pip

# Use dumb-init to handle signals
RUN apk add --no-cache dumb-init

# ffmpeg
COPY --link --from=mwader/static-ffmpeg:6.1.1 /ffmpeg /usr/local/bin/

# Create user
RUN addgroup -g $UID $UID && \
    adduser -g "" -D $UID -u $UID -G $UID

# Copy dist and support arbitrary user ids (OpenShift best practice)
# https://docs.openshift.com/container-platform/4.14/openshift_images/create-images.html#use-uid_create-images
COPY --chown=$UID:0 --chmod=774 \
    --from=build /root/.local /home/$UID/.local
ENV PATH="/home/$UID/.local/bin:$PATH"

# Remove these to prevent the container from executing arbitrary commands
RUN rm /bin/echo /bin/ln /bin/rm /bin/sh

USER $UID
WORKDIR /recordings
VOLUME [ "/recordings" ]

STOPSIGNAL SIGINT
ENTRYPOINT [ "dumb-init", "--", "fc2-live-dl" ]
CMD [ "-h" ]