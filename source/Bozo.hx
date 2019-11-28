package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;

class Bozo extends FlxSprite
{
    public var maxSpeed:Float = 200.0;
    public var _angle:Float = 0.0;
    public var _left:Bool = false;
    public var _right:Bool = false;
    public var _jumpPressed:Bool = false;
    public var mA:Float = 0.0;
    public var _walking:Bool = false;
    public var _idle:Bool = false;
    public var _pointCurrent:FlxPoint;
    public var _showVs:Bool = true;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);

        loadGraphic(AssetPaths.Jair__png, true, 104, 122, true);
        offset.subtract(34,10);

        drag.x = drag.y = 500;

        maxVelocity.set(140, 1000);
		acceleration.y = 900;

        setFacingFlip(FlxObject.RIGHT, false, false);
        setFacingFlip(FlxObject.LEFT, true, false);
        
        animation.add("idle", [0, 1, 2], 7, true);
        animation.add("lr", [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 7, true);
        animation.add("jump", [15, 14, 16, 17], 7, false);
        animation.add("arminha_com_a_mao", [20, 21, 19], 7, false);
        animation.add("hit", [22, 23], 7, false);

        _pointCurrent = new FlxPoint(this.x, this.y);
    }

    override public function update(elapsed:Float):Void
    {    
        movement();
        super.update(elapsed);
    }

    function movement():Void
    {
        _jumpPressed = FlxG.keys.anyJustPressed([SPACE]);

        if (_showVs && FlxG.keys.anyPressed([LEFT,RIGHT,A,X,Z,SPACE,UP,W])) {
            _showVs = false;
        }

        if (FlxG.keys.anyJustPressed([SPACE, UP, W]) && isTouching(FlxObject.DOWN)) {
			velocity.y = -maxVelocity.y / 2;
            animation.play("jump");
		} else if (FlxG.keys.anyPressed([LEFT, A])) {
			acceleration.x = -maxVelocity.x * 4;
            facing = FlxObject.LEFT;
            if (isTouching(FlxObject.DOWN)) animation.play("lr");
		} else if (FlxG.keys.anyPressed([RIGHT, D])) {
			acceleration.x = maxVelocity.x * 4;
            facing = FlxObject.RIGHT;
            if (isTouching(FlxObject.DOWN)) animation.play("lr");
		} else if (FlxG.keys.anyJustPressed([X])) {
            animation.play("arminha_com_a_mao");
            _walking = false;
            _idle = false;
        } else if (FlxG.keys.anyJustPressed([Z])) {
            animation.play("hit");
            _walking = false;
            _idle = false;
        } else if (FlxG.keys.anyJustReleased([LEFT, RIGHT, A, D])) {
            animation.play("idle");
            _walking = false;
            _idle = true;
            acceleration.set(0.0, acceleration.y);
        }

        if (animation.finished && _walking == false && isTouching(FlxObject.DOWN)) animation.play("idle");

        for (touch in FlxG.touches.list)
        {
            if (touch.justPressed || touch.pressed) {
                _showVs = false;
                velocity.set(maxSpeed, velocity.y);
                _pointCurrent.x = this.x;
                _pointCurrent.y = this.y;
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
            if (touch.justPressedTimeInTicks == 2) {
                velocity.y = -maxVelocity.y / 2;
                animation.play("jump");
            }
        }
    }
}