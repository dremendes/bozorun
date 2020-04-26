package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxObject;

class ColetivaGameState extends FlxState
{
	private var moro:FlxSprite;
	private var bozo:FlxSprite;
	private var gueds:FlxSprite;
	private var mic1:FlxSprite;
	private var mic2:FlxSprite;
	private var mic3:FlxSprite;
	private var copo1:FlxSprite;
	private var copo2:FlxSprite;
	private var mesaColetiva:FlxSprite;
	private var fundoColetiva:FlxSprite;
	private var vs:FlxSprite;
	private var BtnRun:FlxButton;
	private var BtnMascara:FlxButton;
	private var hasMascara:Bool = false;
	private var paddingSide:Float = (FlxG.width - 300) / 2;
	private var paddingTop:Float = (FlxG.height - 300) / 2;

	override public function create():Void
	{
		var division:Int = Std.int(FlxG.height / 3);

		#if html5
		FlxG.mouse.visible = false;
		#end

		fundoColetiva = new FlxSprite();
		fundoColetiva.loadGraphic(AssetPaths.backgroundbozo__png, false, 350, 300);
		fundoColetiva.x += paddingSide;
		fundoColetiva.y += paddingTop;
		fundoColetiva.scale.set(FlxG.width / 300, FlxG.height / 300);
		add(fundoColetiva);

		gueds = new FlxSprite();
		gueds.loadGraphic(AssetPaths.guedstile__png, true, 118, 117);
		gueds.animation.add("idle", [0, 1], 4, true);
		gueds.animation.add("idle_mascara", [6, 7], 4, true);
		add(gueds);
		gueds.animation.play("idle");
		gueds.setPosition(180, 90);

		moro = new FlxSprite();
		moro.loadGraphic(AssetPaths.morotile__png, true, 120, 120);
		moro.animation.add("idle", [2, 3], 4, true);
		moro.animation.add("idle_mascara", [6, 7], 4, true);
		add(moro);
		moro.animation.play("idle");
		moro.setPosition(-20, 90);

		mesaColetiva = new FlxSprite();
		mesaColetiva.loadGraphic(AssetPaths.foregroundbozo__png, false, 350, 350);
		add(mesaColetiva);
		mesaColetiva.setPosition(30, -20);

		bozo = new FlxSprite();
		bozo.loadGraphic(AssetPaths.bozotile__png, true, 69, 80);
		bozo.scale.set(1.8, 1.8);
		bozo.animation.add("idle", [0, 1], 4, true);
		bozo.animation.add("idle_mascara", [10, 11], 4, true);
		bozo.animation.add("idle_mascara_centro", [12, 13], 4, true);
		bozo.animation.play("idle");
		add(bozo);
		bozo.setPosition(105, 120);

		mic1 = new FlxSprite();
		mic1.loadGraphic(AssetPaths.microfone__png, false, 23, 58);
		add(mic1);
		mic1.setPosition(-30, 170);

		mic2 = new FlxSprite();
		mic2.loadGraphic(AssetPaths.microfone__png, false, 23, 58);
		add(mic2);
		mic2.setPosition(30, 170);

		mic3 = new FlxSprite();
		mic3.loadGraphic(AssetPaths.microfone__png, false, 23, 58);
		add(mic3);
		mic3.setPosition(130, 170);

		BtnRun = new FlxButton(10, division * 1.5 + 40, "", startGame);
		BtnRun.label.size = 20;
		BtnRun.loadGraphic(AssetPaths.fugir__png, true, 60, 36);
		BtnRun.scale.set(1.6, 1.1);
		BtnRun.x = 200;
		BtnRun.y += 25;
		add(BtnRun);

		BtnMascara = new FlxButton(10, division * 1.5 + 40, "", toogleMascara);
		BtnMascara.label.size = 15;
		BtnMascara.loadGraphic(AssetPaths.mascaraBotao__png, true, 60, 36);
		BtnMascara.scale.set(1.9, 1.1);
		BtnMascara.x = 35;
		BtnMascara.y += 25;
		add(BtnMascara);
	}

	private function toogleMascara()
	{
		hasMascara = !hasMascara;
		if (hasMascara)
		{
			bozo.animation.play("idle_mascara");
			moro.animation.play("idle_mascara");
			gueds.animation.play("idle_mascara");
		}
		else
		{
			bozo.animation.play("idle");
			moro.animation.play("idle");
			gueds.animation.play("idle");
		}
	}

	private function startGame():Void
	{
		FlxG.switchState(new MainMenuState());
	}

	override public function destroy():Void
	{
		fundoColetiva.destroy();
		BtnRun.destroy();

		fundoColetiva = null;
		BtnRun = null;

		super.destroy();
	}
}
