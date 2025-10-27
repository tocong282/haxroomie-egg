#!/bin/bash
cd /home/container

echo "Starting Haxball Headless Host..."
echo "Token: ${HAXBALL_TOKEN:0:10}..."

# Check if server.js exists, if not copy default
if [ ! -f server.js ]; then
    echo "No custom server.js found, using default"
fi

# Start the server
exec node server.js
