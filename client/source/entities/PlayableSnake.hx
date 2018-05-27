package entities;

import haxepunk.input.Key;

class PlayableSnake extends Snake {

  public function new(
      x:Float,
      y:Float,
      color:Int,
      direction:Snake.Direction = Snake.Direction.RIGHT) {
    super(x, y, color, direction);

  }

  override public function update() {
    if(Key.check(Key.UP) && direction != Snake.Direction.DOWN) {
      this.direction = Snake.Direction.UP;
    } else if(Key.check(Key.DOWN) && direction != Snake.Direction.UP) {
      this.direction = Snake.Direction.DOWN;
    } else if(Key.check(Key.LEFT) && direction != Snake.Direction.RIGHT) {
      this.direction = Snake.Direction.LEFT;
    } else if(Key.check(Key.RIGHT) && direction != Snake.Direction.LEFT) {
      this.direction = Snake.Direction.RIGHT;
    }
    super.update();
  }

}
