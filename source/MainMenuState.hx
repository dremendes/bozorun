package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

/**
 * Based on work from
 * william.thompsonj
 */
class MainMenuState extends FlxState
{
	private var background:FlxSprite;
	private var title:FlxText;
	private var BtnRun:FlxButton;
	
	override public function create():Void
	{
		var division:Int = Std.int(FlxG.height / 3);
		
		background = new FlxSprite();
		background.loadGraphic("assets/images/screen.png", false, 300, 300);
		add(background);
		
		title = new FlxText(0, division*.5 + 20, FlxG.width, "BOZORUN!");
		title.setFormat(null, 34, 0xFFFFFFFF, "center");
		add(title);
		
		BtnRun = new FlxButton(10, division * 1.5, "Fugir!", startGame);
		BtnRun.label.size = 20;
		BtnRun.loadGraphic("assets/images/buttons.png", false, 20, 15);
		BtnRun.scale.set(.6, .9);
		BtnRun.x = (FlxG.width - BtnRun.width) * .5;
		BtnRun.y += 60;
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