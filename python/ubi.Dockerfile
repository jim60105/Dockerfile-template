# syntax=docker/dockerfile:1

### Python
FROM registry.access.redhat.com/ubi9/ubi-minimal AS base

ENV PYTHON_VERSION=3.11
ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=UTF-8

RUN microdnf -y install python3.11 && \
    microdnf -y clean all
RUN ln -s /usr/bin/python3.11 /usr/bin/python3 && \
    ln -s /usr/bin/python3.11 /usr/bin/python

### Build image
FROM base AS build

WORKDIR /app

RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

ARG PIP_DISABLE_PIP_VERSION_CHECK=1
ARG PIP_NO_CACHE_DIR=1

RUN microdnf -y install python3.11-pip && \
    microdnf -y clean all && \
    ln -s /usr/bin/pip3.11 /usr/bin/pip3

COPY fc2-live-dl/requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip pip3 install dumb-init
RUN --mount=type=cache,target=/root/.cache/pip pip3 install -r requirements.txt

COPY fc2-live-dl/. .

RUN --mount=type=cache,target=/root/.cache/pip pip3 install .

RUN pip3.11 uninstall -y setuptools pip && \
    pip3.11 uninstall -y setuptools && \
    microdnf -y remove python3.11-pip && \
    microdnf -y clean all 

### Final image
FROM base AS final

ENV PATH="/venv/bin:$PATH"

# Copy venv
COPY --link --from=build /venv /venv

# ffmpeg
COPY --link --from=mwader/static-ffmpeg:6.0 /ffmpeg /usr/local/bin/

RUN mkdir -p /recordings && chown 1001:1001 /recordings
VOLUME [ "/recordings" ]

# Run as non-root user
USER 1001
WORKDIR /recordings

STOPSIGNAL SIGINT
ENTRYPOINT [ "/venv/bin/dumb-init", "--", "/venv/bin/fc2-live-dl" ]