package;

import flixel.FlxSprite;

class InaraChar extends FlxSprite
{
	private var _char:String;
	private var _width:Int;
	private var _height:Int;
	private var _posX:Float;
	private var _posY:Float;

	public var _changed:Bool = true;

	private function setCharWidthHeightPosition(c:String, w:Int, h:Int, x:Float, y:Float):Void
	{
		this._char = c;
		this._width = w;
		this._height = h;
		this._posX = x;
		this._posY = y;
	}

	public function new(Char:String, posX:Float = 0, posY:Float = 0, scaleX:Float, scaleY:Float)
	{
		super(posX, posY);

		switch (Char)
		{
			case "*":
				setCharWidthHeightPosition(AssetPaths.asterisco__png, Math.ceil(15 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "/":
				setCharWidthHeightPosition(AssetPaths.barra__png, Math.ceil(29 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case ":":
				setCharWidthHeightPosition(AssetPaths.dois_pontos__png, Math.ceil(7 * scaleX), Math.ceil(15 * scaleY), posX, posY);
			case "?":
				setCharWidthHeightPosition(AssetPaths.interrogacao__png, Math.ceil(23 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "%":
				setCharWidthHeightPosition(AssetPaths.porcentagem__png, Math.ceil(26 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "¨":
				setCharWidthHeightPosition(AssetPaths.trema__png, Math.ceil(15 * scaleX), Math.ceil(7 * scaleY), posX, posY);
			case "-":
				setCharWidthHeightPosition(AssetPaths.___png, Math.ceil(18 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "~":
				setCharWidthHeightPosition(AssetPaths.til__png, Math.ceil(15 * scaleX), Math.ceil(6 * scaleY), posX, posY);
			case "´":
				setCharWidthHeightPosition(AssetPaths.agudo__png, Math.ceil(11 * scaleX), Math.ceil(10 * scaleY), posX, posY);
			case ",":
				setCharWidthHeightPosition(AssetPaths.virgula__png, Math.ceil(8 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "!":
				setCharWidthHeightPosition(AssetPaths.exclamacao__png, Math.ceil(11 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "+":
				setCharWidthHeightPosition(AssetPaths.mais__png, Math.ceil(18 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "0":
				setCharWidthHeightPosition(AssetPaths.num_0__png, Math.ceil(22 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "1":
				setCharWidthHeightPosition(AssetPaths.num_1__png, Math.ceil(12 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "2":
				setCharWidthHeightPosition(AssetPaths.num_2__png, Math.ceil(23 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "3":
				setCharWidthHeightPosition(AssetPaths.num_3__png, Math.ceil(24 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "4":
				setCharWidthHeightPosition(AssetPaths.num_4__png, Math.ceil(20 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "5":
				setCharWidthHeightPosition(AssetPaths.num_5__png, Math.ceil(23 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "6":
				setCharWidthHeightPosition(AssetPaths.num_6__png, Math.ceil(23 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "7":
				setCharWidthHeightPosition(AssetPaths.num_7__png, Math.ceil(25 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "8":
				setCharWidthHeightPosition(AssetPaths.num_8__png, Math.ceil(27 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "9":
				setCharWidthHeightPosition(AssetPaths.num_9__png, Math.ceil(25 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "a":
				setCharWidthHeightPosition(AssetPaths.a__png, Math.ceil(25 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "á":
				setCharWidthHeightPosition(AssetPaths.a_agudo__png, Math.ceil(25 * scaleX), Math.ceil(27 * scaleY), posX, posY);
			case "ã":
				setCharWidthHeightPosition(AssetPaths.a_til__png, Math.ceil(25 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "â":
				setCharWidthHeightPosition(AssetPaths.a_circunflexo__png, Math.ceil(25 * scaleX), Math.ceil(30 * scaleY), posX, posY);
			case "ä":
				setCharWidthHeightPosition(AssetPaths.a_trema__png, Math.ceil(25 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "b":
				setCharWidthHeightPosition(AssetPaths.b__png, Math.ceil(20 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "c":
				setCharWidthHeightPosition(AssetPaths.c__png, Math.ceil(22 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "ç":
				setCharWidthHeightPosition(AssetPaths.c_cedilha__png, Math.ceil(22 * scaleX), Math.ceil(26 * scaleY), posX, posY);
			case "d":
				setCharWidthHeightPosition(AssetPaths.d__png, Math.ceil(23 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "e":
				setCharWidthHeightPosition(AssetPaths.e__png, Math.ceil(22 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "é":
				setCharWidthHeightPosition(AssetPaths.e_agudo__png, Math.ceil(22 * scaleX), Math.ceil(27 * scaleY), posX, posY);
			case "ê":
				setCharWidthHeightPosition(AssetPaths.e_circunflexo__png, Math.ceil(22 * scaleX), Math.ceil(27 * scaleY), posX, posY);
			case "ë":
				setCharWidthHeightPosition(AssetPaths.e_trema__png, Math.ceil(22 * scaleX), Math.ceil(27 * scaleY), posX, posY);
			case "f":
				setCharWidthHeightPosition(AssetPaths.f__png, Math.ceil(22 * scaleX), Math.ceil(26 * scaleY), posX, posY);
			case "g":
				setCharWidthHeightPosition(AssetPaths.g__png, Math.ceil(22 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "h":
				setCharWidthHeightPosition(AssetPaths.h__png, Math.ceil(25 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "i":
				setCharWidthHeightPosition(AssetPaths.i__png, Math.ceil(15 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "í":
				setCharWidthHeightPosition(AssetPaths.i_agudo__png, Math.ceil(15 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "ï":
				setCharWidthHeightPosition(AssetPaths.i_trema__png, Math.ceil(15 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "j":
				setCharWidthHeightPosition(AssetPaths.j__png, Math.ceil(18 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "k":
				setCharWidthHeightPosition(AssetPaths.k__png, Math.ceil(20 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "l":
				setCharWidthHeightPosition(AssetPaths.l__png, Math.ceil(22 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "m":
				setCharWidthHeightPosition(AssetPaths.m__png, Math.ceil(37 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "n":
				setCharWidthHeightPosition(AssetPaths.n__png, Math.ceil(32 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "o":
				setCharWidthHeightPosition(AssetPaths.o__png, Math.ceil(22 * scaleX), Math.ceil(28 * scaleY), posX, posY);
			case "õ":
				setCharWidthHeightPosition(AssetPaths.o_til__png, Math.ceil(22 * scaleX), Math.ceil(28 * scaleY), posX, posY);
			case "ö":
				setCharWidthHeightPosition(AssetPaths.o_trema__png, Math.ceil(22 * scaleX), Math.ceil(28 * scaleY), posX, posY);
			case "ô":
				setCharWidthHeightPosition(AssetPaths.o_circunflexo__png, Math.ceil(22 * scaleX), Math.ceil(28 * scaleY), posX, posY);
			case "p":
				setCharWidthHeightPosition(AssetPaths.p__png, Math.ceil(24 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "q":
				setCharWidthHeightPosition(AssetPaths.q__png, Math.ceil(24 * scaleX), Math.ceil(26 * scaleY), posX, posY);
			case "r":
				setCharWidthHeightPosition(AssetPaths.r__png, Math.ceil(24 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "s":
				setCharWidthHeightPosition(AssetPaths.s__png, Math.ceil(22 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "t":
				setCharWidthHeightPosition(AssetPaths.t__png, Math.ceil(24 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "u":
				setCharWidthHeightPosition(AssetPaths.u__png, Math.ceil(22 * scaleX), Math.ceil(27 * scaleY), posX, posY);
			case "ú":
				setCharWidthHeightPosition(AssetPaths.u_agudo__png, Math.ceil(22 * scaleX), Math.ceil(27 * scaleY), posX, posY);
			case "ü":
				setCharWidthHeightPosition(AssetPaths.u_trema__png, Math.ceil(22 * scaleX), Math.ceil(27 * scaleY), posX, posY);
			case "v":
				setCharWidthHeightPosition(AssetPaths.v__png, Math.ceil(27 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "w":
				setCharWidthHeightPosition(AssetPaths.w__png, Math.ceil(41 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "x":
				setCharWidthHeightPosition(AssetPaths.x__png, Math.ceil(26 * scaleX), Math.ceil(26 * scaleY), posX, posY);
			case "y":
				setCharWidthHeightPosition(AssetPaths.y__png, Math.ceil(25 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case "z":
				setCharWidthHeightPosition(AssetPaths.z__png, Math.ceil(27 * scaleX), Math.ceil(25 * scaleY), posX, posY);
			case " ":
				setCharWidthHeightPosition(AssetPaths.i__png, Math.ceil(15 * scaleX), Math.ceil(25 * scaleY), posX, posY);
		}

		loadGraphic(this._char, false, this._width, this._height, true);
		if (scaleX != 1 || scaleY != 1)
			scale.set(scaleX, scaleY);
		Char == " " ? visible = false : null;
	}

	override public function update(elapsed:Float)
	{
		if (_changed)
		{
			setPosition(this._posX, this._posY);
			this._changed = false;
		}
		super.update(elapsed);
	}
}
