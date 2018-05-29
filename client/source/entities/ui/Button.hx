package entities.ui;

import haxepunk.Entity;
import haxepunk.graphics.Graphiclist;
import haxepunk.graphics.Image;
import haxepunk.graphics.text.Text;
import haxepunk.input.Mouse;

class Button extends Entity {

  private static inline var MARGIN_X:Int = 5;
  private static inline var MARGIN_Y:Int = 5;

  private var graphiclist:Graphiclist;
  private var text:Text;
  private var square:Image;

  public function new(
      x:Float,
      y:Float,
      text:String,
      color:Int) {
    super(x, y);
    graphiclist = new Graphiclist();
    graphic = graphiclist;
    this.text = new Text(text, MARGIN_X, MARGIN_Y, 0, 0, {size: 20});
    square = Image.createRect(this.text.width + MARGIN_X * 2, this.text.height + MARGIN_Y * 2, color);
    graphiclist.add(square);
    graphiclist.add(this.text);
    setHitbox(square.width, square.height);
  }

  public override function update() {
    if(collidePoint(x, y, Mouse.mouseX, Mouse.mouseY)) {
      graphic.alpha = 0.5;
      if(Mouse.mouseReleased) {
        onClick();
      }
    } else {
      graphic.alpha = 1;
    }
    super.update();
  }

  public dynamic function onClick() {
  }
}
