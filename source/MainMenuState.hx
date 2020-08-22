package;

import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import extension.admob.AdMob;
import extension.admob.GravityMode;

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
		AdMob.enableTestingAds();
		AdMob.onInterstitialEvent = onInterstitialEvent;
		AdMob.initAndroid("ca-app-pub-6476709060042535/2529633910", "ca-app-pub-6476709060042535/9946580195",
			GravityMode.BOTTOM); 

		// FlxG.debugger.visible = true;
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		FlxG.camera.antialiasing = true;

		var division:Int = Std.int(FlxG.height / 3);

		#if html5
		FlxG.mouse.visible = true;
		#end
		fundoCeu = new FlxBackdrop(AssetPaths.sky__png, -2, 0, true, false, 0, 0);
		fundoCeu.scale.set(FlxG.width / 300, FlxG.height / 300);
		fundoCeu.y -= 40;
		fundoCeu.velocity.x = -20;
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
		pato.setPosition(180, 160);
		pato.setFacingFlip(FlxObject.RIGHT, false, false);
		pato.setFacingFlip(FlxObject.LEFT, true, false);
		pato.facing = FlxObject.LEFT;
		pato.x += paddingSide;
		pato.y += paddingTop;
		add(pato);
		bozoEspirra = new FlxSprite();
		bozoEspirra.loadGraphic(AssetPaths.bozotile__png, true, 69, 80, true);
		bozoEspirra.animation.add("idle", [26, 27, 28, 29, 30, 31, 32, 33, 35, 34, 35, 36, 37, 38, 39, 40, 41, 42, 35], 4, true);
		bozoEspirra.animation.play("idle");
		bozoEspirra.setPosition(0, 200);
		bozoEspirra.x += paddingSide;
		bozoEspirra.y += paddingTop * 2;
		add(bozoEspirra);
		bozoRun = new FlxSprite();
		bozoRun.loadGraphic(AssetPaths.Jair__png, true, 104, 122, true);
		bozoRun.animation.add("arminha_com_a_mao", [20, 19], 4, true);
		bozoRun.animation.play("arminha_com_a_mao");
		bozoRun.setPosition(180, 160);
		bozoRun.x += paddingSide;
		bozoRun.y += paddingTop * 2;
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

		BtnColetiva = new FlxButton(10, division * 1.5 + 40, "", () ->
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
		BtnRun.setPosition(200 + paddingSide, 112 + paddingTop * 2);
		BtnRun.scale.set(FlxG.width / 300, FlxG.height / 300);
		BtnRun.updateHitbox();
		add(BtnRun);
		FlxG.sound.playMusic(AssetPaths.bozosong__ogg); // música de fundo
	}

	static private inline function onInterstitialEvent(event:String)
		{
			trace("THE INSTERSTITIAL IS " + event);
			/*
				Note that the "event" String will be one of this:
					AdMob.LEAVING
					AdMob.FAILED
					AdMob.CLOSED
					AdMob.DISPLAYING
					AdMob.LOADED
					AdMob.LOADING
	
				So, you can do something like:
				if(event == AdMob.CLOSED) trace("The player dismissed the ad!");
				else if(event == AdMob.LEAVING) trace("The player clicked the ad :), and we're leaving to the ad destination");
				else if(event == AdMob.FAILED) trace("Failed to load the ad... the extension will retry automatically.");
			 */
		}

	override public function update(elapsed:Float):Void
	{
		aviao.x += 0.8;

		if (aviao.x >= 450 + paddingSide)
			aviao.x = -40 + paddingSide;

		pato.x += 0.4 * multiplier;

		if (pato.x >= 270 + paddingSide)
		{
			multiplier = multiplier * -1;
			pato.facing = FlxObject.RIGHT;
		}

		if (pato.x <= 180 + paddingSide)
		{
			pato.facing = FlxObject.LEFT;
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
		BtnRun.destroy();
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
