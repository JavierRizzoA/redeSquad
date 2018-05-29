package scenes;

import haxepunk.HXP;
import haxepunk.Scene;
import haxepunk.graphics.text.Text;
import flash.text.TextFormatAlign;

class LobbyScene extends Scene {

  private var playersText:Text;
  private var startText:Text;
  override public function begin() {
    super.begin();
    playersText = new Text("", HXP.halfWidth, 0, 0, 0, {align: openfl.text.TextFormatAlign.CENTER, color: 0xFFFFFF, size: 20});
    for(i in 0 ... Globals.startData.snakes.length) {
      playersText.text += Globals.startData.snakes[i].id + "\n";
    }
    addGraphic(playersText);
    startText = new Text("", HXP.halfWidth, HXP.halfHeight, 0, 0, {align: openfl.text.TextFormatAlign.CENTER, color: 0xFFFFFF, size: 40});
    addGraphic(startText);
  }

  override public function update() {
    var time = Math.max(Math.floor((Globals.startData.startTime - (Date.now().getTime() + Globals.timeDelta)) / 1000), 0);
    startText.text = "" + time;
    if(time <= 0) {
      HXP.scene = new scenes.GameScene();
    }
    super.update();
  }
}
