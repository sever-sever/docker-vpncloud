FROM alpine:3.20.3

# Set environment variables
ENV VPNCLOUD_URL="https://github.com/dswd/vpncloud/releases/download"
ENV VPNCLOUD_VERSION="2.3.0"
ENV PORT="3210"

# Install necessary tools and dependencies
RUN apk add --no-cache curl

# Set the working dir
WORKDIR /app

# Download and install the VPNCloud package
RUN curl -L -o vpncloud  "${VPNCLOUD_URL}/v${VPNCLOUD_VERSION}/vpncloud_${VPNCLOUD_VERSION}_static_amd64"

# Add executable flags
RUN chmod +x vpncloud

EXPOSE ${PORT}/udp

ENTRYPOINT ["./vpncloud"]
CMD ["--config", "/etc/vpncloud/config.yaml"]
