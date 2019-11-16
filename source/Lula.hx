package;

import flixel.FlxSprite;
import flixel.FlxObject;

class Lula extends FlxSprite
{
    public var speed:Float = 200;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);

        loadGraphic(AssetPaths.Lula__png, true, 104, 122);

        drag.x = drag.y = 1600;

        setFacingFlip(FlxObject.RIGHT, false, false);
        setFacingFlip(FlxObject.LEFT, true, false);
        
        animation.add("idle", [0, 1, 2], 6, true);
    }

    override public function update(elapsed:Float):Void
    {
        movement();
        super.update(elapsed);
    }

    function movement():Void
    {
        animation.play("idle");
    }
}