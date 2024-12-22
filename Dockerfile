FROM debian:bookworm-slim

# Set environment variables
ENV VPNCLOUD_VERSION="2.3.0"
ENV VPNCLOUD_URL="https://github.com/dswd/vpncloud/releases/download"
ENV PORT="3210"

# Install necessary tools and dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Download and install the VPNCloud package
RUN wget -q "${VPNCLOUD_URL}/v${VPNCLOUD_VERSION}/vpncloud_${VPNCLOUD_VERSION}_amd64.deb" -O /tmp/vpncloud.deb && \
    apt-get update && apt-get install -y /tmp/vpncloud.deb && \
    rm -f /tmp/vpncloud.deb

EXPOSE 3210/udp

# Verify installation
RUN vpncloud --version

# Set entrypoint or command as needed
CMD ["vpncloud"]
