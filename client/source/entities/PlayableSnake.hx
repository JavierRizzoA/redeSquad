package entities;

import haxe.Json;
import haxepunk.input.Key;

class PlayableSnake extends Snake {
  public var inputs:Array<Dynamic>;
  public function new(startData:Dynamic) {
    super(startData);
    inputs = new Array<Dynamic>();
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

    if(Globals.updateFrame && direction != lastDirection) {
      inputs.push({
        frame: Globals.frameN,
        direction: direction,
        inputId: inputs.length
      });
      Globals.ws.sendString(Json.stringify({
        type: "input",
        value: inputs[inputs.length - 1]
      }));
    }
    super.update();
  }
}
