package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;

class Bozo extends FlxSprite
{
    public var speed:Float = 100.0;
    public var _angle:Float = 0.0;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);

        loadGraphic(AssetPaths.Jair__png, true, 104, 122, true);
        offset.subtract(34,10);

        drag.x = drag.y = 1600;

        setFacingFlip(FlxObject.RIGHT, false, false);
        setFacingFlip(FlxObject.LEFT, true, false);
        
        animation.add("idle", [0, 1, 2], 7, true);
        animation.add("lr", [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 7, true);
        animation.add("jump", [14, 15, 16, 17], 7, true);
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
        var _jumpPressed:Bool = false;
        var _pointCurrent:FlxPoint = new FlxPoint(this.x, this.y);
        var mA:Float = 0.0;
        var jumped:Bool = false;
        var jump:Float = 0.0;
        var _walking:Bool = false;

        _left = FlxG.keys.anyPressed([LEFT, A]);
        _right = FlxG.keys.anyPressed([RIGHT, D]);
        _jumpPressed = FlxG.keys.anyPressed([SPACE]);

        if (_left && _right)
            _left = _right = false;

        if ( _left || _right) {
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
                        _walking = true;
                }
            }
        } else if (FlxG.keys.anyJustReleased([LEFT, RIGHT, A, D])) {
            animation.play("idle");
            _walking = false;
        }

        if (jumped && !_jumpPressed)
        jumped = false;

        if (isTouching(FlxObject.DOWN) && !jumped && !_walking) {
            jump = 0;
            animation.play("idle");
        }

        if (jump >= 0 && _jumpPressed)
        {
            jumped = true;
            jump += FlxG.elapsed;
            if (jump > 0.33)
                jump = -1;
            animation.play("jump");
        } else
            jump = -1;

        if (jump > 0) {
            if (jump < 0.065)
                velocity.y = -360;
            else
                acceleration.y = 10;
        }  else {
            velocity.y = 600;
        }

        for (touch in FlxG.touches.list)
        {
            if (touch.justPressed || touch.pressed) {
                velocity.set(speed, 0);
                _angle = _pointCurrent.angleBetween(touch.getPosition());
                
                if (_angle >= 0 && _angle < 180) {
                    facing = FlxObject.RIGHT;
                     mA = 0;
                } else if (_angle >= -180 && _angle < 0) {
                    facing = FlxObject.LEFT;
                    mA = -180;
                }
                animation.play("lr");
                velocity.rotate(FlxPoint.weak(0, 0), mA);              
            }
            if (touch.justReleased) {
                animation.play("idle");
                velocity.set(0, 0);
            }
        }
    }
}