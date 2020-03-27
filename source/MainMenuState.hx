package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxObject;
import flixel.util.FlxColor;

/**
 * Based on work from
 * william.thompsonj
 */
class MainMenuState extends FlxState
{
	private var background:FlxSprite;
	private var mesa:FlxSprite;
	private var bozoEspirra:FlxSprite;
	private var bozoRun:FlxSprite;
	private var vs:FlxSprite;
	private var title:FlxText;
	private var BtnRun:FlxButton;
	private var BtnColetiva:FlxButton;
	private var ceu:FlxSprite;
	private var pato:FlxSprite;
	private var aviao:FlxSprite;
	
	override public function create():Void
	{
		var division:Int = Std.int(FlxG.height / 3);

		#if mobile
		FlxG.mouse.visible = false;
		#else
		FlxG.mouse.visible = true;
		#end

		ceu = new FlxSprite().loadGraphic(AssetPaths.ceu__png, false, 300, 300);
		add(ceu);

		aviao = new FlxSprite().loadGraphic(AssetPaths.aviao__png, true, 86, 17);
		aviao.animation.add("voando", [0,1], 10, true);
		aviao.animation.play("voando");
		aviao.setPosition(-10, 20);
		add(aviao);
		
		background = new FlxSprite();
		background.loadGraphic(AssetPaths.senado_bg__png, true, 300, 300);
		background.animation.add("idle", [0, 1, 2], 3, true);
		background.animation.play("idle");
		add(background);
		
		bozoEspirra = new FlxSprite();
		bozoEspirra.loadGraphic(AssetPaths.bozotile__png, true, 150, 150, true);
		bozoEspirra.animation.add("idle", [12, 13], 4, true);
		bozoEspirra.animation.play("idle");
		bozoEspirra.setPosition(-10,150);
		add(bozoEspirra);

		bozoRun = new FlxSprite();
		bozoRun.loadGraphic(AssetPaths.Jair__png, true, 104, 122, true);
		bozoRun.animation.add("arminha_com_a_mao", [20, 19], 4, true);
		bozoRun.animation.play("arminha_com_a_mao");
		bozoRun.setPosition(180,160);
		add(bozoRun);

		title = new FlxText(0, division* 1.5 - 100, FlxG.width, "BOZORUN!");
		title.setFormat(null, 34, FlxColor.YELLOW, "center");
		title.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.fromRGB(100,0,0), 3);
		add(title);
		
		BtnColetiva = new FlxButton(10, division * 1.5 + 40, "", callBozoColetivaGame);
		BtnColetiva.label.size = 20;
		BtnColetiva.loadGraphic(AssetPaths.coletiva__png , true, 60, 36);
		BtnColetiva.scale.set(1.6, .9);
		BtnColetiva.x = 35;
		BtnColetiva.y += 25;
		//add(BtnColetiva);
		
		BtnRun = new FlxButton(0, 0, "", callBozoRunGame);
		BtnRun.label.size = 20;
		BtnRun.loadGraphic(AssetPaths.fugir__png, true, 60, 36);
		
		//BtnRun.x = 200;
		BtnRun.x = 200;
		BtnRun.y = 122;
		add(BtnRun);
	}
	
	private function callBozoRunGame():Void
	{
		FlxG.switchState(new BozoRunGameState());
	}

	private function callBozoColetivaGame():Void
	{
		FlxG.switchState(new ColetivaGameState());
	}

	override public function update(elapsed:Float):Void
	{
		aviao.x += 0.8;
		aviao.height += 0.08;
		aviao.width += 0.04;

		if(aviao.x >= 350) aviao.x = -40;

		super.update(FlxG.elapsed);
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