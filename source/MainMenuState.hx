package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxObject;

/**
 * Based on work from
 * william.thompsonj
 */
class MainMenuState extends FlxState
{
	private var background:FlxSprite;
	private var bozo:FlxSprite;
	private var lula:FlxSprite;
	private var vs:FlxSprite;
	private var title:FlxText;
	private var BtnRun:FlxButton;
	
	override public function create():Void
	{
		var division:Int = Std.int(FlxG.height / 3);
		
		background = new FlxSprite();
		background.loadGraphic("assets/images/brasilia.png", false, 300, 300);
		add(background);
		
		bozo = new FlxSprite();
		bozo.loadGraphic("assets/images/Jair.png", true, 104, 122, true);
		bozo.animation.add("idle", [0, 1, 2], 7, true);
		bozo.animation.play("idle");
		bozo.setPosition(90,90);
		add(bozo);

		title = new FlxText(0, division* 1.5 - 100, FlxG.width, "BOZORUN!");
		title.setFormat(null, 34, 0xFFFFFFFF, "center");
		add(title);
		
		BtnRun = new FlxButton(10, division * 1.5 + 40, "Fugir!", startGame);
		BtnRun.label.size = 20;
		BtnRun.loadGraphic("assets/images/buttons.png", false, 20, 15);
		BtnRun.scale.set(.6, .9);
		BtnRun.x = (FlxG.width - BtnRun.width) * .5;
		BtnRun.y += 25;
		add(BtnRun);
	}
	
	private function startGame():Void
	{
		FlxG.switchState(new PlayState());
	}
	
	override public function destroy():Void
	{
		background.destroy();
		title.destroy();
		BtnRun.destroy();
		
		background = null;
		title = null;
		BtnRun = null;
		
		super.destroy();
	}
}