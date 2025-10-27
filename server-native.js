const HaxballJS = require('haxball.js');

const token = process.env.HAXBALL_TOKEN;

if (!token) {
    console.error('ERROR: HAXBALL_TOKEN is required!');
    console.error('Get your token at: https://www.haxball.com/headlesstoken');
    process.exit(1);
}

console.log('Starting Haxball headless host (Native Node.js)...');

HaxballJS.then((HBInit) => {
    const room = HBInit({
        token: token,
        roomName: process.env.ROOM_NAME || 'My Haxball Room',
        maxPlayers: parseInt(process.env.MAX_PLAYERS) || 16,
        public: true,
        noPlayer: true,
        password: process.env.ROOM_PASSWORD || null
    });

    room.setDefaultStadium('Classic');
    room.setScoreLimit(3);
    room.setTimeLimit(5);

    room.onRoomLink = function(link) {
        console.log('========================================');
        console.log('Room is now open!');
        console.log('Room Link:', link);
        console.log('========================================');
    };

    room.onPlayerJoin = function(player) {
        room.sendAnnouncement(`Welcome ${player.name}!`, null, 0x00FF00);
    };

    room.onPlayerLeave = function(player) {
        console.log(`${player.name} left the room`);
    };

    room.onPlayerChat = function(player, message) {
        if (message === "!help") {
            room.sendAnnouncement("Commands: !help", player.id);
        }
    };

    console.log('Room script loaded successfully!');
}).catch(error => {
    console.error('Error starting room:', error);
    process.exit(1);
});
