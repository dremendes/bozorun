package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import extension.eightsines.EsOrientation;
import flixel.system.scaleModes.BaseScaleMode;
import flixel.util.FlxDirectionFlags;
/**
 * Based on work from
 * william.thompsonj
 */
class MainMenuState extends FlxState
{
	private var background:FlxSprite;
	private var bozoEspirra:FlxSprite;
	private var bozoRun:FlxSprite;
	private var BtnRun:FlxButton;
	private var BtnColetiva:FlxButton;
	private var pato:FlxSprite;
	private var aviao:FlxSprite;
	private var pedestal:FlxSprite;
	private var multiplier:Float = 1.0;
	private var stringTitulo:InaraString;
	private var paddingSide:Float = (FlxG.width - 300) / 2;
	private var paddingTop:Float = (FlxG.height - 300) / 2;
	private var fundoCeu:FlxBackdrop;

	override public function create():Void
	{
		EsOrientation.setScreenOrientation(EsOrientation.ORIENTATION_LANDSCAPE);
		FlxG.scaleMode = new BaseScaleMode();

		// FlxG.debugger.visible = true;
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		FlxG.camera.antialiasing = false;

		#if html5
		FlxG.mouse.visible = true;
		#end
		fundoCeu = new FlxBackdrop(AssetPaths.sky__png, flixel.util.FlxAxes.X, 0, 0);
		fundoCeu.y -= 40;
		fundoCeu.velocity.x = 1;
		add(fundoCeu);
		aviao = new FlxSprite().loadGraphic(AssetPaths.aviao__png, true, 91, 17);
		aviao.animation.add("voando", [0, 1], 10, true);
		aviao.animation.play("voando");
		aviao.setPosition(-40, 40);
		add(aviao);
		background = new FlxSprite();
		background.loadGraphic(AssetPaths.senado_bg__png, true, 300, 300);
		background.animation.add("idle", [0, 1, 2], 3, true);
		background.animation.play("idle");
		background.x += paddingSide;
		background.y += paddingTop;
		background.scale.set(FlxG.width / 300, FlxG.height / 300);
		add(background);
		pato = new FlxSprite().loadGraphic(AssetPaths.patin__png, false, 30, 29);
		pato.setPosition(180, 150);
		pato.setFacingFlip(FlxDirectionFlags.RIGHT, false, false);
		pato.setFacingFlip(FlxDirectionFlags.LEFT, true, false);
		pato.facing = FlxDirectionFlags.LEFT;
		pato.x += paddingSide;
		pato.y += paddingTop;
		add(pato);
		bozoEspirra = new FlxSprite();
		bozoEspirra.loadGraphic(AssetPaths.bozotile__png, true, 69, 80, true);
		bozoEspirra.animation.add("idle", [26, 27, 28, 29, 30, 31, 32, 33, 35, 34, 35, 36, 37, 38, 39, 40, 41, 42, 35], 4, true);
		bozoEspirra.animation.play("idle");
		bozoEspirra.setPosition(40, 200);
		bozoEspirra.x += paddingSide;
		bozoEspirra.y += paddingTop * 2;
		add(bozoEspirra);
		bozoRun = new FlxSprite();
		bozoRun.loadGraphic(AssetPaths.Jair__png, true, 104, 122, true);
		bozoRun.animation.add("arminha_com_a_mao", [20, 19], 4, true);
		bozoRun.animation.play("arminha_com_a_mao");
		bozoRun.setPosition(180, 100);
		bozoRun.x += paddingSide;
		bozoRun.y += paddingTop * 2 + 50;
		bozoRun.scale.set(1,1.1);
		add(bozoRun);
		pedestal = new FlxSprite().loadGraphic(AssetPaths.pedestal__png, false, 12, 102);
		pedestal.setPosition(255, 180);
		pedestal.x += paddingSide;
		pedestal.y += paddingTop * 2;
		add(pedestal);
		#if android
		stringTitulo = new InaraString("bozorun", 10 + paddingSide, 60 + paddingTop, 280 * (FlxG.width / 300), 0, 0, FlxG.width / 300, FlxG.height / 300);
		#else
		stringTitulo = new InaraString("bozorun", 70 + paddingSide, 60 + paddingTop, 280, 0, 0);
		#end
		add(stringTitulo);
		stringTitulo._chars.group.forEach(function(letra)
		{
			add(letra);
		});

		BtnColetiva = new FlxButton(10, Std.int(FlxG.height / 3) * 1.5 + 40, "", () ->
		{
			FlxG.sound.play(AssetPaths.beepbotao__ogg);
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> FlxG.switchState(new ColetivaGameState()));
		});
		BtnColetiva.label.size = 20;
		BtnColetiva.loadGraphic(AssetPaths.coletiva__png, true, 60, 34);
		BtnColetiva.scale.set(1.6, .9);
		BtnColetiva.setPosition(35 + paddingSide, BtnColetiva.y += 25);
		BtnColetiva.scale.set(FlxG.width / 300, FlxG.height / 300);
		BtnColetiva.updateHitbox();
		// add(BtnColetiva);
		BtnRun = new FlxButton(0, 0, "", () ->
		{
			FlxG.sound.play(AssetPaths.beepbotao__ogg);
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> FlxG.switchState(new BozoRunGameState()));
		});
		BtnRun.label.size = 20;
		BtnRun.loadGraphic(AssetPaths.fugir__png, true, 60, 34);
		BtnRun.setPosition(FlxG.width * 0.25, FlxG.height * 0.35);
		BtnRun.scale.set(FlxG.width / 300, FlxG.height / 300);
		BtnRun.updateHitbox();
		add(BtnRun);
		FlxG.sound.playMusic(AssetPaths.bozosong__ogg); // música de fundo
	}

	static private inline function onInterstitialEvent(event:String){}

	override public function update(elapsed:Float):Void
	{
		aviao.x += 0.8;

		if (aviao.x >= 450 + paddingSide)
			aviao.x = -40 + paddingSide;

		pato.x += 0.4 * multiplier;

		if (pato.x >= 270 + paddingSide)
		{
			multiplier = multiplier * -1;
			pato.facing = FlxDirectionFlags.RIGHT;
		}

		if (pato.x <= 180 + paddingSide)
		{
			pato.facing = FlxDirectionFlags.LEFT;
			multiplier = multiplier * -1;
		}

		super.update(elapsed);
	}

	override public function destroy():Void
	{
		background.destroy();
		BtnRun.destroy();
		bozoEspirra.destroy();
		bozoRun.destroy();
		BtnColetiva.destroy();
		fundoCeu.destroy();
		pato.destroy();
		aviao.destroy();
		pedestal.destroy();
		stringTitulo.destroy();
		background = null;
		BtnRun = null;

		super.destroy();
	}
}
