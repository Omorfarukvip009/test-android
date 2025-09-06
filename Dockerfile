# Use docker-android prebuilt image (Android 11)
FROM budtmo/docker-android-x86-9.0

# Expose web interface (noVNC) on port 6080
EXPOSE 6080

# Start Android + noVNC
CMD ["/bin/sh", "-c", "/entrypoint.sh"]
