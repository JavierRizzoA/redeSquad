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

class FinishScene extends Scene {
  private var result:String;
  private var winner:String;
  public function new(result:String, winner:String) {
    super();
    this.result = result;
    this.winner = winner;
  }

  override public function begin() {
    super.begin();
    var text:Text = new Text("", 0, 0, 0, 0, {size: 20, color: 0xFFFFFF});
    if(result == ("tie")) {
      text.text = "IT'S A TIE";
    } else {
      text.text = "WINNER: " + winner;
    }
    addGraphic(text, 0, HXP.halfWidth - text.width / 2, HXP.halfHeight - text.height / 2);
  }
}
