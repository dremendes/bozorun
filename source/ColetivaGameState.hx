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
	private var mesaColetiva:FlxSprite;
	private var fundoColetiva:FlxSprite;
	private var vs:FlxSprite;
    private var BtnRun:FlxButton;
    private var BtnMascara:FlxButton;
    private var hasMascara:Bool=false;
	
	override public function create():Void
	{
		var division:Int = Std.int(FlxG.height / 3);

		#if mobile
		FlxG.mouse.visible = false;
		#else
		FlxG.mouse.visible = true;
		#end
		
		fundoColetiva = new FlxSprite();
		fundoColetiva.loadGraphic("assets/images/backgroundbozo.png", false, 350, 300);
		add(fundoColetiva);
		
		gueds = new FlxSprite();
        gueds.loadGraphic("assets/images/guedstile.png", true, 118, 117);
        gueds.animation.add("idle", [0,1], 4, true);
        gueds.animation.add("idle_mascara", [6, 7], 4, true);
		add(gueds);
        gueds.animation.play("idle");
		gueds.setPosition(180,90);
		
		moro = new FlxSprite();
		moro.loadGraphic("assets/images/morotile.png", true, 120, 120);
        moro.animation.add("idle", [2,3], 4, true);
        moro.animation.add("idle_mascara", [6, 7], 4, true);
		add(moro);
        moro.animation.play("idle");
		moro.setPosition(-20,90);
		
		bozo = new FlxSprite();
        bozo.loadGraphic("assets/images/bozotile.png", true, 150, 150);
        bozo.animation.add("idle", [0, 1], 4, true);
        bozo.animation.add("idle_mascara", [10, 11], 4, true);
        bozo.animation.add("idle_mascara_centro", [12, 13], 4, true);
        bozo.animation.play("idle");
		add(bozo);
		bozo.setPosition(70,90);
		
		mesaColetiva = new FlxSprite();
		mesaColetiva.loadGraphic("assets/images/foregroundbozo.png", false, 350, 350);
		add(mesaColetiva);
		mesaColetiva.setPosition(-30,-20);
		
		BtnRun = new FlxButton(10, division * 1.5 + 40, "Fugir!", startGame);
		BtnRun.label.size = 20;
		BtnRun.loadGraphic("assets/images/buttons.png", false, 20, 15);
		BtnRun.scale.set(.6, .9);
		BtnRun.x = 140;
		BtnRun.y += 25;
        add(BtnRun);
        
        BtnMascara = new FlxButton(10, division * 1.5 + 40, "Colocar Máscara", toogleMascara);
		BtnMascara.label.size = 15;
		BtnMascara.loadGraphic("assets/images/buttons.png", false, 20, 15);
		BtnMascara.scale.set(1.1, .7);
		BtnMascara.x = -10;
		BtnMascara.y += 25;
        add(BtnMascara);
    }
    
    private function toogleMascara(){
        hasMascara = !hasMascara;
        if(hasMascara) {
            bozo.animation.play("idle_mascara");
            moro.animation.play("idle_mascara");
            gueds.animation.play("idle_mascara");
        } else {
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