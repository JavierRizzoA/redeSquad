/*
   This file is part of redeSquad.

   redeSquad is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   redeSquad is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along withredeSquad .  If not, see <http://www.gnu.org/licenses/>.
 */
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
