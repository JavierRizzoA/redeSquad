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
