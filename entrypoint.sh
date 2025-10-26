#!/bin/bash
cd /home/container

# Set Puppeteer environment variables
export PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_SKIP_DOWNLOAD=true

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
