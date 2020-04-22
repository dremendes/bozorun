package;

import flixel.ui.FlxButton;
import flixel.FlxSubState;
import flixel.FlxG;

class PausadoSubState extends FlxSubState
{
	private var _botaoPausar:FlxButton;
	private var _botaoToogleMusica:FlxButton;
	private var _botaoToogleSons:FlxButton;
	public var tocarMusica:Bool=true;
	public var tocarSons:Bool=true;
	

	override public function create():Void
	{
		super.create();

		_botaoPausar = new FlxButton(FlxG.width / 2 - 35, FlxG.height / 2 - 48, "", () -> close());
		_botaoPausar.loadGraphic(AssetPaths.pausar__png, true, 60, 34);
		add(_botaoPausar);

		_botaoToogleMusica = new FlxButton(FlxG.width / 2 - 20, FlxG.height / 2, "", () -> {tocarMusica = !tocarMusica; !tocarMusica ? FlxG.sound.pause() : FlxG.sound.resume();});
		_botaoToogleMusica.loadGraphic(AssetPaths.botaomusica__png, true, 12, 11);
		_botaoToogleMusica.animation.add("pressionado", [2], false);
		_botaoToogleMusica.scale.set(3, 3);
		_botaoToogleMusica.updateHitbox();
		add(_botaoToogleMusica);

		_botaoToogleSons = new FlxButton(FlxG.width / 2 - 20, FlxG.height / 2 + 40, "", () -> tocarSons = !tocarSons);
		_botaoToogleSons.loadGraphic(AssetPaths.botaosom__png, true, 12, 11);
		_botaoToogleSons.animation.add("pressionado", [2], false);
		_botaoToogleSons.scale.set(3, 3);
		_botaoToogleSons.updateHitbox();
		add(_botaoToogleSons);
	}

	override public function update(elapsed:Float):Void
	{
		!tocarMusica ? _botaoToogleMusica.animation.play("pressionado") : _botaoToogleMusica.animation.stop();
		!tocarSons ? _botaoToogleSons.animation.play("pressionado") : _botaoToogleMusica.animation.stop();
		super.update(elapsed);
	}
}