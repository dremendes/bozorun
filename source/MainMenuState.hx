package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxObject;
import flixel.util.FlxColor;
import extension.eightsines.EsOrientation;

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
	private var ceu:FlxSprite;
	private var pato:FlxSprite;
	private var aviao:FlxSprite;
	private var pedestal:FlxSprite;
	private var multiplier:Float=1.0;
	private var stringTitulo:InaraString;
	private var paddingSide:Float = (FlxG.width - 300) / 2;
	
	override public function create():Void
	{
		FlxG.debugger.visible = true;
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		FlxG.camera.antialiasing = true;
		EsOrientation.setScreenOrientation(EsOrientation.ORIENTATION_LANDSCAPE);
		
		var division:Int = Std.int(FlxG.height / 3);

		#if html5
		FlxG.mouse.visible = true;
		#end

		ceu = new FlxSprite().loadGraphic(AssetPaths.sky__png, false, 301, 300);
		ceu.scale.set(0.995, 1);
		ceu.updateHitbox();
		ceu.y -= 70;
		ceu.x += paddingSide;
		
		#if android
		ceu.scale.set(FlxG.width/300, FlxG.height/300);
		#end

		add(ceu);
		
		aviao = new FlxSprite().loadGraphic(AssetPaths.aviao__png, true, 86, 17);
		aviao.animation.add("voando", [0,1], 10, true);
		aviao.animation.play("voando");
		aviao.setPosition(0, 20);
		aviao.x += paddingSide;
		
		#if android
		aviao.scale.set(FlxG.width/300, FlxG.height/300);
		#end

		add(aviao);
		
		background = new FlxSprite();
		background.loadGraphic(AssetPaths.senado_bg__png, true, 300, 300);
		background.animation.add("idle", [0, 1, 2], 3, true);
		background.animation.play("idle");
		background.x += paddingSide;
		
		#if android
		background.scale.set(FlxG.width/300, FlxG.height/300);
		#end

		add(background);
		
		pato = new FlxSprite().loadGraphic(AssetPaths.patin__png, false, 30, 29);
		pato.setPosition(180,160);
		pato.setFacingFlip(FlxObject.RIGHT, false, false);
		pato.setFacingFlip(FlxObject.LEFT, true, false);
		pato.facing = FlxObject.LEFT;
		pato.x += paddingSide;
		
		#if android
		pato.scale.set(FlxG.width/300, FlxG.height/300);
		#end

		add(pato);
		
		bozoEspirra = new FlxSprite();
		bozoEspirra.loadGraphic(AssetPaths.bozotile__png, true, 150, 150, true);
		bozoEspirra.animation.add("idle", [12, 13], 4, true);
		bozoEspirra.animation.play("idle");
		bozoEspirra.setPosition(0,150);
		bozoEspirra.x += paddingSide;
		
		#if android
		bozoEspirra.scale.set(FlxG.width/300, FlxG.height/300);
		#end

		add(bozoEspirra);
		
		bozoRun = new FlxSprite();
		bozoRun.loadGraphic(AssetPaths.Jair__png, true, 104, 122, true);
		bozoRun.animation.add("arminha_com_a_mao", [20, 19], 4, true);
		bozoRun.animation.play("arminha_com_a_mao");
		bozoRun.setPosition(180,160);
		bozoRun.x += paddingSide;
		
		#if android
		bozoRun.scale.set(FlxG.width/300, FlxG.height/300);
		#end

		add(bozoRun);
		
		pedestal = new FlxSprite().loadGraphic(AssetPaths.pedestal__png, false, 12, 102);
		pedestal.setPosition(255, 180);
		pedestal.x += paddingSide;
		
		#if android
		pedestal.scale.set(FlxG.width/300, FlxG.height/300);
		#end

		add(pedestal);

		#if android
		stringTitulo = new InaraString("bozorun", 10 + paddingSide, 40, 280 * (FlxG.width/300), 0, 0, FlxG.width/300, FlxG.height/300);
		#else
		stringTitulo = new InaraString("bozorun", 70 + paddingSide, 40, 280, 0, 0);
		#end

		add(stringTitulo);
		stringTitulo._chars.group.forEach(function (letra){ add(letra); });
		
		BtnColetiva = new FlxButton(10, division * 1.5 + 40, "", () -> FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> FlxG.switchState(new ColetivaGameState()) ));
		BtnColetiva.label.size = 20;
		BtnColetiva.loadGraphic(AssetPaths.coletiva__png , true, 60, 36);
		BtnColetiva.scale.set(1.6, .9);
		BtnColetiva.x = 35 + paddingSide;
		BtnColetiva.y += 25;
		
		#if android
		BtnColetiva.scale.set(FlxG.width/300, FlxG.height/300);
		#end

		//add(BtnColetiva);
		
		BtnRun = new FlxButton(0, 0, "", () -> FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> FlxG.switchState(new BozoRunGameState()) ));
		BtnRun.label.size = 20;
		BtnRun.loadGraphic(AssetPaths.fugir__png, true, 60, 36);
		
		//BtnRun.x = 200;
		BtnRun.x = 200 + paddingSide;
		BtnRun.y = 122;
		
		#if android
		BtnRun.scale.set(FlxG.width/300, FlxG.height/300);
		#end

		add(BtnRun);

		// música de fundo
		FlxG.sound.playMusic("assets/music/bozosong.ogg");
	}

	override public function update(elapsed:Float):Void
	{
		aviao.x += 0.8;

		if(aviao.x >= 305 + paddingSide) aviao.x = 0 + paddingSide;

		pato.x += 0.4 * multiplier;

		if(pato.x >= 270 + paddingSide) {
			multiplier = multiplier*-1;
			pato.facing = FlxObject.RIGHT;
		}

		if(pato.x <= 180 + paddingSide) {
			pato.facing = FlxObject.LEFT;
			multiplier = multiplier*-1;
		}

		super.update(FlxG.elapsed);
	}
	
	override public function destroy():Void
	{
		background.destroy();
		BtnRun.destroy();
		
		background = null;
		BtnRun = null;
		
		super.destroy();
	}
}