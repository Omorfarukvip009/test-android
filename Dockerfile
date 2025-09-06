FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget unzip curl x11vnc xvfb fluxbox websockify \
    qemu-kvm qemu-system-x86 openjdk-8-jre-headless \
    git python3 python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and set up noVNC
RUN mkdir -p /opt/novnc && \
    wget -q https://github.com/novnc/noVNC/archive/refs/heads/master.zip -O /tmp/novnc.zip && \
    unzip /tmp/novnc.zip -d /tmp/ && \
    mv /tmp/noVNC-master/* /opt/novnc/ && \
    rm -rf /tmp/novnc.zip /tmp/noVNC-master

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 6080

CMD ["/start.sh"]
