package entities;

import haxepunk.input.Key;

class PlayableSnake2 extends Snake {

  public function new(
      x:Float,
      y:Float,
      color:Int,
      direction:Snake.Direction = Snake.Direction.RIGHT) {
    super(x, y, color, direction);

  }

  override public function update() {
    if(Key.check(Key.W) && direction != Snake.Direction.DOWN) {
      this.direction = Snake.Direction.UP;
    } if(Key.check(Key.S) && direction != Snake.Direction.UP) {
      this.direction = Snake.Direction.DOWN;
    }
    if(Key.check(Key.A) && direction != Snake.Direction.RIGHT) {
      this.direction = Snake.Direction.LEFT;
    }
    if(Key.check(Key.D) && direction != Snake.Direction.LEFT) {
      this.direction = Snake.Direction.RIGHT;
    }
    super.update();
  }

}
