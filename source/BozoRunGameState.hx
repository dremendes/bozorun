package;

import flixel.math.FlxRandom;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.addons.display.FlxBackdrop;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import extension.eightsines.EsOrientation;

/**
 * Based on HaxeRunner by william.thompsonj
 */
class BozoRunGameState extends FlxState
{
	private static inline var TILE_WIDTH:Int = 16;
	private static inline var TILE_HEIGHT:Int = 16;
	private static var random = new FlxRandom();
	
	// base speed for player, stands for xVelocity
	private static inline var BASE_SPEED:Int = 200;
	
	// how fast the player speeds up going to the right
	private static inline var xAcceleration:Int = 120;
	
	// force that pulls sprite to the right
	private static inline var xDrag:Int = 100;
	
	// represents how strong gravity pulls up or down
	private static inline var yAcceleration:Int = 1400;
	
	// maximum speed the player can fall
	private static inline var yVelocity:Int = 1400;
	
	// how long holding jump makes player jump in seconds
	private static inline var jumpDuration:Float = .25;
	
	private var _bozo:FlxSprite;
	private var _jump:Float;
	private var _playJump:Bool;
	private var _jumpPressed:Bool;
	private var _sfxDie:Bool;
	private var _tooglePausar:Bool=false;
	private var _auxX:Float = 0.0;
	private var _livesTotal = 3;
	private var _live0:FlxSprite;
	private var _live1:FlxSprite;
	private var _live2:FlxSprite;

	private var _laranja1:FlxSprite;
	private var _laranja2:FlxSprite;
	private var _laranja3:FlxSprite;
	
	// used to help with tracking camera movement
	private var _ghost:FlxSprite;
	
	// where to start generating platforms
	private var _pontaDireitaCenario:Int;
	
	// background image
	private var _bgImgGrp:FlxGroup;
	private var _bgImg0:FlxBackdrop;
	private var _bgImg3:FlxBackdrop;
	private var _floor:FlxBackdrop;

	// collision group for generated platforms
	private var _collisions:FlxGroup;
	private var _books:FlxSpriteGroup;

	private var _amountOranges:Int=0;
	
	private var _oranges:FlxSpriteGroup;

	// indicate whether the collision group has changed
	private var _change:Bool;
	
	// score counter and timer
	private var _score:Int;
	private var _record:Int;
	
	private var _pausarButton:FlxButton;

	private var _voltarButton:FlxButton;
	private var _scoreText:FlxText;
	private var _arrayLivros:Array<String> = [AssetPaths.livros1__png,
											  AssetPaths.livros2__png,
											  AssetPaths.livros3__png,
											  AssetPaths.livros4__png,
											  AssetPaths.livros5__png,
											  AssetPaths.livros6__png];
	private var _piscando:Bool = true;
		
	override public function create():Void
	{
		#if html5
		FlxG.mouse.visible = false;
		#end

		EsOrientation.setScreenOrientation(EsOrientation.ORIENTATION_LANDSCAPE);		

		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		FlxG.camera.antialiasing = true;

		// make sure world is wide enough, 100,000 tiles should be enough...
		FlxG.worldBounds.setSize(TILE_WIDTH * 100000, 300);
		
		configurarFundo();
		
		configurarBozo();
		
		// prepare player related variables
		iniciarBozo();
		
		configurarInterface();
		
		// setup platform logic
		setupPlatforms();
		
		// prepare platform variables
		initPlatforms();
	}
	
	
	private inline function configurarFundo():Void
	{
		_bgImg0 = new FlxBackdrop(AssetPaths.sky__png, 0.1, 0, true, false, 0, 0);
		_bgImg3 = new FlxBackdrop(AssetPaths.bgnovo__png, 0.4, 0, true, false, 0, 0);
		_bgImgGrp = new FlxGroup();

		_bgImgGrp.add(_bgImg0);
		_bgImgGrp.add(_bgImg3);
		
		this.add(_bgImgGrp);
	}
	
	private inline function configurarBozo():Void
	{
		// make a player sprite
		_bozo = new FlxSprite().loadGraphic(AssetPaths.Jair__png, true, 104, 122);
		_bozo.scale.set(0.4, 1);

        _bozo.updateHitbox();
		_bozo.setGraphicSize(104, 122);

		_record = Std.int(_bozo.x);
		_record = Std.int(_bozo.x);
		
		// set animations to use this run
		configuraAnimacoes();
		
		// face player to the right
		_bozo.facing = FlxObject.RIGHT;
		
		// add player to FlxState
		add(_bozo);
		
		// something that follows player's x movement
		_ghost = new FlxSprite(_bozo.x+FlxG.width-TILE_WIDTH, FlxG.height / 2);
		
		// camera can follow player's x movement, not y (jump bobbing)
		FlxG.camera.follow(_ghost);
	}
	
	private inline function configurarInterface():Void
	{
		_pausarButton = new FlxButton(0, 0, "", () -> openSubState(new PausadoSubState(new FlxColor(0x99808080))) );
		_pausarButton.loadGraphic(AssetPaths.pausar__png, true, 60, 36);
		_pausarButton.setPosition(124, 4);
		_pausarButton.scrollFactor.set(0, 0);
		add(_pausarButton);

		_voltarButton = new FlxButton(0, 0, "", () -> FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> FlxG.switchState(new MainMenuState()) ) );
		_voltarButton.loadGraphic(AssetPaths.voltar__png, true, 60, 36);
		_voltarButton.setPosition(189, 4);
		_voltarButton.scrollFactor.set(0, 0);
		add(_voltarButton);
		
		// add score counter 
		_scoreText = new FlxText(78, 8, TILE_WIDTH * 3 - 3, "");
		_scoreText.scrollFactor.set(0, 0);
		_scoreText.borderStyle = OUTLINE;
		_scoreText.color = 0xFF0000; // red color
		add(_scoreText);
		
		// add lives indicator
		_live0 = new FlxSprite(0,0).loadGraphic(AssetPaths.coracao__png , true, 28, 23);
		_live0.scrollFactor.set(0, 0);
		_live0.animation.add('vivo', [0], 1, false);
		_live0.animation.add('morto', [1], 1, false);
		add(_live0);

		_live1 = new FlxSprite(23,0).loadGraphic(AssetPaths.coracao__png , true, 28, 23);
		_live1.scrollFactor.set(0, 0);
		_live1.animation.add('vivo', [0], 1, false);
		_live1.animation.add('morto', [1], 1, false);
		add(_live1);

		_live2 = new FlxSprite(46,0).loadGraphic(AssetPaths.coracao__png , true, 28, 23);
		_live2.scrollFactor.set(0, 0);
		_live2.animation.add('vivo', [0], 1, false);
		_live2.animation.add('morto', [1], 1, false);
		add(_live2);

		_laranja1 = new FlxSprite(0, 24, AssetPaths.laranja__png);
		_laranja1.scrollFactor.set(0, 0);
		_laranja1.visible = false;
		add(_laranja1);

		_laranja2 = new FlxSprite(24, 24, AssetPaths.laranja__png);
		_laranja2.scrollFactor.set(0, 0);
		_laranja2.visible = false;
		add(_laranja2);

		_laranja3 = new FlxSprite(48, 24, AssetPaths.laranja__png);
		_laranja3.scrollFactor.set(0, 0);
		_laranja3.visible = false;
		add(_laranja3);

		_bgImg3.y += 30;
		_bgImg0.y -= 70;
		
		_score = _record;
	}
	
	private inline function setupPlatforms():Void
	{
		// pool to hold platform objects
		_floor = new FlxBackdrop(AssetPaths.groundtiles__png, 1, 0, true, false, 0, 0);
		_floor.y = 280;
		_floor.allowCollisions = FlxObject.ANY;
		_floor.collisonXDrag = false;
		_floor.immovable = true;
		_floor.width = 1000000;
		add(_floor);
		
		// holds all collision objects
		_collisions = new FlxGroup();
		_collisions.add(_floor);
		
		// add the collisions group to the screen so we can see it!
		add(_collisions);
		
		_books = new FlxSpriteGroup();
		add(_books);

		_oranges = new FlxSpriteGroup();
		add(_oranges);
	}
	
	private inline function iniciarBozo():Void
	{
		// setup jump height
		_jump = -1;
		_playJump = true;
		_jumpPressed = false;
		_sfxDie = true;
		
		// setup player position
		_bozo.setPosition(_record*TILE_WIDTH, 0);
		
		// Basic player physics
		_bozo.drag.x = xDrag;
		_bozo.velocity.set(0, 0);
		_bozo.maxVelocity.set(BASE_SPEED, yVelocity);
		_bozo.acceleration.set(xAcceleration, yAcceleration);
		
		configuraAnimacoes();
		
		// move camera to match player
		_ghost.x = _bozo.x - (TILE_WIDTH * .2) + (FlxG.width * .5);

		_piscando = true;
		var _timerPiscando = new haxe.Timer(3000);
		_timerPiscando.run = () -> { _piscando = false; _bozo.visible = true; _timerPiscando.stop(); }
	}
	
	private inline function initPlatforms():Void
	{
		// collision group is up to date
		_change = false;
		
		// reset edge screen where we generate new platforms
		_pontaDireitaCenario = (_record-1)*TILE_WIDTH;
	}
	
	private inline function onReiniciar():Void if (_livesTotal > 0) iniciarBozo();// reseta parametros do Bozo
	
	/*************************
	 * 
	 * Updaters
	 * 
	 * This is where the process spends most of it's time executing. Try to do
	 * as much optimizing on these functions as possible so the game runs fast
	 * and smooth. If possible, design updater functions to be inlined.
	 * 
	 *************************/
	
	override public function update(elapsed:Float):Void
	{		
		// platform garbage handling
		updatePlatforms();
		
		atualizaBozo();
		
		// collision group changed?
		if (_change) {
			// update collision group so it doesn't freak out
			_collisions.update(FlxG.elapsed);
			_oranges.update(FlxG.elapsed);
			_books.update(FlxG.elapsed);
			
			// collision group is up to date
			_change = false;
		}

		if (FlxG.overlap(_bozo, _oranges, (_bozo, _laranja) -> _laranja.destroy() )){
			_playJump = false;
			if(_amountOranges < 3 && ++_amountOranges == _amountOranges)
				switch(_amountOranges){
					case 1:
						_laranja1.visible = true;
					case 2: 
						_laranja2.visible = true;
					case 3:
						_laranja3.visible = true;
				}
		}

		if(FlxG.collide(_bozo, _collisions)){
			_playJump = false;
			// bozo tá no chão?
			if (_bozo.velocity.x > 0 && !_jumpPressed) _jump = 0; // reset jump variable
		}
		
		// colidiu com livro?
		if (!_piscando && FlxG.overlap(_bozo, _books, (_obj1, _obj2) -> if (_amountOranges >= 1) _obj2.destroy() )) {
			if(xAcceleration > 0 && _sfxDie) FlxG.camera.shake(0.01, 0.2);
			
			_playJump = false;
			_jump = 0;

			if(_amountOranges >= 1) _amountOranges--;
			
			switch(_amountOranges){
				case 0:
					_laranja1.visible = false;
				case 1: 
					_laranja2.visible = false;
				case 2:
					_laranja3.visible = false;
			}

			if(_amountOranges == 0 && FlxG.collide(_bozo, _books) && _bozo.velocity.x <= 0 && _amountOranges <= 0){
				// player went splat
				_jump = -1;
				_playJump = false;
				if(_sfxDie){
					_livesTotal -= 1;
					switch (_livesTotal){
						case 2:	_live2.animation.play("morto");
						case 1:	_live1.animation.play("morto");
						case 0:	_live0.animation.play("morto");
					}
				}
				sfxDie();
			}
			
		} else if(_piscando) _bozo.visible = !_bozo.visible;
		
		playerAnimation();
		
		super.update(FlxG.elapsed);
		
		updateUI();
	}
	
	private inline function updateUI():Void
	{
		_score = Std.int(_bozo.x / (TILE_WIDTH));
		
		if (_bozo.x > (_record * TILE_WIDTH)) _record = _score;
		
		_scoreText.text = Std.string("Recorde" + _record + "m");
		
		// camera tracks ghost, not player (prevent tracking jumps)
		_ghost.x = _bozo.x - (TILE_WIDTH * .2) + (FlxG.width * .5);
	}
	
	private inline function atualizaBozo():Void
	{
		// make player go faster as they go farther in j curve
		_bozo.maxVelocity.x = BASE_SPEED + Std.int(_bozo.x*.03);
		#if html5
		_jumpPressed = FlxG.keys.anyPressed(["UP", "W", "SPACE"]);
		#end

		//Se Bozo parou ou mal está andando, ele pode morrer (e tocar o som de machucado)
		if (_bozo.velocity.x > 10) _sfxDie = true;

		#if (FLX_NO_MOUSE || web || mobile)
		for (touch in FlxG.touches.list)
        	(touch.justReleased) ?
				_jumpPressed = false
			: if (touch.justPressed || touch.pressed)
				_jumpPressed = true;
		#end
		
		if (_jump != -1 && _jumpPressed)
		{
			// play jump sound just once
			if (_jump == 0) FlxG.sound.play(AssetPaths.goblin_1__ogg);
			
			// Duration of jump
			_jump += FlxG.elapsed;
			
			if (_bozo.velocity.y >= 0) {
				// play jump animation
				_playJump = true;
				
				// get player off the platform
				_bozo.y -= 1;
				
				// set minimum velocity
				_bozo.velocity.y = -yAcceleration * .5;
				
				//The general acceleration of the jump
				_bozo.acceleration.y = -yAcceleration;
			}
			
			if (_jump > jumpDuration) {
				// set minimum velocity
				_bozo.velocity.y = -yAcceleration * .5;
				
				//You can't jump for more than 0.25 seconds
				_jump = -1;
				
				// make sure fall animation plays
				_playJump = true;
			}
		} else if (!_jumpPressed || _jump == -1) {
			if (_bozo.velocity.y < 0) {
				// set acceleration to pull to ground
				_bozo.acceleration.y = yAcceleration;
				
				// set minimum velocity
				_bozo.velocity.y = yAcceleration * .25;
				
				// stop jumping more than once, allows air jumps
				_jump = -1;
			}
		}
	}
	
	private inline function updatePlatforms():Void
	{		
		// check if we need to make more platforms
		while (( _bozo.x + FlxG.width) * 1.3 > _pontaDireitaCenario )
		{
			makeBozoObjects();
			//deleta livros e laranjas assim que estão fora da tela
			_books.forEach( (book) -> if (book.x < (_bozo.x - 35)) book.destroy() );
			_oranges.forEach( (orange) -> if (orange.x < (_bozo.x - 35)) orange.destroy() );
		}
	}
	
	private inline function setObjAndAdd2Group(Path:FlxGraphicAsset, 
										width:Int, 
										height:Int, 
										group:FlxSpriteGroup, 
										isSolid:Bool=true, 
										isMovable:Bool=true):Void 
	{
		var obj = new AssetLoader(Path, width, height);
			obj.x = (_bozo.x + FlxG.width) + random.int(300, 350);
			obj.y = random.int(140, 250);
			obj.solid = isSolid;
			obj.immovable = isMovable;
			add(obj);
			group.add(obj);
	}
	
	private inline function makeBozoObjects(wide:Int=0, high:Int=0):Void
	{		
		_pontaDireitaCenario += TILE_WIDTH*2;

		if (random.int(0, 20) / 20 == 0) setObjAndAdd2Group(_arrayLivros[random.int(0, 5)] , 45, 55, _books, true, true);
		if (random.int(0, 50) / 50 == 0) setObjAndAdd2Group(AssetPaths.laranja__png, 23, 23, _oranges, true, false);

		_change = true;
	}
	
	private inline function playerAnimation():Void
	{
		if (_bozo.velocity.x == 0)
			_bozo.animation.play("morrendo")
		else if (_playJump)
			_bozo.animation.play("pulando")
		else if (_bozo.velocity.y != 0)
			_bozo.animation.play("caindo")
		else 
			_bozo.animation.play("fugindo");
	}
	
	private inline function configuraAnimacoes():Void
	{	
		_bozo.animation.add("fugindo", [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 30, true);
		_bozo.animation.add("pulando",  [15, 14], 7, false);
		_bozo.animation.add("caindo", [16, 17], 7, false);
		_bozo.animation.add("morrendo", [22, 23], 15, false);
	}
	
	private inline function sfxDie():Void
	{
		if (_sfxDie) {
			FlxG.sound.play(AssetPaths.goblin_9__ogg);
			_sfxDie = false;
			var timerPraReiniciar = new haxe.Timer(500);
			timerPraReiniciar.run = () -> { onReiniciar(); timerPraReiniciar.stop(); }
		}
	}
	
	override public function destroy():Void
	{
		_bozo.destroy();
		_live0.destroy();
		_live1.destroy();
		_live2.destroy();
		_laranja1.destroy();
		_laranja2.destroy();
		_laranja3.destroy();
		_ghost.destroy();
		_bgImg0.destroy();
		_bgImg3.destroy();
		_floor.destroy();
		_bgImgGrp.destroy();
		_collisions.destroy();
		_books.destroy();
		_oranges.destroy();
		_pausarButton.destroy();
		_voltarButton.destroy();
		_scoreText.destroy();
		super.destroy();
	}
}