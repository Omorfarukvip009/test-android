# Use a small base image
FROM ubuntu:20.04

# Disable interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies: X server, noVNC, openbox, qemu, etc.
RUN apt-get update && apt-get install -y \
    wget unzip curl x11vnc xvfb fluxbox websockify \
    qemu-kvm qemu-system-x86 openjdk-8-jre-headless \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download & setup noVNC
RUN mkdir -p /opt/novnc && \
    wget -qO- https://github.com/novnc/noVNC/archive/refs/heads/master.zip | unzip -d /opt/ && \
    mv /opt/noVNC-master/* /opt/novnc/ && rm -rf /opt/noVNC-master

# Add a simple startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 6080

CMD ["/start.sh"]
