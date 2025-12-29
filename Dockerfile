FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine321-version-89d8a445

LABEL maintainer="elouan.lerissel@gmail.com" \
    org.opencontainers.image.authors="Elouan, elouan.lerissel@gmail.com" \
    org.opencontainers.image.title="LiveboxMonitor Container"

WORKDIR /LiveboxMonitor

# === ARGS ===

ARG APP_VERSION

# === Install LiveboxMonitor ===
# Dependencies
RUN apk add --no-cache \
    python3 \
    wget \
    tar \ 
    py3-qt6 

# Download LiveboxMonitor
RUN wget -qO- https://github.com/p-dor/LiveboxMonitor/archive/refs/tags/${APP_VERSION}.tar.gz | tar -xz --strip-components=1 -C /LiveboxMonitor

# Create a venv and install requirements
# Note the use of --system-site-packages to be able to use system installed PyQt6
RUN python3 -m venv /LiveboxMonitor/venv --system-site-packages && \
    /LiveboxMonitor/venv/bin/pip install --no-cache-dir --upgrade pip && \
    /LiveboxMonitor/venv/bin/pip install --no-cache-dir -r /LiveboxMonitor/requirements.txt

# === Setup kasmvnc environment ===
ENV TITLE=LiveboxMonitor
# Copy custom files
COPY etc /etc
COPY root /
# Enable http authentication
ENV CUSTOM_USER=liveboxmonitor
ENV PASSWORD=default_pass
# Startup parameters
ENV NO_DECOR=1