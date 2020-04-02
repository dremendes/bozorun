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
	private var title:FlxText;
	private var BtnRun:FlxButton;
	private var BtnColetiva:FlxButton;
	private var ceu:FlxSprite;
	private var pato:FlxSprite;
	private var aviao:FlxSprite;
	private var pedestal:FlxSprite;
	private var multiplier:Float=1.0;
	private var string:InaraString;
	
	override public function create():Void
	{
		//FlxG.debugger.visible = true;
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		
		var division:Int = Std.int(FlxG.height / 3);

		#if mobile
		FlxG.mouse.visible = false;
		#else
		FlxG.mouse.visible = true;
		#end

		ceu = new FlxSprite().loadGraphic(AssetPaths.sky__png, false, 310, 300);
		ceu.y -= 70;
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
		
		pato = new FlxSprite().loadGraphic(AssetPaths.patin__png, false, 30, 29);
		pato.setPosition(180,160);
		pato.setFacingFlip(FlxObject.RIGHT, false, false);
		pato.setFacingFlip(FlxObject.LEFT, true, false);
		pato.facing = FlxObject.LEFT;
		add(pato);
		
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
		
		pedestal = new FlxSprite().loadGraphic(AssetPaths.pedestal__png, false, 12, 102);
		pedestal.setPosition(255, 180);
		add(pedestal);

		string = new InaraString("bozorun 2020", 10, 40, 280, 0, 0);
		add(string);
		string._chars.group.forEach(function (sprite){ add(sprite); });
		
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
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
			FlxG.switchState(new BozoRunGameState());
		});
	}

	private function callBozoColetivaGame():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
			FlxG.switchState(new ColetivaGameState());
		});
	}

	override public function update(elapsed:Float):Void
	{
		aviao.x += 0.8;
		aviao.height += 0.08;
		aviao.width += 0.04;

		if(aviao.x >= 350) aviao.x = -40;

		pato.x += 0.4 * multiplier;

		if(pato.x >= 270) {
			multiplier = multiplier*-1;
			pato.facing = FlxObject.RIGHT;
		}

		if(pato.x <= 180) {
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
		title = null;
		BtnRun = null;
		
		super.destroy();
	}
}