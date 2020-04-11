package;

import flixel.ui.FlxButton;
import flixel.FlxSubState;

class PausadoSubState extends FlxSubState
{
	private var _botaoFechar:FlxButton;
	private var _paddingTop:Float = (flixel.FlxG.height - 300) / 2;

	override public function create():Void
	{
		super.create();

		_botaoFechar = new FlxButton(124, 2 + _paddingTop, "", () -> close());
		_botaoFechar.loadGraphic(AssetPaths.pausar__png, true, 60, 36);
		add(_botaoFechar);
	}

}