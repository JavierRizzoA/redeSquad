package scenes;

import haxepunk.HXP;
import haxepunk.Scene;
import entities.Food;
import entities.PlayableSnake;
import entities.Snake;

class GameScene extends Scene {
  private var snakes:Array<Snake>;
  private var delta:Float;
  private var food:Array<Food>;
  override public function begin() {
    super.begin();
    snakes = new Array<Snake>();
    food = new Array<Food>();
    for(i in 0 ... Globals.startData.snakes.length) {
      if(Globals.startData.snakes[i].id == Globals.id) {
        snakes.push(new PlayableSnake(Globals.startData.snakes[i]));
      } else {
        snakes.push(new Snake(Globals.startData.snakes[i]));
      }
    }
    for(snake in snakes) {
      add(snake);
    }
    delta = 0;
    Globals.updateFrame = false;
    Globals.frameN = 0;
  }

  override public function update() {
    if(Globals.updateFrame) {
      Globals.updateFrame = false;
    }

    delta += HXP.elapsed;
    if(delta >= Globals.SPEED) {
      delta -= Globals.SPEED;
      Globals.updateFrame = true;
      Globals.frameN++;
    }

    /*if(Globals.food == null) {
      Globals.food = new entities.Food(Std.random(Math.floor(HXP.width / Globals.SQUARE_SIZE)) * Globals.SQUARE_SIZE, Std.random(Math.floor(HXP.height / Globals.SQUARE_SIZE)) * Globals.SQUARE_SIZE);
      add(Globals.food);
      }*/

    if(Globals.updated == false) {
      Globals.updated = true;
      for(i in 0 ... Globals.updateData.snakes.length) {
        for(s in snakes) {
          if(s.id == Globals.updateData.snakes[i].id) {
            s.fromDynamic(Globals.updateData.snakes[i]);
            break;
          }
        }
      }

      removeList(food);
      food = new Array<Food>();
      for( i in 0 ... Globals.updateData.food.length) {
        if(!Globals.updateData.food[i].eated)
          food.push(new Food(Globals.updateData.food[i].x, Globals.updateData.food[i].y));
      }
      addList(food);

      /*if(Globals.frameN > Globals.updateData.frame) {
        delta = 0;
      } else {
        for(i in Globals.frameN ... Globals.updateData.frame) {
          for(snake in snakes) {
            snake.head.move(snake.direction);
          }
        }
      }*/
    }

    super.update();
  }
}
