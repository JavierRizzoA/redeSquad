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
    playersText = new Text("", 0, 0, 0, 0, {align: openfl.text.TextFormatAlign.CENTER, color: 0xFFFFFF, size: 20});
    for(i in 0 ... Globals.startData.snakes.length) {
      playersText.text += Globals.startData.snakes[i].name + "\n";
    }
    addGraphic(playersText, 0, HXP.halfWidth - playersText.width, 30);
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
