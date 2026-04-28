var forestStage:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var greenHill:FlxSprite;

var vg:FlxSprite = new FlxSprite();
var daStatic:FunkinSprite = new FunkinSprite();

function loadSpr(str:String) return getModImage(str);

function create() {
    final medaweba:String = 'SonicP2/';
    defaultCamZoom = 0.9;
	useCamMov = true;

    gf.scrollFactor.set(1.37, 1);
    dad.scrollFactor.set(1.37, 1);
	boyfriend.scrollFactor.set(1.37, 1);

    var sSKY:FlxSprite = new FlxSprite(-414, -440.8, loadSpr(medaweba + 'sky'));
	sSKY.antialiasing = Options.antialiasing;
	sSKY.scrollFactor.set(1, 1);
	sSKY.active = false;
    sSKY.scale.set(1.4, 1.4);
    forestStage.add(sSKY);

    var trees:FlxSprite = new FlxSprite(-290.55, -298.3, loadSpr(medaweba + 'backtrees'));
	trees.antialiasing = Options.antialiasing;
	trees.scrollFactor.set(1.1, 1);
	trees.active = false;
    trees.scale.set(1.2, 1.2);
	forestStage.add(trees);

    var bg2:FlxSprite = new FlxSprite(-306, -334.65, loadSpr(medaweba + 'trees'));
	bg2.updateHitbox();
	bg2.antialiasing = Options.antialiasing;
	bg2.scrollFactor.set(1.2, 1);
	bg2.active = false;
    bg2.scale.set(1.2, 1.2);
	forestStage.add(bg2);

    var bg:FlxSprite = new FlxSprite(-309.95, -240.2, loadSpr(medaweba + 'ground'));
	bg.antialiasing = Options.antialiasing;
	bg.scrollFactor.set(1.3, 1);
	bg.active = false;
    bg.scale.set(1.2, 1.2);
	forestStage.add(bg);

    greenHill = new FlxSprite(500, 200, loadSpr(medaweba + 'GreenHill'));
    greenHill.antialiasing = false;
    greenHill.scrollFactor.set(1, 1);
    greenHill.active = false;
    greenHill.visible = false;
    greenHill.scale.set(8, 8);

    insert(1, forestStage);
    insert(2, greenHill);
}

function postCreate() {
	precacheCharacter(0, 'EXE/exe-pixel');
	precacheCharacter(1, 'EXE/bf-pixel-exe');
	precacheCharacter(2, 'EXE/gf-pixel-exe');
	graphicCache.cache(Paths.image('modNotes/arrow-pixels'));
	graphicCache.cache(Paths.image('modNotes/arrowEnds'));

	camGame.followLerp = 0.06;
    vg.loadGraphic(loadSpr('RedVG'));
    vg.alpha = 0;
    vg.camera = camHUD;
    add(vg);

	daStatic.loadSprite(loadSpr('daSTAT'));
    daStatic.addAnim('static', 'staticFLASH', 24, false);
    daStatic.playAnim('static');
	daStatic.animation.finishCallback = (_) -> daStatic.visible = false;
    daStatic.camera = camHUD;
    daStatic.setGraphicSize(FlxG.width, FlxG.height);
    daStatic.screenCenter();
    daStatic.alpha = 0.0001;
    add(daStatic);
}

var camShake:Bool = true;

function onDadHit(_) if (camShake)
	FlxG.camera.shake(0.005, 0.50);

function switchToPixel(DO:Bool) {
	var skin:String = DO ? 'modNotes/arrow' : 'game/notes/default';
	for (forest in forestStage) forest.visible = DO ? false : true;
	greenHill.visible = DO ? true : false;
	camShake = DO ? false : true;

	daStatic.visible = true;
	daStatic.playAnim('static');
	daStatic.alpha = 1;
	playModSound('staticBUZZ');

	changeNoteSkin(skin, cpu, 'both', DO);
	changeNoteSkin(skin, player, 'both', DO);

	changeCharacter(0, DO ? 'EXE/exe-pixel' : 'EXE/exe-P2');
	changeCharacter(1, DO ? 'EXE/bf-pixel-exe' : 'bf');
	changeCharacter(2, DO ? 'EXE/gf-pixel-exe' : 'gf');

	if (DO) {
		vgEffect('cancel');

		boyfriend.setPosition(boyfriend.x + 50, boyfriend.y + 70);
		dad.setPosition(dad.x + 150, dad.y - 50);
		gf.setPosition(gf.x - 60, gf.y - 40);

		playerCam.x += 20;
		playerCam.y += 50;

		opponentCam.x += 50;
		opponentCam.y += 60;
	}
	else {
		boyfriend.setPosition(1000, -80);
		dad.setPosition(0, 0);
		gf.setPosition(485.5, 15.1);

		playerCam.x -= 20;
		playerCam.y -= 50;

		opponentCam.x -= 50;
		opponentCam.y -= 60;
	}
}
function stepHit() switch(curStep) {
	case 528: switchToPixel(true);
	case 784: switchToPixel(false);
	case 80, 785: vgEffect('init');
}

function vgEffect(func:String) switch(func) {
	default: // init
		vg.visible = true;
		vg.alpha = 0;
		FlxTween.tween(vg, {alpha: 1}, 0.9, {ease: FlxEase.quadInOut, type: 4});
	case 'cancel':
		FlxTween.cancelTweensOf(vg);
		FlxTween.tween(vg, {alpha: 0}, 0.9, {ease: FlxEase.backInOut, onComplete: (_) -> vg.visible = false});
}