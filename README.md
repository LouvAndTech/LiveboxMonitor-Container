# LiveboxMonitor Container

This repository packages [LiveboxMonitor](https://github.com/p-dor/LiveboxMonitor) (by [p-dor](https://github.com/p-dor)) into a container so the desktop app can run headlessly on servers and NAS devices.

## What is LiveboxMonitor?

LiveboxMonitor is a monitoring and management tool for Orange Livebox routers, that you can actually use compared to the default Orange interface.

This image uses [linuxserver](https://github.com/linuxserver)'s [KasmVNC base image](https://github.com/linuxserver/docker-baseimage-kasmvnc) to provide a browser-accessible desktop (VNC/Web) that run on docker.

## Usage 

The best way to use the image *(for now)* is to build and deploy it with Docker Compose after cloning this repository.

> [!WARNING]  
> Change the default username and password in the `compose.yaml` file before deploying the container! Especially if you expose the ports to the internet!

```yaml
services:
  liveboxmonitor:
    image: liveboxmonitor:test
    build:
      context: .
      dockerfile: Dockerfile
      args:
        APP_VERSION: "1.6"
    container_name: liveboxmonitor
    environment:
      CUSTOM_USER: "user" # CHANGE ME
      PASSWORD: "pass" # CHANGE ME
    volumes:
      - liveboxmonitor-data:/config
    ports:
      - "3000:3000" # HTTP
      - "3001:3001" # HTTPS
    restart: unless-stopped
    
volumes:
  liveboxmonitor-data:
```