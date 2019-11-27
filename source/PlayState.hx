package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;

class PlayState extends FlxState
{
	var _bg:AssetLoader; 
	var _vs:AssetLoader;
	var _bozo:Bozo;
	var _map:FlxOgmoLoader;
	var _mWalls:FlxTilemap;
	var _lula:Lula;
	var didntOnce:Bool=true;

	override public function create():Void
	{
		_bg = new AssetLoader(AssetPaths.brasilia__png, 300, 300);
		add(_bg);

		_map = new FlxOgmoLoader(AssetPaths.bozorun__oel);
		_mWalls = _map.loadTilemap(AssetPaths.groundtiles__png, 16, 16, "fg");
		_mWalls.follow();
		_mWalls.setTileProperties(10, FlxObject.ANY);
		add(_mWalls);

		_bozo = new Bozo();
		_bozo.width = 80;
		_bozo.height = 122;
 		add(_bozo);

		_lula = new Lula();
 		add(_lula);

		_map.loadEntities(placeEntities, "entities");

		_vs = new AssetLoader(AssetPaths.vs__png, 84, 63);
		_vs.setPosition(95,140);
		add(_vs);

		super.create();
	}
	
	function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "bozo")
		{
			_bozo.x = x;
			_bozo.y = y;
		}

		if (entityName == "lula")
		{
			_lula.x = x;
			_lula.y = y;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(_bozo, _lula);
		FlxG.collide(_bozo, _mWalls);
		FlxG.collide(_lula, _mWalls);

		if(_bozo._showVs == false) {
			remove(_vs);
			didntOnce = false;
		}
	}

}
