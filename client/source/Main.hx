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
import haxepunk.Engine;
import haxepunk.HXP;

class Main extends Engine {
	static function main() {
		new Main();
	}

	override public function init() {
#if debug
    haxepunk.debug.Console.enable();
#end
		HXP.scene = new scenes.MainMenuScene();
    Globals.createSocket();
	}
}
