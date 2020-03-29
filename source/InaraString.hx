package;

import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup;

class InaraString extends FlxBasic
{

    private var _x :Float;
    private var _y :Float;
    public var chars:FlxSpriteGroup;
    
    public function new(str:String, x:Float, y:Float, width:Float, rightPad:Float, bottomPad:Float)
    {
        var poolSize = str.length;
        var maxHeightOfLine:Float=0;
        var currentLineWidth:Float=0;
        var currentLineCount:Float=0;
        var currentLineY:Float=0;
        
        chars = new FlxSpriteGroup(x, y, poolSize);
        
        _x = x;
        _y = y;

        //for (i in 0...poolSize)
        //{
            var _inaraChar = new InaraChar(str.charAt(0), _x, _y);
            //maxHeightOfLine = (_inaraChar.height > maxHeightOfLine) ? _inaraChar.height : maxHeightOfLine;
            //currentLineWidth += _inaraChar.width;
            //if((currentLineWidth + _inaraChar.width) > width) {
                //quebra linha
            //    _x = x;
            //    _y = y + maxHeightOfLine + bottomPad + currentLineY;

                //reseta variaveis
                //currentLineWidth = 0;
                //currentLineY += maxHeightOfLine;
                //maxHeightOfLine = 0;
            //} else {
                //currentLineWidth += _inaraChar.width;
                //_x += _inaraChar.width + rightPad;
            //}
            chars.add(_inaraChar);
        //}
        super();
    }

}
