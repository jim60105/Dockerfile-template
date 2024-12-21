# syntax=docker/dockerfile:1
ARG UID=1000
ARG VERSION=EDGE
ARG RELEASE=0
ARG BASE_IMAGE=registry.fedoraproject.org/fedora-toolbox:41

########################################
# Base stage
########################################
FROM ${BASE_IMAGE} AS base

# Set dnf config
RUN cat <<-"EOF" > /etc/dnf/dnf.conf
[main]
install_weak_deps=False
tsflags=nodocs
EOF

########################################
# Font unpack stage
########################################
FROM base AS font-unpacker

WORKDIR /fonts

ADD https://github.com/ButTaiwan/iansui/releases/download/v1.000/iansui.zip /tmp/iansui.zip

ADD https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Hack.zip /tmp/hack.zip

RUN unzip -uo /tmp/iansui.zip -d /fonts/iansui && \
    unzip -uo /tmp/hack.zip -d /fonts/hack

########################################
# Host runner stage
########################################
FROM base AS host-runner

WORKDIR /host-runner

RUN cat <<-"EOF" > /host-runner/host-runner
#!/bin/bash
executable="$(basename ${0})"
exec flatpak-spawn --host "${executable}" "${@}"
EOF

# Setup host-runner script and symlinks
RUN bins=( \
    "flatpak" \
    "podman" \
    "docker" \
    "rpm-ostree" \
    "systemctl" \
    "xdg-open" \
    "kitty" \
    ); \
    for f in "${bins[@]}"; do \
    ln -s host-runner "/host-runner/$f";\
    done

########################################
# Final stage
########################################
FROM base AS final

# Create directories with correct permissions
ARG UID
RUN install -d -m 775 -o $UID -g 0 /licenses

# Copy licenses (OpenShift Policy)
COPY --chown=$UID:0 --chmod=775 LICENSE /licenses/Containerfile.LICENSE

# COPY host-runner
COPY --chown=$UID:0 --chmod=775 --from=host-runner /host-runner /usr/local/bin

# RUN mount cache for multi-arch: https://github.com/docker/buildx/issues/549#issuecomment-1788297892
ARG TARGETARCH
ARG TARGETVARIANT

# Make sure the cache is refreshed
ARG RELEASE

# Install utilities
RUN --mount=type=cache,id=dnf-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/dnf \
    dnf -y upgrade && \
    dnf -y install \
    xdg-utils \
    jq

# Fonts
COPY --chown=$UID:0 --chmod=775 --from=font-unpacker /fonts /usr/local/share/fonts
RUN --mount=type=cache,id=dnf-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/dnf \
    dnf -y install \
    google-noto-sans-cjk-fonts \
    cascadia-fonts-all \
    hanamin-fonts

# Install os keyring
#! Following this guide to setup os keyring to use gnome-libsecret:
# https://code.visualstudio.com/docs/editor/settings-sync#_recommended-configure-the-keyring-to-use-with-vs-code
ENV GCM_CREDENTIAL_STORE=gpg
RUN --mount=type=cache,id=dnf-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/dnf \
    dnf -y install seahorse

# Install .NET
RUN --mount=type=cache,id=dnf-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/dnf \
    dnf -y install dotnet-sdk-8.0

# Install Rustup
RUN --mount=type=cache,id=dnf-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/dnf \
    dnf -y install rustup

# Install Java 17 (JetBrains loves this)
RUN --mount=type=cache,id=dnf-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/dnf \
    dnf -y install java-17-openjdk

# Install git-credential-manager (This needs .NET 8)
RUN curl -L https://aka.ms/gcm/linux-install-source.sh | sh && \
git-credential-manager configure

# Install aria2
RUN --mount=type=cache,id=dnf-$TARGETARCH$TARGETVARIANT,sharing=locked,target=/var/cache/dnf \
    dnf -y install aria2

# Copy toolbox runners
COPY --chown=$UID:0 --chmod=775 video/runner /copy-to-host

ARG VERSION
ARG RELEASE
LABEL name="jim60105/toolbx" \
    org.opencontainers.image.name="jim60105/toolbx" \
    # Authors for toolbox
    vendor="Fedora Project" \
    # Maintainer for this container image
    maintainer="jim60105" \
    # Containerfile source repository
    url="https://github.com/jim60105/toolbx" \
    version=${VERSION} \
    # This should be a number, incremented with each change
    release=${RELEASE} \
    io.k8s.display-name="toolbx" \
    summary="toolbx: My Personal Fedora Toolbox (Containerfile)" \
    description="Toolbx is a tool for Linux, which allows the use of interactive command line environments for software development and troubleshooting the host operating system, without having to install software on the host. These are my personal Fedora toolbox images, which I use for development and daily usage. For more information about this tool, please visit the following website: https://github.com/jim60105/toolbx" \
    license="GPL-3.0" \
    org.opencontainers.image.license="GPL-3.0"
