#!/bin/bash
set -e

# ====== Step 1: Setup Virtual Display ======
echo "🖥️ Starting virtual display..."
Xvfb :0 -screen 0 720x1280x16 &
export DISPLAY=:0

echo "🪟 Starting window manager..."
fluxbox &

echo "🔑 Starting x11vnc..."
x11vnc -forever -nopw -shared -display :0 &

echo "🌐 Starting noVNC web interface..."
/opt/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &
echo "✅ noVNC running at http://0.0.0.0:6080"

# ====== Step 2: Download Android-x86 ISO with Retry ======
ISO_URL="https://github.com/nikhilkumarsingh/android-x86_64/releases/download/8.1-r6/android-x86_64-8.1-r6.iso"
ISO_PATH="/root/android-x86_64-8.1-r6.iso"

if [ ! -f "$ISO_PATH" ]; then
    echo "⬇️ Downloading Android-x86 ISO from mirror..."
    for i in {1..5}; do
        if wget -O "$ISO_PATH" "$ISO_URL"; then
            echo "✅ ISO downloaded successfully."
            break
        else
            echo "⚠️ Download failed. Retrying in 10s... (attempt $i)"
            sleep 10
        fi
        if [ $i -eq 5 ]; then
            echo "❌ Failed to download ISO after 5 attempts."
            exit 1
        fi
    done
else
    echo "✅ ISO already present, skipping download."
fi

# ====== Step 3: Create QEMU Disk (if missing) ======
DISK_PATH="/root/android.img"
if [ ! -f "$DISK_PATH" ]; then
    echo "💾 Creating 4GB disk for Android..."
    qemu-img create -f qcow2 "$DISK_PATH" 4G
else
    echo "✅ Virtual disk already exists."
fi

# ====== Step 4: Start QEMU with Android ======
echo "🚀 Booting Android-x86 in QEMU..."
qemu-system-x86_64 \
    -enable-kvm \
    -m 1024 \
    -smp 2 \
    -vga std \
    -display sdl \
    -hda "$DISK_PATH" \
    -cdrom "$ISO_PATH" \
    -boot d \
    -net nic -net user &

# Keep container running forever
tail -f /dev/null
