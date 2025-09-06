# Lightweight Android 8.1 container with VNC + noVNC web access
FROM sickcodes/docker-android:8.1

# Expose the noVNC web interface on port 6080
EXPOSE 6080

# Set some environment variables for better performance
ENV WEB_VNC=true \
    DEVICE="Samsung Galaxy S10" \
    ENABLE_ADB=true

# Start Android + noVNC
CMD ["/bin/bash"]
