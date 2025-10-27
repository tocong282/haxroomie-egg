FROM node:18-bullseye-slim

# Install haxball.js (no Chromium needed!)
RUN npm install -g haxball.js

# Create user
RUN useradd -m -d /home/container container

USER container
WORKDIR /home/container

# Copy files
COPY --chown=container:container entrypoint.sh /entrypoint.sh
COPY --chown=container:container server-native.js /home/container/server.js

# Make entrypoint executable
RUN chmod +x /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
