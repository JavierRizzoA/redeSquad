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
import haxe.Json;
import haxe.net.WebSocket;
import haxepunk.HXP;

class Globals {
  public static inline var SQUARE_SIZE:Int = 15;
  public static inline var SPEED:Float = 0.10;
  public static inline var SERVER = "ws://javierrizzo.com:18813";
  public static var updateFrame:Bool = false;
  public static var food:entities.Food = null;
  public static var ws:WebSocket;
  public static var id:Int = 0;
  public static var times:Array<Dynamic> = new Array<Dynamic>();
  public static var timeDelta:Int = 0;
  public static var startData:Dynamic;
  public static var frameN:Int;
  public static var updateData:Dynamic;
  public static var updated:Bool = true;

  public static function createSocket() {
    ws = WebSocket.create(SERVER, ['echo-protocol'], false);
    Globals.ws.onopen = function() {
      trace("Connected to socket server");
      ws.sendString(Json.stringify({
        type: "id-request",
        value: null
      }));
    };
    Globals.ws.onmessageString = function(messageStr) {
      var message:Dynamic = Json.parse(messageStr);
      switch(message.type) {
        case "id-response":
          Globals.id = message.value;
          trace("ID: " + Globals.id);
        case "epoch-time":
          message.value.receivedTime = Date.now().getTime();
          times.push(message);
        case "ready-request":
          ws.sendString(Json.stringify({
            type: "ready-response",
            value: null
          }));
        case "start-data":
          startData = message.value;
          HXP.scene = new scenes.LobbyScene();
        case "update":
          updateData = message.value;
          updated = false;
        case "finish-data":
          HXP.scene = new scenes.FinishScene(message.value.result, message.value.winner.name);
      }
    };
    Globals.ws.onerror = function(messageStr) {
      trace("Error: " + messageStr);
      //TODO: Go back to main menu and retry connection.
      //TODO: Maybe add onclose() too.
    };
  }

  public static function requestTimeSync() {
    ws.sendString(Json.stringify({
      type: "epoch-time",
      value: {
        sentTime: Date.now().getTime()
      }
    }));
  }
}
