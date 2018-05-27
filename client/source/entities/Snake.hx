package entities;

import haxepunk.Entity;
import haxepunk.EntityList;
import haxepunk.HXP;
import haxepunk.graphics.Image;


class Snake extends EntityList<Entity> {
  public var color:Int;
  public var head:SnakeBit;
  private var direction:Direction;

  public function new(
      x:Float,
      y:Float,
      color:Int,
      direction:Direction = Direction.RIGHT) {
    super();
    this.color = color;
    this.direction = direction;
    head = new SnakeBit(x, y, this);
    add(head);
    head.addBit();
    head.addBit();
    head.addBit();
    head.addBit();
  }

  override public function update() {
    if(Globals.updateFrame)
      head.move(direction);
    super.update();
  }
}

@:enum
abstract Direction(Int) {
  var UP = 0;
  var DOWN = 1;
  var LEFT = 2;
  var RIGHT = 3;
}


class SnakeBit extends Entity {
  private var image:Image;
  public var next:SnakeBit;
  private var snake:Snake;

  public function new(x:Float, y:Float, snake:Snake) {
    super(x, y);
    this.snake = snake;
    image = Image.createRect(Globals.SQUARE_SIZE, Globals.SQUARE_SIZE, snake.color);
    setHitbox(Globals.SQUARE_SIZE, Globals.SQUARE_SIZE);
    type = "snake";
    graphic = image;
    next = null;
  }

  override public function update() {
    var e:Entity = collide("food", x, y);
    if(e != null) {
      HXP.scene.remove(e);
      Globals.food = null;
      addBit();
    }

    if(this == snake.head) {
      e = collide("snake", x, y);
      if(e != null && snake.head.collideWith(snake.head.next, x, y) == null) {
        HXP.scene.remove(snake);
      }

      if(x < 0 || x > HXP.scene.width - Globals.SQUARE_SIZE || y < 0 || y > HXP.scene.height - Globals.SQUARE_SIZE)
        HXP.scene.remove(snake);
    }
    super.update();
  }

  public function move(direction:Direction) {
    if(next != null) {
      next.moveMiddle(x, y);
    }

    switch(direction) {
      case Direction.UP:
        y -= Globals.SQUARE_SIZE;
      case Direction.DOWN:
        y += Globals.SQUARE_SIZE;
      case Direction.LEFT:
        x -= Globals.SQUARE_SIZE;
      case Direction.RIGHT:
        x += Globals.SQUARE_SIZE;
    }
  }

  public function moveMiddle(x:Float, y:Float) {
    if(next != null) {
      next.moveMiddle(this.x, this.y);
    }
    this.x = x;
    this.y = y;
  }

  public function addBit() {
    if(next == null) {
      next = new SnakeBit(x, y, snake);
      snake.add(next);
    } else {
      next.addBit();
    }
  }
}
