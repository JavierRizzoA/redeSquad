package entities;

import haxepunk.Entity;
import haxepunk.EntityList;
import haxepunk.HXP;
import haxepunk.graphics.Image;


class Snake extends EntityList<Entity> {
  public var color:Int;
  public var id:Int;
  public var head:SnakeBit;
  public var direction:Direction;
  private var lastDirection:Direction;
  private var alive:Bool;

  public function new(startData:Dynamic) {
    super();
    if(startData.id == Globals.id)
      color = 0xFF0000;
    else
      color = 0x0000FF;
    direction = startData.direction;
    id = startData.id;
    head = new SnakeBit(startData.x, startData.y, this);
    alive = startData.alive;
    add(head);

    var bit:SnakeBit = head;
    while(startData.next != null) {
      bit.next = new SnakeBit(startData.next.x, startData.next.y, this);
      add(bit.next);
      startData = startData.next;
      bit = bit.next;
    }
    //add(head);
    //head.addBit();
    //head.addBit();
    //head.addBit();
    //head.addBit();
  }

  override public function update() {
    if(Globals.updateFrame) {
      head.move(direction);
      lastDirection = direction;
    }
    super.update();
  }

  public function fromDynamic(dyn:Dynamic) {
    direction = dyn.direction;
    alive = dyn.alive;
    if(!alive) {
      HXP.scene.remove(this);
      return;
    }
    head.fromDynamic(dyn);
    if(id == Globals.id) {
      var playable:PlayableSnake = cast(this, PlayableSnake);
      direction = playable.inputs[playable.inputs.length - 1].direction;
    }
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
    /*var e:Entity = collide("food", x, y);
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

    }*/
    if(x < 0) {
      x = HXP.width + x;
    } else {
      x = x % HXP.scene.width;
    }

    if(y < 0) {
      y = HXP.height + y;
    } else {
      y = y % HXP.scene.height;
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

  public function fromDynamic(dyn:Dynamic) {
    x = dyn.x;
    y = dyn.y;
    if(dyn.next != null) {
      if(next != null) {
        next.fromDynamic(dyn.next);
      } else {
        trace("adding next");
        next = new SnakeBit(x, y, snake);
        snake.add(next);
        next.fromDynamic(dyn.next);
      }
    }
  }
}
