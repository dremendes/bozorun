package;

import flixel.ui.FlxButton;
import flixel.FlxSubState;

class PausadoSubState extends FlxSubState
{
	var _botaoFechar:FlxButton;

	override public function create():Void
	{
		super.create();

		_botaoFechar = new FlxButton(124, 2, "", () -> close());
		_botaoFechar.loadGraphic(AssetPaths.pausar__png, true, 60, 36);
		add(_botaoFechar);
	}

}