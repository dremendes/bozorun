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
	var _bg:Background;
	var _bozo:Bozo;
	var _map:FlxOgmoLoader;
	var _mWalls:FlxTilemap;
	var _lula:Lula;

	override public function create():Void
	{
		_bg = new Background();
		add(_bg);

		_map = new FlxOgmoLoader(AssetPaths.bozorun__oel);
		_mWalls = _map.loadTilemap(AssetPaths.groundtiles__png, 16, 16, "fg");
		_mWalls.follow();
		_mWalls.setTileProperties(10, FlxObject.ANY);
		add(_mWalls);

		_bozo = new Bozo();
		_bozo.scale.set(0.5, 0.5);
		_bozo.updateHitbox();
		_bozo.scale.set(1,1);
 		add(_bozo);

		_lula = new Lula();
		_lula.scale.set(0.5, 0.5);
		_lula.updateHitbox();
		_lula.scale.set(1,1);
 		add(_lula);

		_map.loadEntities(placeEntities, "entities");

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
	}

}
