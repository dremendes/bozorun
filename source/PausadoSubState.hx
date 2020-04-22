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

		_botaoPausar = new FlxButton(FlxG.width / 2 - 35, FlxG.height / 2 - 48, "", () -> {if (tocarSons) FlxG.sound.play(AssetPaths.beepbotao__ogg); close();});
		_botaoPausar.loadGraphic(AssetPaths.pausar__png, true, 60, 34);
		add(_botaoPausar);
		
		_botaoToogleSons = new FlxButton(FlxG.width / 2 - 20, FlxG.height / 2, "", () -> tocarSons = !tocarSons);
		_botaoToogleSons.loadGraphic(AssetPaths.botaosom__png, true, 12, 11);
		_botaoToogleSons.animation.add("pressionado", [2], false);
		_botaoToogleSons.scale.set(3, 3);
		_botaoToogleSons.updateHitbox();
		add(_botaoToogleSons);

		_botaoToogleMusica = new FlxButton(FlxG.width / 2 - 20, FlxG.height / 2 + 40, "", () -> {if (tocarSons) FlxG.sound.play(AssetPaths.beepbotao__ogg); tocarMusica = !tocarMusica;});
		_botaoToogleMusica.loadGraphic(AssetPaths.botaomusica__png, true, 12, 11);
		_botaoToogleMusica.animation.add("pressionado", [2], false);
		_botaoToogleMusica.scale.set(3, 3);
		_botaoToogleMusica.updateHitbox();
		add(_botaoToogleMusica);
	}

	override public function update(elapsed:Float):Void
	{
		!tocarMusica ? FlxG.sound.pause() : FlxG.sound.resume();
		!tocarMusica ? _botaoToogleMusica.animation.play("pressionado") : _botaoToogleMusica.animation.stop();
		!tocarSons ? _botaoToogleSons.animation.play("pressionado") : _botaoToogleSons.animation.stop();
		super.update(elapsed);
	}
}