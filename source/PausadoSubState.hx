package;

import flixel.ui.FlxButton;
import flixel.FlxSubState;

class PausadoSubState extends FlxSubState
{
	private var _botaoFechar:FlxButton;
	private var tocarMusica:Bool=true;
	private var tocarSons:Bool=true;
	

	override public function create():Void
	{
		super.create();

		_botaoFechar = new FlxButton(124, 2, "", () -> close());
		_botaoFechar.loadGraphic(AssetPaths.pausar__png, true, 60, 34);
		add(_botaoFechar);
	}

	public function toggleMusic() tocarMusica != tocarMusica;
	public function toggleSons() tocarSons != tocarSons;

}