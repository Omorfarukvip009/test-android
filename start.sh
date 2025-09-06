#!/bin/bash
# Start Xvfb virtual display
Xvfb :0 -screen 0 720x1280x16 &
export DISPLAY=:0

# Start fluxbox window manager
fluxbox &

# Start x11vnc
x11vnc -forever -usepw -shared -display :0 &

# Start noVNC server
/opt/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &
echo "noVNC running at http://0.0.0.0:6080"

# (Optional) Start a simple QEMU Android emulator if needed
# qemu-system-x86_64 -cdrom android-x86_64-8.1-r6.iso -m 1024 -vga std

# Keep container running
tail -f /dev/null
