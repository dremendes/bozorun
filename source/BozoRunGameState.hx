package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.addons.display.FlxBackdrop;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxAxes;
import extension.eightsines.EsOrientation;
import flixel.system.scaleModes.FillScaleMode;
import flixel.util.FlxDirectionFlags;

class BozoRunGameState extends FlxState
{
	private static inline var TILE_WIDTH:Int = 16;
	private static inline var TILE_HEIGHT:Int = 16;
	private static var random = FlxG.random;
	private static var _taPulando:Bool = false;
	private static var _tocarSons:Bool = true;

	private var _menuPausadoSubState:PausadoSubState;

	// base speed for player, stands for xVelocity
	private static inline var BASE_SPEED:Int = 150;

	// aceleração horizontal do Bozo
	private static inline var xAcceleration:Int = 120;

	// força da 'gravidade'
	private static inline var yAcceleration:Int = 1400;

	// velocidade máxima de 'queda'
	private static inline var yVelocity:Int = 1400;

	// tempo máximo de subida no pulo, antes de começar a descer
	private static inline var _duracaoPulo:Float = .25;

	private var _bozo:FlxSprite;
	private var _bozoDeitado:FlxSprite;
	private var _aviao:FlxSprite;
	private var _pular:Float;
	private var _tocarPulo:Bool;
	private var _pularPressionado:Bool;
	private var _estaAbaixado:Bool;
	private var _morrer:Bool;
	private var _tooglePausar:Bool = false;
	private var _auxX:Float = 0.0;
	private var _totalVidas = 3;
	private var _vida0:FlxSprite;
	private var _vida1:FlxSprite;
	private var _vida2:FlxSprite;
	private var _paddingTop:Float = (FlxG.width < FlxG.height) ? (FlxG.height - 300) / 2 : 0;

	private var _laranja1:FlxSprite;
	private var _laranja2:FlxSprite;
	private var _laranja3:FlxSprite;

	private var _fantasma:FlxSprite;
	private var _impeachmado:FlxSprite;
	private var _bozomovel:FlxSprite;
	private var _barreiraBozomovel:FlxSprite;

	// onde começar a gerar objetos do jogo
	private var _pontaDireitaCenario:Int;
	private var _posicaoOcupadaX:Float = 0;

	// imagens do cenário de fundo
	private var _fundosGrupo:FlxSpriteGroup;
	private var _fundoCeu:FlxBackdrop;
	private var _fundoCenario:FlxBackdrop;
	private var _chao:FlxBackdrop;

	// grupos de colisões
	private var _grupoChao:FlxSpriteGroup = new FlxSpriteGroup();
	private var _grupoLivros:FlxSpriteGroup = new FlxSpriteGroup();
	private var _grupoLaranjas:FlxSpriteGroup = new FlxSpriteGroup();
	private var _grupoBozoMovel:FlxSpriteGroup = new FlxSpriteGroup();
	private var _quantiaLaranjas:Int = 0;

	private var _mudou:Bool; // indica se os grupos de colisões mudaram

	private var _distancia:Int;

	private var _botaoIndicadorUp:FlxButton;
	private var _botaoIndicadorDown:FlxButton;
	private var _pausarButton:FlxButton;

	private var _voltarButton:FlxButton;
	private var _pontosTexto:FlxText;
	private var _arrayLivros:Array<String> = [
		AssetPaths.livros1__png,
		AssetPaths.livros2__png,
		AssetPaths.livros3__png,
		AssetPaths.livros4__png,
		AssetPaths.livros5__png,
		AssetPaths.livros6__png
	];
	private var _piscando:Bool = true;
	private var _levantando:Bool = false;

	override public function create():Void
	{
		EsOrientation.setScreenOrientation(EsOrientation.ORIENTATION_LANDSCAPE);

		#if html5
		FlxG.mouse.visible = true;
		#end

		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		FlxG.camera.antialiasing = false;

		// garate que o mundo é grande o bastante, 400,000 tiles devem ser suficientes...
		FlxG.worldBounds.setSize(TILE_WIDTH * 400000, 400 + _paddingTop * 2);
		FlxG.worldBounds.setPosition(FlxG.worldBounds.left, FlxG.worldBounds.top);
		destroySubStates = false; // Necessário pra que o substate continue acessível

		_menuPausadoSubState = new PausadoSubState(new FlxColor(0x99808080));

		configurarFundo();

		iniciarGruposDeColisoes();

		// lógica do chão e de da ponta até onde serão criados objetos do cenário
		configuraPlataforma();

		// prepare player related variables
		configurarBozo();
		configurarInterface();
		iniciarBozo();
		//iniciarBozoMovel();
	}

	static private inline function onInterstitialEvent(event:String){}

	// Procure iniciar os grupos dos objetos ao estado antes da interface
	// pra que os objetos da interface fiquem visualmente na frente, veja:
	// https://groups.google.com/d/msg/haxeflixel/DrDXEani_oY/Om_KzuCVWeEJ
	private inline function iniciarGruposDeColisoes():Void
	{
		add(_grupoLivros);
		add(_grupoLaranjas);
		add(_grupoChao);
	}

	private inline function configurarFundo():Void
	{
		_fundoCeu = new FlxBackdrop(AssetPaths.sky__png, FlxAxes.X, 0, 0);
		_fundoCeu.velocity.x = -20;
		_fundoCenario = new FlxBackdrop(AssetPaths.bg__png, FlxAxes.X, 0, 0);
		_fundoCeu.scale.set(1, _paddingTop == 0 ? 1.2 : 2);
		_fundoCenario.scale.set(1, _paddingTop == 0 ? 1.5 : 2.5);
		_fundosGrupo = new FlxSpriteGroup();

		_aviao = new FlxSprite().loadGraphic(AssetPaths.aviao__png, true, 91, 17);
		_aviao.animation.add("voando", [0, 1], 10, true);
		_aviao.animation.play("voando");
		_aviao.setPosition(0, 40);

		_fundosGrupo.add(_fundoCeu);
		_fundosGrupo.add(_fundoCenario);
		_fundosGrupo.add(_aviao);

		add(_fundosGrupo);
	}

	private inline function configurarBozo():Void
	{
		_bozo = new FlxSprite().loadGraphic(AssetPaths.Jair__png, true, 104, 122);
		_bozo.scale.set(0.3, 1.2);
		_bozo.updateHitbox();
		_bozo.scale.set(0.9, 1.2);

		_bozoDeitado = new FlxSprite().loadGraphic(AssetPaths.jairtomando__png, true, 122, 140);
		_bozoDeitado.height = 40;
		_bozoDeitado.offset.set(0, 90);
		_bozoDeitado.visible = false; // false pois só será exibido quando o jogador abaixar o Bozo
		_bozoDeitado.scale.set(0.6, 1.2);
		_bozoDeitado.updateHitbox();
		_bozoDeitado.scale.set(0.56, 1.2);
		configuraAnimacoes();

		// Adiciona Bozo em pé e deitado mas a princípio só exibe ele em pé
		add(_bozo);
		add(_bozoDeitado);
		add(_grupoBozoMovel);
		// por último adiciona _grupoBozoMovel pra criar efeito do Bozo atrás das grades do carro-de-som

		// 'fantasma' que segue o Bozo, mas sem pular, e é seguido pela camera.
		_fantasma = new FlxSprite(_bozo.x + FlxG.width - TILE_WIDTH, FlxG.height / 2);

		FlxG.camera.follow(_fantasma);
	}

	private inline function fazBozoPular():Void
	{
		_pularPressionado = true;
		var timerPulo = new haxe.Timer(1);
		timerPulo.run = () ->
		{
			_pularPressionado = false;
			timerPulo.stop();
		}
	}

	private inline function configurarInterface():Void
	{
		_pausarButton = new FlxButton(0, 0, "", () ->
		{
			if (_tocarSons)
				FlxG.sound.play(AssetPaths.beepbotao__ogg);
			openSubState(_menuPausadoSubState);
		});
		_pausarButton.loadGraphic(AssetPaths.pausar__png, true, 60, 34);
		_pausarButton.setPosition(124, 4);
		_pausarButton.scrollFactor.set(0, 0);
		add(_pausarButton);

		_voltarButton = new FlxButton(0, 0, "", () ->
		{
			if (_tocarSons)
				FlxG.sound.play(AssetPaths.beepbotao__ogg);
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, () -> FlxG.switchState(new MainMenuState()));
		});
		_voltarButton.loadGraphic(AssetPaths.voltar__png, true, 60, 34);
		_voltarButton.setPosition(189, 4);
		_voltarButton.scrollFactor.set(0, 0);
		add(_voltarButton);

		_pontosTexto = new FlxText(52, 12, TILE_WIDTH * 3 + 25, "", 11);
		_pontosTexto.scale.set(1,2);
		_pontosTexto.scrollFactor.set(0, 0);
		_pontosTexto.borderStyle = OUTLINE;
		_pontosTexto.color = 0xFF0000; // cor vermelha
		add(_pontosTexto);

		// adiciona indicadores de vidas do Bozo
		_vida0 = new FlxSprite(0, 0).loadGraphic(AssetPaths.coracao__png, true, 28, 23);
		_vida0.scale.set(0.6, 1);
		_vida0.scrollFactor.set(0, 0);
		_vida0.animation.add('vivo', [0], 1, false);
		_vida0.animation.add('morto', [1], 1, false);
		add(_vida0);

		_vida1 = new FlxSprite(15, 0).loadGraphic(AssetPaths.coracao__png, true, 28, 23);
		_vida1.scale.set(0.6, 1);
		_vida1.scrollFactor.set(0, 0);
		_vida1.animation.add('vivo', [0], 1, false);
		_vida1.animation.add('morto', [1], 1, false);
		add(_vida1);

		_vida2 = new FlxSprite(30, 0).loadGraphic(AssetPaths.coracao__png, true, 28, 23);
		_vida2.scale.set(0.6, 1);
		_vida2.scrollFactor.set(0, 0);
		_vida2.animation.add('vivo', [0], 1, false);
		_vida2.animation.add('morto', [1], 1, false);
		add(_vida2);

		_laranja1 = new FlxSprite(3, 24, AssetPaths.laranja__png);
		_laranja1.scale.set(0.7, 1);
		_laranja1.scrollFactor.set(0, 0);
		_laranja1.visible = false;
		add(_laranja1);

		_laranja2 = new FlxSprite(15, 24, AssetPaths.laranja__png);
		_laranja2.scale.set(0.7, 1);
		_laranja2.scrollFactor.set(0, 0);
		_laranja2.visible = false;
		add(_laranja2);

		_laranja3 = new FlxSprite(28, 24, AssetPaths.laranja__png);
		_laranja3.scale.set(0.7, 1);
		_laranja3.scrollFactor.set(0, 0);
		_laranja3.visible = false;
		add(_laranja3);

		_botaoIndicadorUp = new FlxButton(0, 0, "");
		_botaoIndicadorUp.loadGraphic(AssetPaths.seta__png, true, 36, 36);
		_botaoIndicadorUp.setPosition(FlxG.width - 40, FlxG.height / 2 - 35);
		_botaoIndicadorUp.scrollFactor.set(0, 0);
		add(_botaoIndicadorUp);

		_botaoIndicadorDown = new FlxButton(0, 0, "", () -> _estaAbaixado = true);
		_botaoIndicadorDown.loadGraphic(AssetPaths.seta__png, true, 36, 36);
		_botaoIndicadorDown.setPosition(FlxG.width - 40, FlxG.height / 2 + 5);
		_botaoIndicadorDown.scrollFactor.set(0, 0);
		_botaoIndicadorDown.setFacingFlip(FlxDirectionFlags.DOWN, false, true);
		_botaoIndicadorDown.facing = FlxDirectionFlags.DOWN;
		add(_botaoIndicadorDown);

		_fundoCenario.y += 110;
	}

	private inline function configuraPlataforma():Void
	{
		_chao = new FlxBackdrop(AssetPaths.groundtiles__png, FlxAxes.X, 0, 0);
		_chao.allowCollisions = FlxDirectionFlags.ANY;
		_chao.immovable = true;
		_chao.solid = true;
		_chao.setPosition(0, FlxG.height * .85);
		_chao.setSize(400000, 70);

		_grupoChao.add(_chao);
		_pontaDireitaCenario = (_distancia - 1) * TILE_WIDTH; // Onde objetos serão criados até aí
	}

	private inline function iniciarBozo():Void
	{
		// Começa pulando, caindo do alto.
		_pular = -1;
		_tocarPulo = true;
		_estaAbaixado = false;
		_pularPressionado = false;
		_morrer = true;

		_bozo.setPosition(_distancia * TILE_WIDTH, 0 + _paddingTop);
		_bozoDeitado.visible = false;
		_bozoDeitado.setPosition(_distancia * TILE_WIDTH, -20 + _paddingTop);

		// Física básica pro Bozo
		_bozo.velocity.set(0, 0);
		_bozo.maxVelocity.set(BASE_SPEED, yVelocity);
		_bozo.acceleration.set(xAcceleration, yAcceleration);

		_bozoDeitado.velocity.set(0, 0);
		_bozoDeitado.maxVelocity.set(BASE_SPEED, yVelocity);
		_bozoDeitado.acceleration.set(xAcceleration, yAcceleration);

		configuraAnimacoes();

		// movimenta câmera pra acompanhar o Bozo
		_fantasma.x = _bozo.x - (TILE_WIDTH * .2) + (FlxG.width * .5);

		_piscando = true;
		var _timerPiscando = new haxe.Timer(3000);
		_timerPiscando.run = () ->
		{
			_piscando = false;
			_bozo.visible = true;
			_timerPiscando.stop();
		}
	}

	private inline function iniciarBozoMovel():Void
	{
		_bozomovel = new FlxSprite().loadGraphic(AssetPaths.bozomovel__png, true, 101, 85);
		_bozomovel.animation.add("emMovimento", [0, 1, 2], 9);
		_bozomovel.animation.play("emMovimento");
		_bozomovel.setPosition(_bozo.x + 200, 90);
		_bozomovel.velocity.y = yAcceleration * .25;
		_bozomovel.velocity.x = 380;
		_bozomovel.scale.set(3, 1.8);
		_bozomovel.updateHitbox();
		_bozomovel.scale.set(3, 3);
		_bozomovel.y += 40;
		_barreiraBozomovel = new FlxSprite().loadGraphic(AssetPaths.barreiraBozoMovel__png, false, 8, 140);
		_barreiraBozomovel.velocity.y = yAcceleration * .25;
		_barreiraBozomovel.velocity.x = _bozomovel.velocity.x;
		_barreiraBozomovel.scale.set(2, 1.5);
		_barreiraBozomovel.updateHitbox();
		_barreiraBozomovel.setPosition(_bozomovel.x + 280, 90);
		_grupoBozoMovel.add(_bozomovel);
		_grupoBozoMovel.add(_barreiraBozomovel);
	}

	private inline function aoReiniciar():Void
		if (_totalVidas > 0)
			iniciarBozo()
		else
		{
			_bozo.acceleration.x = _bozoDeitado.acceleration.x = _bozo.velocity.x = _bozoDeitado.velocity.x = 0; // Bozo agora fica parado
			_impeachmado = new FlxSprite().loadGraphic(AssetPaths.impitimado__png, false, 250, 117);
			_impeachmado.setPosition(_bozo.x + ((FlxG.width / 2) - (_impeachmado.width / 2)), 80);
			add(_impeachmado);
			FlxG.camera.shake(0.01, 0.2);
			_voltarButton.scale.set(1, 1.4);
			_voltarButton.updateHitbox();
			_voltarButton.setPosition(FlxG.width / 2 - 25, 220);
		}

	private inline function tocarPluftAnimacao(x:Float, y:Float, scale:Float = 3):Void
	{
		var pluft = new FlxSprite().loadGraphic(AssetPaths.pluft__png, true, 36, 38);
		pluft.animation.add("explode", [0, 1, 2, 3, 4], false);
		pluft.animation.play("explode");
		pluft.scale.set(scale, scale);
		pluft.animation.finishCallback = (s) -> pluft.destroy();
		pluft.setPosition(x, y + 15);
		add(pluft);
	}

	private inline function processaColisaoBozoLivros(_obj1, _obj2):Void
	{
		if ((_obj1.x + 30) < _obj2.x && (_obj1.y - 60) < _obj2.y && _quantiaLaranjas >= 1)
		{
			tocarPluftAnimacao(_obj2.x, _obj2.y);
			_obj2.destroy();
			if (_tocarSons)
				FlxG.sound.play(AssetPaths.tiro__ogg);
			if (_quantiaLaranjas >= 1)
				_quantiaLaranjas--;

			switch (_quantiaLaranjas)
			{
				case 0:
					_laranja1.visible = false;
				case 1:
					_laranja2.visible = false;
				case 2:
					_laranja3.visible = false;
			}
		}
	}

	private inline function processaColisaoBozoMovelLivros(_obj1, _obj2):Void
	{
		tocarPluftAnimacao(_obj2.x, _obj2.y);
		_obj2.destroy();
		if (_tocarSons)
			FlxG.sound.play(AssetPaths.tiro__ogg);
		_bozomovel.velocity.x = 380;
		// _barreiraBozomovel.velocity.x = _bozomovel.velocity.x;
	}

	private inline function atualizaControlesOpcoes():Void
		_tocarSons = _menuPausadoSubState.tocarSons;

	/*************************
	 *
	 * Updaters
	 *
	 * Aqui é onde o processo passa a maior parte do tempo executando. Tente
	 * fazer o máximo de otimizações possíveis nessas funções pra que o jogo
	 * execute rápida e fluidamente. Se possível, projete funções updaters pra
	 * que sejam inline.
	 *
	*************************/
	override public function update(elapsed:Float):Void
	{
		// realiza coleta de lixo (garbage collection)
		atualizaObjetos();
		atualizaControlesOpcoes();
		// atualizaBozoMovel();

		atualizaBozo(elapsed);

		// grupos de objetos que colidem foram atualizados?
		if (_mudou)
		{
			_grupoChao.update(elapsed);
			_grupoLaranjas.update(elapsed);
			_grupoLivros.update(elapsed);

			_mudou = false; // grupos de objetos que colidem estão atualizados
		}

		if (_estaAbaixado ? FlxG.overlap(_bozoDeitado, _grupoLaranjas,
			(_bozoDeitado, _laranja) -> _laranja.destroy()) : FlxG.overlap(_bozo, _grupoLaranjas, (_bozo, _laranja) -> _laranja.destroy()))
		{
			_tocarPulo = false;
			if (_tocarSons)
				FlxG.sound.play(AssetPaths.laranja__ogg);
			if (_quantiaLaranjas < 3 && ++_quantiaLaranjas == _quantiaLaranjas)
				switch (_quantiaLaranjas)
				{
					case 1:
						_laranja1.visible = true;
					case 2:
						_laranja2.visible = true;
					case 3:
						_laranja3.visible = true;
				}
		}

		// FlxG.collide(_grupoBozoMovel, _grupoChao);
		// FlxG.collide(_barreiraBozomovel, _grupoChao);
		// FlxG.collide(_barreiraBozomovel, _bozo);
		// FlxG.collide(_grupoBozoMovel, _bozo);
		// FlxG.collide(_grupoBozoMovel, _grupoLivros, processaColisaoBozoMovelLivros);
		FlxG.collide(_bozoDeitado, _grupoChao);
		if (FlxG.collide(_bozo, _grupoChao))
		{
			_tocarPulo = false;
			// bozo tá no chão?
			if (_bozo.velocity.x > 0 && !_pularPressionado)
				_pular = 0; // reseta variável do pulo
		};

		// colidiu com livro?
		if (!_piscando
			&& (_estaAbaixado ? FlxG.overlap(_bozoDeitado, _grupoLivros,
				processaColisaoBozoLivros) : FlxG.overlap(_bozo, _grupoLivros, processaColisaoBozoLivros)))
		{
			_tocarPulo = false;
			_pular = 0;

			if (_quantiaLaranjas == 0
				&& (_estaAbaixado ? FlxG.collide(_bozoDeitado, _grupoLivros) : FlxG.collide(_bozo, _grupoLivros))
				&& (_bozo.velocity.x <= 0 || _bozoDeitado.velocity.x <= 0)
				&& _quantiaLaranjas <= 0)
			{
				// player went splat
				_pular = -1;
				_tocarPulo = false;
				if (xAcceleration > 0 && _morrer)
					FlxG.camera.shake(0.01, 0.2);
				if (_morrer)
				{
					_totalVidas -= 1;
					switch (_totalVidas)
					{
						case 2:
							_vida2.animation.play("morto");
						case 1:
							_vida1.animation.play("morto");
						case 0:
							_vida0.animation.play("morto");
					}
				}
				morrer();
			}
			if (!_piscando)
				FlxG.collide(_estaAbaixado ? _bozoDeitado : _bozo, _grupoLivros);
		}

		if (_piscando)
			_bozo.visible = !_bozo.visible;

		animacaoBozo();
		atualizaAviao();

		super.update(elapsed);

		updateUI();
	}

	private inline function atualizaAviao():Void
		_aviao.x += 6.75;

	private inline function updateUI():Void
	{
		_distancia = Std.int(_bozo.x / (TILE_WIDTH));

		_pontosTexto.text = Std.string("Recorde:  " + _distancia + "m");

		// camera segue fantasma, não jogador, pra que não suba com os pulos
		_fantasma.x = _bozo.x - (TILE_WIDTH * .2) + (FlxG.width * .5);
	}

	private inline function fazBozoLevantar():Void
	{
		if (_bozoDeitado.animation.name == "deitando" || _bozoDeitado.animation.name == "flexao")
		{
			_bozoDeitado.animation.play("levantando");
			_bozoDeitado.animation.finishCallback = (animNome:String) ->
			{
				_estaAbaixado = false;
				_bozoDeitado.animation.play("morrendoDeitado");
			}
		}
	}

	private inline function atualizaBozo(elapsed:Float):Void
	{
		// acelera, até o máximo de 420
		if (_bozo.maxVelocity.x < 420)
		{
			_bozo.maxVelocity.x = 420;
			_bozoDeitado.maxVelocity.x = 420;
		}
		// sincroniza posição dos Bozos

		_bozo.velocity.x = _bozo.velocity.x > _bozoDeitado.velocity.x ? _bozoDeitado.velocity.x : _bozo.velocity.x;
		#if (!windows && !linux)
		var _taTocando:Bool = FlxG.touches.getFirst() != null;
		_taPulando = _taTocando
			&& ((FlxG.touches.getFirst().justPressedPosition.y < (FlxG.height / 2))
				&& (FlxG.touches.getFirst().justPressedPosition.y > 40)) ? true : false;
		if (_taTocando && (FlxG.touches.getFirst().justPressedPosition.y > (FlxG.height / 2)))
			_estaAbaixado = true;
		#end

		#if html5
		FlxG.keys.anyPressed(["DOWN"]) ? _estaAbaixado = true : null;

		FlxG.keys.anyPressed(["UP"]) || _taPulando ? _estaAbaixado ? fazBozoLevantar() : fazBozoPular() : _pularPressionado = false;
		#end
		#if mobile
		_taPulando ? _estaAbaixado ? fazBozoLevantar() : fazBozoPular() : _pularPressionado = false;
		#end

		// Se Bozo parou ou mal está andando, ele pode morrer (e tocar o som de machucado)
		if (_bozo.velocity.x > 10)
			_morrer = true;

		if (_pular != -1 && _pularPressionado)
		{
			// toca o som de pulo somente no primeiro instante do pulo
			if (_pular == 0)
			{
				if (_tocarSons)
					FlxG.sound.play(AssetPaths.goblin_1__ogg);
				tocarPluftAnimacao(_bozo.x + 15, _bozo.y + 80, 1.5);
			}

			// Soma na conta o tempo do frame atual caso esteja pulando
			_pular += elapsed;

			if (_bozo.velocity.y >= 0)
			{
				_tocarPulo = true; // Seta flag pra tocar animação do pulo
				_bozo.y -= 1; // faz o Bozo pular, sair do chão
				_bozo.velocity.y = -yAcceleration * .5; // tipo a velocidade inicial do pulo
				_bozo.acceleration.y = -yAcceleration; // Aceleração do pulo pra ir pro alto (y negativo)
			}

			if (_pular > _duracaoPulo)
				_pular = -1; // pára de subir pro alto se o tempo de pulo já deu
		}
		else if (!_pularPressionado || _pular == -1)
		{
			if (_bozo.velocity.y < 0)
			{
				_bozo.acceleration.y = yAcceleration; // seta aceleração pra puxar pro chão (y positivo)
				_bozo.velocity.y = yAcceleration * .25; // velocidade inicial da descida
			}
		}
	}
	private inline function atualizaObjetos():Void
	{
		// confere se precisa fazer mais objetos e remover antigos
		if ((_bozo.x + FlxG.width) * 2 > _pontaDireitaCenario)
		{
			fazerObjetos();
			// remove livros e laranjas assim que estão fora da tela
			_grupoLivros.forEach((book) -> if (book.x < (_bozo.x - 85))
			{
				book.destroy();
				_grupoLivros.remove(book);
			});
			_grupoLaranjas.forEach((orange) -> if (orange.x < (_bozo.x - 85))
			{
				orange.destroy();
				_grupoLaranjas.remove(orange);
			});
		}
	}

	private inline function atualizaBozoMovel():Void
		_barreiraBozomovel.setPosition(_bozomovel.x + 280, _barreiraBozomovel.y);

	private inline function gerarIntForaDaFaixaX(x:Float, _rangeProibido:Float):Float
	{
		var randomIntPosX:Float = _bozo.x + FlxG.width + random.int(250, 380);
		return ((x - _rangeProibido) > randomIntPosX)
			|| ((x + _rangeProibido) < randomIntPosX) ? randomIntPosX : gerarIntForaDaFaixaX(x, _rangeProibido);
	}

	private inline function criarObstaculoEColocarNoGrupo(Path:FlxGraphicAsset, width:Int, height:Int, grupo:FlxSpriteGroup, isSolid:Bool = true,
			isImmovable:Bool = true):Void
	{
		var obj = new AssetLoader(Path, width, height);
		obj.scale.set(0.6, 1.4);
		obj.updateHitbox();
		obj.scale.set(0.9, 1.4);
		obj.x = gerarIntForaDaFaixaX(_posicaoOcupadaX, 50);
		obj.y = random.float(FlxG.height - 240, FlxG.height - 100);
		obj.solid = isSolid;
		obj.immovable = isImmovable;
		_posicaoOcupadaX = obj.x;
		grupo.add(obj);
	}

	private inline function fazerObjetos(wide:Int = 0, high:Int = 0):Void
	{
		_pontaDireitaCenario += TILE_WIDTH * 2;

		if (_pontaDireitaCenario % 200 == 0)
			if (random.int(0, 2) % 2 == 0)
				criarObstaculoEColocarNoGrupo(_arrayLivros[random.int(0, 5)], 45, 55, _grupoLivros, true, true);
		if (_pontaDireitaCenario % 350 == 0)
			criarObstaculoEColocarNoGrupo(AssetPaths.laranja__png, 23, 23, _grupoLaranjas, true, false);

		_mudou = true;
	}

	private inline function animacaoBozo():Void
	{
		if (_bozo.velocity.x <= 3)
			_estaAbaixado ? _bozoDeitado.animation.play("morrendoDeitado") : _bozo.animation.play("morrendo");
		else if (_tocarPulo)
			_bozo.animation.play("pulando")
		else if (_bozo.velocity.y != 0)
			_bozo.animation.play("caindo")
		else if (_estaAbaixado)
		{
			_bozo.visible = false;
			if (_bozoDeitado.animation.name != "deitando"
				&& _bozoDeitado.animation.name != "flexao"
				&& _bozoDeitado.animation.name != "levantando")
			{
				_bozoDeitado.animation.play("deitando");
				_bozoDeitado.animation.finishCallback = (s) -> _bozoDeitado.animation.play("flexao");
			}
			_piscando ? _bozoDeitado.visible = !_bozoDeitado.visible : _bozoDeitado.visible = true;
		}
		else
		{
			_bozo.animation.play("fugindo");
			if (!_piscando)
			{
				_bozoDeitado.visible = false;
				_bozo.visible = true;
			}
		}
	}

	private inline function configuraAnimacoes():Void
	{
		_bozo.animation.add("fugindo", [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 30, true);
		_bozo.animation.add("pulando", [15, 14], 7, false);
		_bozo.animation.add("caindo", [16, 17], 7, false);
		_bozo.animation.add("morrendo", [22, 23], 15, false);
		_bozo.animation.add("deitando", [0, 1, 2, 3], 4, true);

		_bozoDeitado.animation.add("deitando", [0, 1, 2, 3], 12, false);
		_bozoDeitado.animation.add("levantando", [7, 8], 12, false);
		_bozoDeitado.animation.add("flexao", [1, 2, 3, 4, 5, 6, 7], 14, true);
		_bozoDeitado.animation.add("morrendoDeitado", [9, 10], 6, true);
	}

	private inline function morrer():Void
		if (_morrer)
		{
			if (_tocarSons)
				FlxG.sound.play(AssetPaths.tiro__ogg);
			var timerTiro = new haxe.Timer(400);
			timerTiro.run = () ->
			{
				if (_tocarSons)
					FlxG.sound.play(AssetPaths.goblin_9__ogg);
				timerTiro.stop();
			}
			_morrer = false;
			var timerPraReiniciar = new haxe.Timer(500);
			timerPraReiniciar.run = () ->
			{
				_estaAbaixado = false;
				aoReiniciar();
				timerPraReiniciar.stop();
			}
		}

	override public function destroy():Void
	{
		_bozo.destroy();
		// _barreiraBozomovel.destroy();
		// _bozomovel.destroy();
		_vida0.destroy();
		_vida1.destroy();
		_vida2.destroy();
		_laranja1.destroy();
		_laranja2.destroy();
		_laranja3.destroy();
		_fantasma.destroy();
		_fundoCeu.destroy();
		_fundoCenario.destroy();
		_chao.destroy();
		_fundosGrupo.destroy();
		_grupoChao.destroy();
		_grupoLivros.destroy();
		_grupoLaranjas.destroy();
		_grupoBozoMovel.destroy();
		_pausarButton.destroy();
		_voltarButton.destroy();
		_pontosTexto.destroy();
		super.destroy();
	}
}
