package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxPoint;
import flixel.util.FlxCollision;
import flixel.util.FlxGradient;
import flixel.addons.display.FlxBackdrop;

/**
 * This code is based on the excelent HaxeRunner
 * which is authored by william.thompsonj
 * 
 * I've made few modifications from the original source
 * Thank you very much, William Thompson J.
 */
class PlayState extends FlxState
{
	private static inline var TILE_WIDTH:Int = 16;
	private static inline var TILE_HEIGHT:Int = 16;
	
	// base speed for player, stands for xVelocity
	private static inline var BASE_SPEED:Int = 150;
	
	// how fast the player speeds up going to the right
	private static inline var xAcceleration:Int = 150;
	
	// force that pulls sprite to the right
	private static inline var xDrag:Int = 100;
	
	// represents how strong gravity pulls up or down
	private static inline var yAcceleration:Int = 1400;
	
	// maximum speed the player can fall
	private static inline var yVelocity:Int = 1400;
	
	// how long holding jump makes player jump in seconds
	private static inline var jumpDuration:Float = .25;
	
	// player object and related jump variable
	private var _player:FlxSprite;
	private var _jump:Float;
	private var _playJump:Bool;
	private var _jumpPressed:Bool;
	private var _sfxDie:Bool;
	private var _auxX:Float = 0.0;
	
	// used to help with tracking camera movement
	private var _ghost:FlxSprite;
	
	// where to start generating platforms
	private var _edge:Int;
	
	// background image
	private var _bgImgGrp:FlxGroup;
	private var _bgImg1:FlxSprite;
	private var _bgImg2:FlxSprite;
	private var _bgImg3:FlxSprite;
	private var _bgImages:Array<String>;
	
	// collision group for generated platforms
	private var _collisions:FlxGroup;
	
	// track all platform objects on screen
	private var _tiles:Array<FlxSprite>;
	
	// sprite pool
	private var _pool:ObjectPool;
	
	// indicate whether the collision group has changed
	private var _change:Bool;
	
	// score counter and timer
	private var _score:Int;
	private var _startDistance:Int;
	
	// button to reset and some text
	private var _resetButton:FlxButton;
	private var _scoreText:FlxText;
	private var _helperText:FlxText;
	
	// used when resetting
	private var _resetPlatforms:Bool;
	
	override public function create():Void
	{
		// make sure world is wide enough, 100,000 tiles should be enough...
		FlxG.worldBounds.setSize(TILE_WIDTH * 100000, 300);
		
		// background music
		FlxG.sound.playMusic("assets/music/We're the Resistors.mp3");
		
		// setup background image
		setupBg();
		
		// prepare the player
		setupPlayer();
		
		// prepare player related variables
		initPlayer();
		
		// setup UI
		setupUI();
		
		// prepare UI variables
		initUI();
		
		// setup platform logic
		setupPlatforms();
		
		// prepare platform variables
		initPlatforms();
		
		// initialize scrolling background image
		initBg();
	}
	
	
	private function setupBg():Void
	{
		var sky:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [0xff6dcff6, 0xff333333], 16);
		sky.scrollFactor.set();
		add(sky);
		_bgImg1 = new FlxBackdrop("assets/images/far-buildings.png", 0.001, 0, true, false, 256, 192);
		_bgImg2 = new FlxBackdrop("assets/images/back-buildings.png", 0.2, 0, true, false, 256, 102);
		_bgImg3 = new FlxBackdrop("assets/images/foreground.png", 0.4, 0, true, false, 256, 102);
		_bgImgGrp = new FlxGroup();

		_bgImgGrp.add(_bgImg1);
		_bgImgGrp.add(_bgImg2);
		_bgImgGrp.add(_bgImg3);
		
		this.add(_bgImgGrp);
	}
	
	private function setupPlayer():Void
	{
		// make a player sprite
		_player = new FlxSprite();
		_player.loadGraphic("assets/images/Jair.png", true, 104, 122);
		_player.scale.set(0.4, 1);
        _player.updateHitbox();
		_player.setGraphicSize(104, 122);
		
		_startDistance = Std.int(_player.x);
		
		// set animations to use this run
		setAnimations();
		
		// face player to the right
		_player.facing = FlxObject.RIGHT;
		
		// add player to FlxState
		add(_player);
		
		// something that follows player's x movement
		_ghost = new FlxSprite(_player.x+FlxG.width-TILE_WIDTH, FlxG.height / 2);
		
		// camera can follow player's x movement, not y (jump bobbing)
		FlxG.camera.follow(_ghost);
	}
	
	private function setupUI():Void
	{
		_resetButton = new FlxButton(0, 0, "Reiniciar", onReset);
		add(_resetButton);
		
		// add score counter 
		_scoreText = new FlxText(0, 0, TILE_WIDTH * 3, Std.string("0 metros\nInício: "+_startDistance));
		_scoreText.alignment = "right";
		add(_scoreText);
		
		// helper text. Tells player what controls are
		_helperText = new FlxText(0, 0, TILE_WIDTH*5, "⬆ / touch p/ pular");
		add(_helperText);
	}
	
	private function setupPlatforms():Void
	{
		// pool to hold platform objects
		_pool = new ObjectPool(TILE_WIDTH, TILE_HEIGHT, "assets/images/groundtiles.png");
		
		// keep track of objects currently in use
		_tiles = new Array<FlxSprite>();
		
		// holds all collision objects
		_collisions = new FlxGroup();
		
		// add the collisions group to the screen so we can see it!
		add(_collisions);
		
		// reset indicator
		_resetPlatforms = false;
	}
	
	private inline function initBg():Void
	{

		_bgImg1.scale.set(2, 2);
		_bgImg2.scale.set(2, 2);
		_bgImg3.scale.set(2, 2);

		_bgImgGrp.update(FlxG.elapsed);
		
		_helperText.color = 0xFFFFFF;
		_scoreText.color = 0xFFFFFF;
	}
	
	private inline function initPlayer():Void
	{
		// setup jump height
		_jump = -1;
		_playJump = true;
		_jumpPressed = false;
		_sfxDie = true;
		
		// setup player position
		_player.setPosition(_startDistance*TILE_WIDTH, 0);
		
		// Basic player physics
		_player.drag.x = xDrag;
		_player.velocity.set(0, 0);
		_player.maxVelocity.set(BASE_SPEED, yVelocity);
		_player.acceleration.set(xAcceleration, yAcceleration);
		
		// setup player animations
		setAnimations();
		
		// move camera to match player
		_ghost.x = _player.x - (TILE_WIDTH * .2) + (FlxG.width * .5);
	}
	
	private inline function initUI():Void
	{
		_resetButton.setPosition(20, 20);
		_scoreText.y = 20;
		_helperText.y = 50;
		_score = _startDistance;
		positionText();
	}
	
	private inline function initPlatforms():Void
	{
		// collision group is up to date
		_change = false;
		
		// reset edge screen where we generate new platforms
		_edge = (_startDistance-1)*TILE_WIDTH;
		
		// make initial platforms for starting place
		makePlatform(15, 1);
		makePlatform();
	}
	
	private function onReset():Void
	{
		// move the edge we're watching, then remove blocks
		_resetPlatforms = true;
		removeBlocks();
		_resetPlatforms = false;
		
		// re-initialize player physics and position
		initPlayer();
		
		// re-initialize UI
		initUI();
		
		// reset platforms and draw starting area
		initPlatforms();
		
		// setup background
		initBg();
	}
	
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
		#if !(android || blackberry || iphone || ios || mobile)
		// player hit keyboard reset key?
		if (FlxG.keys.anyJustReleased(["R"]))
		{
			onReset();
			return;
		}
		#end
		
		// player fell off the screen?
		if(_player.y > FlxG.height)
		{
			// call super.update so reset button works
			super.update(FlxG.elapsed);
			
			// stop updating
			return;
		}
		
		// platform garbage handling
		updatePlatforms();
		
		updatePlayer();
		
		updateBg();
		
		// collision group changed?
		if (_change)
		{
			// update collision group so it doesn't freak out
			_collisions.update(FlxG.elapsed);
			
			// collision group is up to date
			_change = false;
		}
		
		// collision with platform?
		if (FlxG.collide(_player, _collisions))
		{
			_playJump = false;
			
			// player hit the wall?
			if (_player.velocity.x == 0)
			{
				// player went splat
				_jump = -1;
				_playJump = false;
				sfxDie();
			}
			else if(!_jumpPressed)
			{
				// reset jump variable
				_jump = 0;
				_sfxDie = true;
			}

		}
		
		playerAnimation();
		super.update(FlxG.elapsed);
		
		// update ui stuff
		updateUI();
	}
	
	private inline function updateUI():Void
	{
		// update score
		_score = Std.int(_player.x / (TILE_WIDTH));
		if (_score*.3 > _startDistance)
		{
			_startDistance = Std.int(_score * .3);
		}
		_scoreText.text = Std.string(_score + " metros\nInício: " + _startDistance);
		
		positionText();
		
		// camera tracks ghost, not player (prevent tracking jumps)
		_ghost.x = _player.x - (TILE_WIDTH * .2) + (FlxG.width * .5);
	}
	
	private inline function updatePlayer():Void
	{
		// make player go faster as they go farther in j curve
		_player.maxVelocity.x = BASE_SPEED + Std.int(_player.x*.05);
		
		_jumpPressed = FlxG.keys.anyPressed(["UP", "W"]);

		for (touch in FlxG.touches.list) {
        	if(touch.justReleased) {
				_jumpPressed = false;
			} else if (touch.justPressed || touch.pressed) {
				_jumpPressed = true;
            }
        }
		
		if (_jump != -1 && _jumpPressed)
		{
			// play jump sound just once
			if (_jump == 0)
			{
				sfxJump();
			}
			
			// Duration of jump
			_jump += FlxG.elapsed;
			
			if (_player.velocity.y >= 0)
			{
				// play jump animation
				_playJump = true;
				
				// get player off the platform
				_player.y -= 1;
				
				// set minimum velocity
				_player.velocity.y = -yAcceleration * .5;
				
				//The general acceleration of the jump
				_player.acceleration.y = -yAcceleration;
			}
			
			if (_jump > jumpDuration)
			{
				// set minimum velocity
				_player.velocity.y = -yAcceleration * .5;
				
				//You can't jump for more than 0.25 seconds
				_jump = -1;
				
				// make sure fall animation plays
				_playJump = true;
			}
		}
		else if (!_jumpPressed || _jump == -1)
		{
			if (_player.velocity.y < 0)
			{
				// set acceleration to pull to ground
				_player.acceleration.y = yAcceleration;
				
				// set minimum velocity
				_player.velocity.y = yAcceleration * .25;
				
				// stop jumping more than once, allows air jumps
				_jump = -1;
			}
		}
	}
	
	private inline function updateBg():Void
	{
	}
	
	private inline function updatePlatforms():Void
	{
		// remove garbage before making new platforms
		removeBlocks();
		
		// check if we need to make more platforms
		while (_player.x + FlxG.width > _edge)
		{
			makePlatform();
		}
	}
	
	/*************************
	 * 
	 * GC Handling
	 * 
	 * If possible, design garbage collector functions to be inlined. Since
	 * these usually run every frame, try to make them escape as soon as they
	 * detect they don't need to go further, that way they take no more power
	 * than absolutely necessary. Also if possible, try to modify as little as
	 * possible since it does involve running between frames.
	 * 
	 *************************/
	
	private function removeBlocks():Void
	{
		// distance from player to inspect
		var distance:Float = _player.x - (TILE_WIDTH * 2);
		
		// reset the level
		if (_resetPlatforms)
		{
			distance += _edge;
		}
		
		// try to run at least once
		var ticker:Bool = true;
		
		// check for old tiles that need to be removed
		while (ticker && _tiles.length != 0)
		{
			// tile is past player, remove it
			if (_tiles[0].x + 30 < distance)
			{
				// temp holder for block
				_block = _tiles.shift();
				
				// remove from collision group
				_collisions.remove(_block);
				
				// put tile back in the pool
				_pool.returnObj(_block);
				
				// check the next block to see if it needs to be removed
				ticker = true;
				
				// contents of collision group have changed
				_change = true;
			}
			else
			{
				ticker = false;
			}
		}
	}
	
	private var _block:FlxSprite; 
	
	private function makePlatform(wide:Int=0, high:Int=0):Void
	{
		// which set of tiles to use for this platform
		var line:Int = 0;
		
		var top:Int = FlxG.height - TILE_HEIGHT;
		
		// grass tuft on left edge
		makeBlock(_edge, top, line);

		
		// update screen edge and width of platform lower part
		_edge += TILE_WIDTH*2;


		for (i in 0...Std.random(2))
		{
			_auxX = _player.x + _edge + (Std.random(350) * 20);

			var obj = new AssetLoader(AssetPaths.mamadeira__png, 65, 145);
			obj.x = _auxX;
			obj.y = (Std.random(21) * -4) + 220;
			obj.allowCollisions = FlxObject.ANY;
			obj.solid = true;
			obj.immovable = true;
			add(obj);
			_collisions.add(obj);
		}
		

		_change = true;
	}

	
	private inline function makeBlock(x:Float, y:Float, tile:Int):Void
	{
		_block = _pool.getObj();
		_block.setPosition(x, y);
		_block.frame = _block.frames.frames[tile];

		// add platform block to tile array
		_tiles.push(_block);
		
		// add block to collisions group
		_collisions.add(_block);
	}
	
	private inline function playerAnimation():Void
	{
		// ANIMATION
		if (_player.velocity.x == 0)
		{
			_player.animation.play("die");
		}
		else if (_playJump)
		{
			_player.animation.play("jump");
		}
		else if (_player.velocity.y != 0)
		{
			_player.animation.play("fall");
		}
		else
		{
			_player.animation.play("run");
		}
	}
	
	private inline function setAnimations():Void
	{	
		_player.animation.add("run", [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 7, true);
		_player.animation.add("jump",  [15, 14], 7, false);
		_player.animation.add("fall", [16, 17], 7, false);
		_player.animation.add("die", [22, 23], 7, false);
	}
	
	private inline function positionText():Void
	{
		// position helper text
		_helperText.x = _player.x + TILE_WIDTH * 2;
		
		// position score text
		_scoreText.x = _player.x + FlxG.width - (4 * TILE_WIDTH);
	}
	
	private inline function sfxDie():Void
	{
		if (_sfxDie)
		{
			FlxG.sound.play("assets/sounds/goblin-9.ogg");
			_sfxDie = false;
		}
	}
	
	private inline function sfxJump():Void
	{
		FlxG.sound.play("assets/sounds/goblin-1.ogg");
	}
}