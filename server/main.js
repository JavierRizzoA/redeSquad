/*
   This file is part of redeSquad.

   redeSquad is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   redeSquad is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along withredeSquad .  If not, see <http://www.gnu.org/licenses/>.
 */
const WebSocket = require('ws');

const wss = new WebSocket.Server({
  port: 18813
});

const PLAYERS_PER_ROOM = 2;
const SQUARE_SIZE = 15;
const SPEED = 0.1;
const UP = 0;
const DOWN = 1;
const LEFT = 2;
const RIGHT = 3;
const WIDTH = 900;
const HEIGHT = 600;

let ids = [];
let rooms = [];
let waitingList = [];

wss.on('connection', function(ws) {
  console.log('New client connected');
  ws.on('message', function(message) {
    //console.log('received: ' + message);
    message = JSON.parse(message);
    switch(message.type) {
      case 'id-request':
        idRequest(ws);
        break;
      case 'epoch-time':
        epochTime(ws, message);
        break;
      case 'play-request':
        ws.name = message.value.name;
        waitingList.push(ws);
        break;
      case 'ready-response':
        ws.ready = true;
        break;
      case 'input':
        ws.snake.direction = message.value.direction;
        ws.snake.lastInputProcessed = message.value.inputID;
        break;
    }
  });

  if(ws.readyState == 1) ws.send(JSON.stringify({
    type: 'welcome',
    value: 'welcome'
  }));
});

function createRoom() {
  let room = {
    playerWSs:  [],
    started: false,
    finished: false,
    ready: false,
    inputs: [],
    frame: 0,
    food: []
  };
  for(let i = 0; i < PLAYERS_PER_ROOM; i++) {
    waitingList[i].ready = false
    room.playerWSs.push(waitingList[i]);
    //room.playerWSs.ready = false;
  }
  waitingList = waitingList.slice(PLAYERS_PER_ROOM);
  rooms.push(room);
  room.playerWSs.forEach(function(ws) {
    ws.room = room;
    ws.lastFrameReceived = -1;
    ws.lastRightStatus = {};
    if(ws.readyState == 1) ws.send(JSON.stringify({
      type: 'ready-request',
      value: null
    }));
  });
}

function idRequest(ws) {
  let id = 0;
  do {
    id = Math.floor(Math.random() * 1000000000000000000);
  } while(ids.includes(id) || id == 0);
  ids.push(id);
  ws.id = id;
  if(ws.readyState == 1) ws.send(JSON.stringify({
    type: 'id-response',
    value: id
  }));
}

function epochTime(ws, message) {
  message.value.serverTime = Date.now();
  if(ws.readyState == 1) ws.send(JSON.stringify(message));
}

setInterval(function() {
  waitingList = waitingList.filter(ws => ws.readyState == 1);
  if(waitingList.length >= PLAYERS_PER_ROOM) {
    createRoom();
    console.log("Room created");
  }
}, 1000);

function sendStartData(room) {
  let t = Date.now();
  let startData = {
    snakes: [],
    startTime: Date.now() + 6000
  };
  setTimeout(function() {
    room.started = true;
  }, 6000 - (Date.now() - t));
  let pos = [{x: 15, y: 15}, {x: 870, y: 15}, {x: 15, y: 570}, {x: 870, y: 570}];
  let dir = [RIGHT, LEFT, RIGHT, LEFT];
  room.playerWSs.forEach(function(ws, i) {
    startData.snakes.push({
      id: ws.id,
      name: ws.name,
      lastInputProcessed: -1,
      x: pos[i].x,
      y: pos[i].y,
      direction: dir[i],
      frame: 0,
      alive: true,
      deadThisFrame: false,
      next: {
        x: pos[i].x,
        y: pos[i].y,
        next: {
          x: pos[i].x,
          y: pos[i].y,
          next: null
        }
      }
    });
    ws.snake = startData.snakes[startData.snakes.length - 1];
  });
  room.playerWSs.forEach(function(ws) {
    if(ws.readyState == 1) ws.send(JSON.stringify({
      type: "start-data",
      value: startData
    }));
  });
}

function roomMoveSnakes(room) {
  room.playerWSs.forEach(function(ws) {
    let currentBit = ws.snake;
    let prevBitPos = {};
    switch(ws.snake.direction) {
      case UP:
        prevBitPos = {x: ws.snake.x, y: ws.snake.y - SQUARE_SIZE}
        break;
      case DOWN:
        prevBitPos = {x: ws.snake.x, y: ws.snake.y + SQUARE_SIZE}
        break;
      case LEFT:
        prevBitPos = {x: ws.snake.x - SQUARE_SIZE, y: ws.snake.y}
        break;
      case RIGHT:
        prevBitPos = {x: ws.snake.x + SQUARE_SIZE, y: ws.snake.y}
        break;
    }
    do {
      let curPos = {x: currentBit.x, y: currentBit.y};
      currentBit.x = prevBitPos.x;
      currentBit.y = prevBitPos.y;
      if(currentBit.x < 0) {
        currentBit.x = WIDTH + currentBit.x;
      } else {
        currentBit.x %= WIDTH;
      }
      if(currentBit.y < 0) {
        currentBit.y = HEIGHT + currentBit.y;
      } else {
        currentBit.y %= HEIGHT;
      }
      prevBitPos = curPos;
      currentBit = currentBit.next;
    } while(currentBit != null);
  });
}

function createFood(room) {
  room.food.push({
    x: getRandomInt(WIDTH / SQUARE_SIZE) * SQUARE_SIZE,
    y: getRandomInt(HEIGHT / SQUARE_SIZE) * SQUARE_SIZE,
    eated: false,
    id: Math.floor(Math.random() * 1000000000000000000)
  });
}

function roomCheckCollisions(room) {
  room.playerWSs.forEach(function(ws) {
    room.food.forEach(function(f) {
      if(!f.eated && f.x == ws.snake.x && f.y == ws.snake.y && ws.snake.alive) {
        f.eated = true;
        let bit = ws.snake;
        do {
          bit = bit.next;
        } while(bit.next != null);
        bit.next = {
          x: bit.x,
          y: bit.y,
          next: null
        };
      }
    });
    room.playerWSs.forEach(function(ws2) {
      let s2 = ws2.snake;

      if((ws.snake.alive || ws.snake.deadThisFrame) && (s2.alive || s2.deadThisFrame))
      do {
        if(ws.snake.x == s2.x && ws.snake.y == s2.y && ws.snake != s2) {
          ws.snake.alive = false;
          ws.snake.deadThisFrame = true;
        }
        s2 = s2.next;
      } while(s2.next != null);
    });
  });
  room.playerWSs.forEach(function(ws) {
    ws.snake.deadThisFrame = false;
  });
  room.food = room.food.filter(food => !food.eated);
}

function getRandomInt(max) {
  return Math.floor(Math.random() * Math.floor(max));
}

function checkIfFinished(room) {
  let winner = {id: ""};
  let aliveCount = 0;
  let connectedCount = 0;
  room.playerWSs.forEach(function(ws) {
    if(ws.snake.alive == true) {
      winner = ws.snake;
      aliveCount++;
      if(ws.readyState == 1) connectedCount += 1;
    }
  });
  if(aliveCount == 0) {
    sendFinishData(room, "tie", winner);
  } else if(aliveCount == 1) {
    sendFinishData(room, "win", winner);
  }

  if(connectedCount == 0) room.finished = true;
}

function sendFinishData(room, result, winner) {
  room.playerWSs.forEach(function(ws) {
    if(ws.readyState == 1) ws.send(JSON.stringify({
      type: "finish-data",
      value: {
        result: result,
        winner: winner
      }
    }));
  });
  room.finished = true;
}

setInterval(function() {
  rooms.forEach(function(room) {
    if(room.started == false && room.ready == false && room.playerWSs.length >= PLAYERS_PER_ROOM) {
      if(room.playerWSs.filter(p => p.ready == false).length == 0) {
        room.ready = true;
        console.log("Room ready");
        sendStartData(room);
      }
    } else if(room.started == true && room.finished == false) {
      room.frame++;
      roomMoveSnakes(room);
      roomCheckCollisions(room);
      if(room.food.length < 2 && getRandomInt(20) == 0) {
        createFood(room);
      }
      let snakes = [];
      room.playerWSs.forEach(function(ws) {
        snakes.push(ws.snake);
      });
      room.playerWSs.forEach(function(ws) {
        if(ws.readyState == 1) ws.send(JSON.stringify({
          type: "update",
          value: {
            snakes: snakes,
            frame: room.frame,
            food: room.food
          }
        }));
      });
      checkIfFinished(room);
    }
    rooms = rooms.filter(room => !room.finished);
  });
}, SPEED * 1000);
