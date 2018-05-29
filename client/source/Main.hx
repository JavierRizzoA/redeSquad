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
