package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.math.FlxPoint;

class Bozo extends FlxSprite
{
    public var speed:Float = 100;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);

        loadGraphic(AssetPaths.Jair__png, true, 104, 122);

        drag.x = drag.y = 1600;

        setFacingFlip(FlxObject.RIGHT, false, false);
        setFacingFlip(FlxObject.LEFT, true, false);

        facing = FlxObject.LEFT;
        
        animation.add("idle", [0, 1, 2], 6, true);
        animation.add("lr", [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 12, true);
    }

    override public function update(elapsed:Float):Void
    {
        movement();
        super.update(elapsed);
    }

    function movement():Void
    {
        var _left:Bool = false;
        var _right:Bool = false;

        _left = FlxG.keys.anyPressed([LEFT, A]);
        _right = FlxG.keys.anyPressed([RIGHT, D]);

        if (_left && _right)
            _left = _right = false;

        if ( _left || _right) {
            var mA:Float = 0;
            velocity.set(speed, 0);
            if (_left) { facing = FlxObject.LEFT; mA = -180; }
            if (_right) { facing = FlxObject.RIGHT; mA = 0; }
            velocity.rotate(FlxPoint.weak(0, 0), mA);
            if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE) // if the player is moving (velocity is not 0 for either axis), we need to change the animation to match their facing
            {
                switch (facing)
                {
                    case FlxObject.LEFT, FlxObject.RIGHT:
                        animation.play("lr");
                }
            }
        } else {
            animation.play("idle");
            velocity.set(0, 0);
        }
    }
}