import haxepunk.HXP;
import haxepunk.Scene;

class MainScene extends Scene {
  private var delta:Float;
	override public function begin() {
    delta = 0;
    Globals.updateFrame = false;
    var snake:entities.Snake = new entities.PlayableSnake(Globals.SQUARE_SIZE, Globals.SQUARE_SIZE, 0xFF0000);
    var snake2:entities.Snake = new entities.PlayableSnake2(Globals.SQUARE_SIZE, Globals.SQUARE_SIZE * 5, 0x0000FF);
    add(snake);
    add(snake2);
	}

  public override function update() {
    if(Globals.updateFrame) {
      Globals.updateFrame = false;
    }

    delta += HXP.elapsed;
    if(delta >= Globals.SPEED) {
      delta -= Globals.SPEED;
      Globals.updateFrame = true;
    }
    super.update();

    if(Globals.food == null) {
      Globals.food = new entities.Food(Std.random(Math.floor(HXP.width / Globals.SQUARE_SIZE)) * Globals.SQUARE_SIZE, Std.random(Math.floor(HXP.height / Globals.SQUARE_SIZE)) * Globals.SQUARE_SIZE);
      add(Globals.food);
    }
  }
}
