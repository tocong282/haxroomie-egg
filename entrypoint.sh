#!/bin/bash
cd /home/container

# Check if token is provided
if [ -z "$HAXBALL_TOKEN" ]; then
    echo "ERROR: HAXBALL_TOKEN environment variable is required!"
    echo "Get your token at: https://www.haxball.com/headlesstoken"
    exit 1
fi

# Create bot script if not exists
if [ ! -f haxbot.js ]; then
    cat > haxbot.js << 'EOF'
const puppeteer = require('puppeteer');

async function startRoom() {
    console.log('Starting Haxball headless host...');
    
    const browser = await puppeteer.launch({
        args: [
            '--no-sandbox',
            '--disable-setuid-sandbox',
            '--disable-dev-shm-usage',
            '--single-process',
            '--disable-gpu'
        ],
        executablePath: '/usr/bin/chromium'
    });

    const page = await browser.newPage();
    
    console.log('Loading Haxball headless page...');
    await page.goto('https://www.haxball.com/headless', {
        waitUntil: 'networkidle2'
    });

    console.log('Creating room...');
    await page.evaluate((token, roomName, maxPlayers, password) => {
        var room = HBInit({
            token: token,
            roomName: roomName,
            maxPlayers: parseInt(maxPlayers),
            public: true,
            playerName: "Host",
            password: password || null,
            geo: {"code": "US", "lat": 40.7, "lon": -74.0}
        });

        room.setDefaultStadium("Classic");
        room.setScoreLimit(3);
        room.setTimeLimit(5);
        
        room.onPlayerJoin = function(player) {
            room.sendAnnouncement("Welcome " + player.name + "!", null, 0x00FF00);
        };

        room.onPlayerLeave = function(player) {
            room.sendAnnouncement(player.name + " has left.", null, 0xFF0000);
        };

        room.onPlayerChat = function(player, message) {
            if (message === "!help") {
                room.sendAnnouncement("Available commands: !help, !about", player.id);
            }
            if (message === "!about") {
                room.sendAnnouncement("Powered by Pterodactyl", player.id);
            }
        };

        room.onRoomLink = function(link) {
            console.log("========================================");
            console.log("Room is now open!");
            console.log("Room link: " + link);
            console.log("========================================");
        };
    }, process.env.HAXBALL_TOKEN, process.env.ROOM_NAME, process.env.MAX_PLAYERS, process.env.ROOM_PASSWORD);

    console.log('Room script injected. Waiting for room link...');
    
    // Keep the process running
    await new Promise(() => {});
}

startRoom().catch(error => {
    console.error('Error starting room:', error);
    process.exit(1);
});
EOF
fi

# Start the bot
echo "Starting Haxball room with token..."
node haxbot.js
