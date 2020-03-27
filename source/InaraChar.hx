package;

import flixel.FlxSprite;

class InaraChar extends FlxSprite
{
    private var _char:String;
    private var _width:Float;
    private var _height:Float;

    private function setCharWidthHeight(c: String, w:Float, h:Float):Void
    {
        _char = c;
        _width = w;
        _height = h;
    }
    public function new(?X:Float=0, ?Y:Float=0, Char:String)
    {
        super(X, Y);

        switch(Char){
            case "*" : setCharWidthHeight(AssetPaths.asterisco__png, 15, 25);
            case "/" : setCharWidthHeight(AssetPaths.barra__png, 29, 25);
            case ":" : setCharWidthHeight(AssetPaths.dois_pontos__png, 7, 15);
            case "?" : setCharWidthHeight(AssetPaths.interrogacao__png, 23, 25);
            case "%" : setCharWidthHeight(AssetPaths.porcentagem__png, 26, 25);
            case "¨" : setCharWidthHeight(AssetPaths.trema__png, 15, 7);
            case "-" : setCharWidthHeight(AssetPaths.___png, 18, 25);
            case "~" : setCharWidthHeight(AssetPaths.til__png, 15, 6);
            case "´" : setCharWidthHeight(AssetPaths.agudo__png, 11, 10);
            case "," : setCharWidthHeight(AssetPaths.virgula__png, 8, 25);
            case "!" : setCharWidthHeight(AssetPaths.exclamacao__png, 11, 25);
            case "+" : setCharWidthHeight(AssetPaths.mais__png, 18, 25);
            case "0" : setCharWidthHeight(AssetPaths.num_0__png, 22, 25);
            case "1" : setCharWidthHeight(AssetPaths.num_1__png, 12, 25);
            case "2" : setCharWidthHeight(AssetPaths.num_2__png, 23, 25);
            case "3" : setCharWidthHeight(AssetPaths.num_3__png, 24, 25);
            case "4" : setCharWidthHeight(AssetPaths.num_4__png, 20, 25);
            case "5" : setCharWidthHeight(AssetPaths.num_5__png, 23, 25);
            case "6" : setCharWidthHeight(AssetPaths.num_6__png, 23, 25);
            case "7" : setCharWidthHeight(AssetPaths.num_7__png, 25, 25);
            case "8" : setCharWidthHeight(AssetPaths.num_8__png, 27, 25);
            case "9" : setCharWidthHeight(AssetPaths.num_9__png, 25, 25);
            case "a" : setCharWidthHeight(AssetPaths.a__png, 25, 25);
            case "á" : setCharWidthHeight(AssetPaths.a_agudo__png, 25, 27);
            case "ã" : setCharWidthHeight(AssetPaths.a_til__png, 25, 25);
            case "â" : setCharWidthHeight(AssetPaths.a_circunflexo__png, 25, 30);
            case "ä" : setCharWidthHeight(AssetPaths.a_trema__png, 25, 25);
            case "b" : setCharWidthHeight(AssetPaths.b__png, 20, 25);
            case "c" : setCharWidthHeight(AssetPaths.c__png, 22, 25);
            case "ç" : setCharWidthHeight(AssetPaths.c_cedilha__png, 22, 26);
            case "d" : setCharWidthHeight(AssetPaths.d__png, 23, 25);
            case "e" : setCharWidthHeight(AssetPaths.e__png, 22, 25);
            case "é" : setCharWidthHeight(AssetPaths.e_agudo__png, 22, 27);
            case "ê" : setCharWidthHeight(AssetPaths.e_circunflexo__png, 22, 27);
            case "ë" : setCharWidthHeight(AssetPaths.e_trema__png, 22, 27);
            case "f" : setCharWidthHeight(AssetPaths.f__png, 22, 26);
            case "g" : setCharWidthHeight(AssetPaths.g__png, 22, 25);
            case "h" : setCharWidthHeight(AssetPaths.h__png, 25, 25);
            case "i" : setCharWidthHeight(AssetPaths.i__png, 15, 25);
            case "í" : setCharWidthHeight(AssetPaths.i_agudo__png, 15, 25);
            case "ï" : setCharWidthHeight(AssetPaths.i_trema__png, 15, 25);
            case "j" : setCharWidthHeight(AssetPaths.j__png, 18, 25);
            case "k" : setCharWidthHeight(AssetPaths.k__png, 20, 25);
            case "l" : setCharWidthHeight(AssetPaths.l__png, 22, 25);
            case "m" : setCharWidthHeight(AssetPaths.m__png, 37, 25);
            case "n" : setCharWidthHeight(AssetPaths.n__png, 32, 25);
            case "o" : setCharWidthHeight(AssetPaths.o__png, 22, 28);
            case "õ" : setCharWidthHeight(AssetPaths.o_til__png, 22, 28);
            case "ö" : setCharWidthHeight(AssetPaths.o_trema__png, 22, 28);
            case "ô" : setCharWidthHeight(AssetPaths.o_circunflexo__png, 22, 28);
            case "p" : setCharWidthHeight(AssetPaths.p__png, 24, 25);
            case "q" : setCharWidthHeight(AssetPaths.q__png, 24, 26);
            case "r" : setCharWidthHeight(AssetPaths.r__png, 24, 25);
            case "s" : setCharWidthHeight(AssetPaths.s__png, 22, 25);
            case "t" : setCharWidthHeight(AssetPaths.t__png, 24, 25);
            case "u" : setCharWidthHeight(AssetPaths.u__png, 22, 27);
            case "ú" : setCharWidthHeight(AssetPaths.u_agudo__png, 22, 27);
            case "ü" : setCharWidthHeight(AssetPaths.u_trema__png, 22, 27);
            case "v" : setCharWidthHeight(AssetPaths.v__png, 27, 25);
            case "w" : setCharWidthHeight(AssetPaths.w__png, 41, 25);
            case "x" : setCharWidthHeight(AssetPaths.x__png, 26, 26);
            case "y" : setCharWidthHeight(AssetPaths.y__png, 25, 25);
            case "z" : setCharWidthHeight(AssetPaths.z__png, 27, 25);     
        }

        loadGraphic(_char, false, _width, _height, false);
    }
}
