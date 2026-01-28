ARG BUILD_FROM
# hadolint ignore=DL3006
FROM $BUILD_FROM

# Build arguments for version info
ARG BUILD_VERSION
ENV ADDON_VERSION=${BUILD_VERSION:-unknown}

# ==============================================================================
# zrok Share Add-on for Home Assistant
#
# This add-on uses the following open source components:
# - zrok: Apache License 2.0, Copyright 2019 NetFoundry, Inc.
# - OpenZiti: Apache License 2.0, Copyright NetFoundry, Inc.
#
# For complete license information, see:
# https://github.com/ralf-dev16/hass-zrok/blob/main/THIRD-PARTY-NOTICES.md
# ==============================================================================

# Set shell (ash doesn't support pipefail, so we use -e for exit on error)
SHELL ["/bin/ash", "-e", "-c"]

# Install dependencies and zrok
# Note: gcompat provides glibc compatibility for Alpine's musl libc.
# This is required because zrok binaries are built with glibc.
# gcompat is more complete than libc6-compat and supports newer symbols like fcntl64.
RUN apk add --no-cache \
    bash \
    curl \
    jq \
    ca-certificates \
    gcompat \
    && ARCH="$(uname -m)" \
    && case "$ARCH" in \
        x86_64) ZROK_ARCH="amd64" ;; \
        aarch64) ZROK_ARCH="arm64" ;; \
        armv7l) ZROK_ARCH="armv7" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac \
    && ZROK_VERSION=$(curl -s https://api.github.com/repos/openziti/zrok/releases/latest | jq -r '.tag_name') \
    && echo "Downloading zrok ${ZROK_VERSION} for ${ZROK_ARCH}..." \
    && curl -L "https://github.com/openziti/zrok/releases/download/${ZROK_VERSION}/zrok_${ZROK_VERSION#v}_linux_${ZROK_ARCH}.tar.gz" \
        -o /tmp/zrok.tar.gz \
    && tar -xzf /tmp/zrok.tar.gz -C /usr/local/bin/ \
    && chmod +x /usr/local/bin/zrok \
    && rm -f /tmp/zrok.tar.gz \
    && zrok version || echo "Warning: Could not run zrok version (possibly due to QEMU emulation)"

# Copy startup script
COPY run.sh /
RUN chmod a+x /run.sh

# Labels
LABEL \
    io.hass.name="zrok Share" \
    io.hass.description="Secure remote access via zrok zero-trust networking" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.arch="${BUILD_ARCH}"

# Start script
CMD ["/run.sh"]
