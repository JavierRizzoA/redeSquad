package entities;

import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.graphics.Image;

class Food extends Entity {
  private var image:Image;
  public var id:Int;

  public function new(x:Float, y:Float, id:Int = 0) {
    super(x, y);
    image = Image.createRect(Globals.SQUARE_SIZE, Globals.SQUARE_SIZE, 0xFFFF00);
    graphic = image;
    this.id = id;
    setHitbox(Globals.SQUARE_SIZE, Globals.SQUARE_SIZE);
    type = "food";
  }
}
