package;

import flixel.FlxSprite;

class InaraChar extends FlxSprite
{
    private var _char:String;
    private var _width:Int;
    private var _height:Int;
    private var _posX:Float;
    private var _posY:Float;
    public var _changed:Bool=true;

    private function setCharWidthHeightPosition(c: String, w:Int, h:Int, x:Float, y:Float):Void
    {
        this._char = c;
        this._width = w;
        this._height = h;
        this._posX = x;
        this._posY = y;
    }
    public function new(Char:String, posX:Float=0, posY:Float=0)
    {
        super(posX, posY);

        switch(Char){
            case "*" : setCharWidthHeightPosition(AssetPaths.asterisco__png, 15, 25, posX, posY);
            case "/" : setCharWidthHeightPosition(AssetPaths.barra__png, 29, 25, posX, posY);
            case ":" : setCharWidthHeightPosition(AssetPaths.dois_pontos__png, 7, 15, posX, posY);
            case "?" : setCharWidthHeightPosition(AssetPaths.interrogacao__png, 23, 25, posX, posY);
            case "%" : setCharWidthHeightPosition(AssetPaths.porcentagem__png, 26, 25, posX, posY);
            case "¨" : setCharWidthHeightPosition(AssetPaths.trema__png, 15, 7, posX, posY);
            case "-" : setCharWidthHeightPosition(AssetPaths.___png, 18, 25, posX, posY);
            case "~" : setCharWidthHeightPosition(AssetPaths.til__png, 15, 6, posX, posY);
            case "´" : setCharWidthHeightPosition(AssetPaths.agudo__png, 11, 10, posX, posY);
            case "," : setCharWidthHeightPosition(AssetPaths.virgula__png, 8, 25, posX, posY);
            case "!" : setCharWidthHeightPosition(AssetPaths.exclamacao__png, 11, 25, posX, posY);
            case "+" : setCharWidthHeightPosition(AssetPaths.mais__png, 18, 25, posX, posY);
            case "0" : setCharWidthHeightPosition(AssetPaths.num_0__png, 22, 25, posX, posY);
            case "1" : setCharWidthHeightPosition(AssetPaths.num_1__png, 12, 25, posX, posY);
            case "2" : setCharWidthHeightPosition(AssetPaths.num_2__png, 23, 25, posX, posY);
            case "3" : setCharWidthHeightPosition(AssetPaths.num_3__png, 24, 25, posX, posY);
            case "4" : setCharWidthHeightPosition(AssetPaths.num_4__png, 20, 25, posX, posY);
            case "5" : setCharWidthHeightPosition(AssetPaths.num_5__png, 23, 25, posX, posY);
            case "6" : setCharWidthHeightPosition(AssetPaths.num_6__png, 23, 25, posX, posY);
            case "7" : setCharWidthHeightPosition(AssetPaths.num_7__png, 25, 25, posX, posY);
            case "8" : setCharWidthHeightPosition(AssetPaths.num_8__png, 27, 25, posX, posY);
            case "9" : setCharWidthHeightPosition(AssetPaths.num_9__png, 25, 25, posX, posY);
            case "a" : setCharWidthHeightPosition(AssetPaths.a__png, 25, 25, posX, posY);
            case "á" : setCharWidthHeightPosition(AssetPaths.a_agudo__png, 25, 27, posX, posY);
            case "ã" : setCharWidthHeightPosition(AssetPaths.a_til__png, 25, 25, posX, posY);
            case "â" : setCharWidthHeightPosition(AssetPaths.a_circunflexo__png, 25, 30, posX, posY);
            case "ä" : setCharWidthHeightPosition(AssetPaths.a_trema__png, 25, 25, posX, posY);
            case "b" : setCharWidthHeightPosition(AssetPaths.b__png, 20, 25, posX, posY);
            case "c" : setCharWidthHeightPosition(AssetPaths.c__png, 22, 25, posX, posY);
            case "ç" : setCharWidthHeightPosition(AssetPaths.c_cedilha__png, 22, 26, posX, posY);
            case "d" : setCharWidthHeightPosition(AssetPaths.d__png, 23, 25, posX, posY);
            case "e" : setCharWidthHeightPosition(AssetPaths.e__png, 22, 25, posX, posY);
            case "é" : setCharWidthHeightPosition(AssetPaths.e_agudo__png, 22, 27, posX, posY);
            case "ê" : setCharWidthHeightPosition(AssetPaths.e_circunflexo__png, 22, 27, posX, posY);
            case "ë" : setCharWidthHeightPosition(AssetPaths.e_trema__png, 22, 27, posX, posY);
            case "f" : setCharWidthHeightPosition(AssetPaths.f__png, 22, 26, posX, posY);
            case "g" : setCharWidthHeightPosition(AssetPaths.g__png, 22, 25, posX, posY);
            case "h" : setCharWidthHeightPosition(AssetPaths.h__png, 25, 25, posX, posY);
            case "i" : setCharWidthHeightPosition(AssetPaths.i__png, 15, 25, posX, posY);
            case "í" : setCharWidthHeightPosition(AssetPaths.i_agudo__png, 15, 25, posX, posY);
            case "ï" : setCharWidthHeightPosition(AssetPaths.i_trema__png, 15, 25, posX, posY);
            case "j" : setCharWidthHeightPosition(AssetPaths.j__png, 18, 25, posX, posY);
            case "k" : setCharWidthHeightPosition(AssetPaths.k__png, 20, 25, posX, posY);
            case "l" : setCharWidthHeightPosition(AssetPaths.l__png, 22, 25, posX, posY);
            case "m" : setCharWidthHeightPosition(AssetPaths.m__png, 37, 25, posX, posY);
            case "n" : setCharWidthHeightPosition(AssetPaths.n__png, 32, 25, posX, posY);
            case "o" : setCharWidthHeightPosition(AssetPaths.o__png, 22, 28, posX, posY);
            case "õ" : setCharWidthHeightPosition(AssetPaths.o_til__png, 22, 28, posX, posY);
            case "ö" : setCharWidthHeightPosition(AssetPaths.o_trema__png, 22, 28, posX, posY);
            case "ô" : setCharWidthHeightPosition(AssetPaths.o_circunflexo__png, 22, 28, posX, posY);
            case "p" : setCharWidthHeightPosition(AssetPaths.p__png, 24, 25, posX, posY);
            case "q" : setCharWidthHeightPosition(AssetPaths.q__png, 24, 26, posX, posY);
            case "r" : setCharWidthHeightPosition(AssetPaths.r__png, 24, 25, posX, posY);
            case "s" : setCharWidthHeightPosition(AssetPaths.s__png, 22, 25, posX, posY);
            case "t" : setCharWidthHeightPosition(AssetPaths.t__png, 24, 25, posX, posY);
            case "u" : setCharWidthHeightPosition(AssetPaths.u__png, 22, 27, posX, posY);
            case "ú" : setCharWidthHeightPosition(AssetPaths.u_agudo__png, 22, 27, posX, posY);
            case "ü" : setCharWidthHeightPosition(AssetPaths.u_trema__png, 22, 27, posX, posY);
            case "v" : setCharWidthHeightPosition(AssetPaths.v__png, 27, 25, posX, posY);
            case "w" : setCharWidthHeightPosition(AssetPaths.w__png, 41, 25, posX, posY);
            case "x" : setCharWidthHeightPosition(AssetPaths.x__png, 26, 26, posX, posY);
            case "y" : setCharWidthHeightPosition(AssetPaths.y__png, 25, 25, posX, posY);
            case "z" : setCharWidthHeightPosition(AssetPaths.z__png, 27, 25, posX, posY);
            case " " : setCharWidthHeightPosition(AssetPaths.i__png, 15, 25, posX, posY);
        }

        loadGraphic(this._char, false, this._width, this._height, true);
        Char == " " ? visible = false : null;
    }

    override public function update(elapsed: Float)
    {
        if(_changed){
            setPosition(this._posX, this._posY);
            this._changed = false;
        }
        super.update(elapsed);
    }
}
