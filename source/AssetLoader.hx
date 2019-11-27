package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class AssetLoader extends FlxSprite
{

    public function new(?X:Float=0, ?Y:Float=0, asset:String=AssetPaths.brasilia__png, width:Int, height:Int)
    {
        super(X, Y);
        loadGraphic(asset, true, width, height);
    }

}