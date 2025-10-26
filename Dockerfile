# Dockerfile for Haxroomie-CLI Pterodactyl Yolk
FROM node:18-bullseye-slim

LABEL author="To Cong" maintainer="tothanhcongtv@gmail.com"
LABEL org.opencontainers.image.source="https://github.com/tocong282/haxroomie-egg"
LABEL org.opencontainers.image.licenses=MIT

# Environment variables for Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_SKIP_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    DEBIAN_FRONTEND=noninteractive \
    NODE_ENV=production

# Install system dependencies including Chromium
RUN apt update && apt install -y \
    ca-certificates fonts-liberation libappindicator3-1 libasound2 \
    libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
    libexpat1 libfontconfig1 libgbm1 libgcc1 libglib2.0-0 libgtk-3-0 \
    libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 \
    libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
    libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    lsb-release wget xdg-utils curl git chromium chromium-sandbox \
    iproute2 tzdata tini \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Install haxroomie-cli globally with --ignore-scripts
RUN npm config set ignore-scripts true -g \
    && npm install -g haxroomie-cli --ignore-scripts \
    && npm config set ignore-scripts false -g

# Create container user matching Pterodactyl requirements
RUN useradd -m -d /home/container -s /bin/bash container

# Set working directory
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

# Copy entrypoint
COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Use tini as init system
ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/bin/bash", "/entrypoint.sh"]
