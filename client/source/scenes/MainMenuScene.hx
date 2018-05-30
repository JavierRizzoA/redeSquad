package scenes;

import haxe.net.WebSocket;
import haxepunk.HXP;
import haxepunk.Scene;
import haxepunk.graphics.text.Text;
import haxepunk.graphics.Image;
import haxepunk.input.Key;
import haxe.Json;

class MainMenuScene extends Scene {

  private var playButton:entities.ui.Button;
  private var playButtonAdded:Bool;
  private var timeRequested:Bool;
  private var name:Text;

  override public function begin() {
    super.begin();
    playButton = new entities.ui.Button(0, 0, "PLAY", 0x000000);
    playButton.onClick = function() {
      if (name.text != "") {
        Globals.ws.sendString(Json.stringify({
          type: "play-request",
          value: {
            name: name.text
          }
        }));
        remove(playButton);
      }
    };
    playButton.x = HXP.halfWidth - playButton.width / 2;
    playButton.y = HXP.halfHeight;
    playButtonAdded = false;

    var eynText:Text = new Text("ENTER YOUR NAME:", 0, 0, 0, 0, {size: 30, color: 0xFFFFFF});
    name = new Text("", 0, 0, 0, 0, {size: 30, color: 0xFFFFFF});
    addGraphic(eynText, 0, HXP.halfWidth - eynText.width / 2);
    addGraphic(name, 0, 10, 50);
    addGraphic(Image.createRect(HXP.width, 5, 0xFFFFFF), 0, 0, 100);
    timeRequested = false;
    Key.keyString = "";
  }

  public override function update() {
    if(!timeRequested && Globals.id != 0) {
      Globals.requestTimeSync();
      timeRequested = true;
    }

    if(!playButtonAdded && Globals.times.length >=1) {
      add(playButton);
      playButtonAdded = true;
      var latency:Float = Globals.times[0].value.receivedTime - Globals.times[0].value.sentTime;
      Globals.timeDelta = Std.int(Globals.times[0].value.serverTime - Globals.times[0].value.sentTime - latency / 2);
      trace("Time delta: " + Globals.timeDelta);
    }

    name.text = Key.keyString;

    super.update();
    /*timeSinceTimeSync += HXP.elapsed;
      if(timeSinceTimeSync >= 1 && Globals.times.length < 5) {
      timeSinceTimeSync = 0;
      Globals.requestTimeSync();
      }

      if(Globals.times.length >= 5 && !playButtonAdded) {
      add(playButton);
      trace("Times N: " + Globals.times.length);
      var latencies:Array<Float> = new Array<Float>();
      for(t in Globals.times) {
      latencies.push(t.value.receivedTime - t.value.sentTime);
      }
      trace("Average latency: " + Utils.average(latencies) + "ms");
      trace("Standard Deviation latency: " + Utils.sdev(latencies) + "ms");
      trace("Median latency: " + Utils.median(latencies) + "ms");
      for(t in Globals.times) {
      if(t.value.receivedTime - t.value.sentTime == Utils.median(latencies)) {

      }
      }
      playButtonAdded = true;
      }*/
  }
}
