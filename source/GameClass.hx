package;

import flash.Lib;
import flixel.FlxGame;

class GameClass extends FlxGame
{
	public function new()
	{
		var gameWidth:Int = 300; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
		var gameHeight:Int = 300; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
		var zoom:Float;
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		var ratioX:Float = stageWidth / gameWidth;
		var ratioY:Float = stageHeight / gameHeight;
		zoom = Math.min(ratioX, ratioY);
		gameWidth = Math.ceil(stageWidth / zoom);
		gameHeight = Math.ceil(stageHeight / zoom);

		super(gameWidth, gameHeight, MainMenuState, zoom, 60, 60, true, true);
	}
}
