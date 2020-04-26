package;

import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup;

class InaraString extends FlxBasic
{
	private var _x:Float;
	private var _y:Float;

	public var _chars:FlxSpriteGroup;

	public function new(str:String, x:Float, y:Float, width:Float, rightPad:Float, bottomPad:Float, scaleX:Float = 1, scaleY:Float = 1)
	{
		var poolSize = str.length;
		var maxHeightOfLine:Float = 0;
		var currentLineWidth:Float = 0;
		var currentLineCount:Float = 0;
		var currentLineY:Float = 0;

		this._chars = new FlxSpriteGroup(x, y, poolSize);

		this._x = x;
		this._y = y;

		for (i in 0...poolSize)
		{
			var _inaraChar = new InaraChar(str.charAt(i), this._x, this._y, scaleX, scaleY);
			maxHeightOfLine = (_inaraChar.height > maxHeightOfLine) ? _inaraChar.height : maxHeightOfLine;
			currentLineWidth += _inaraChar.width * scaleX;
			if ((currentLineWidth + (_inaraChar.width * scaleX)) > width)
			{
				// quebra linha
				this._x = x;
				this._y = y + maxHeightOfLine + bottomPad + currentLineY;

				// reseta variaveis
				currentLineWidth = 0;
				currentLineY += maxHeightOfLine * scaleY;
				maxHeightOfLine = 0;
			}
			else
			{
				this._x += (_inaraChar.width * scaleX) + rightPad;
			}
			this._chars.add(_inaraChar);
		}
		super();
	}
}
