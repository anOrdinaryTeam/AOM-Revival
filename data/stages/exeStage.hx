var go:Bool = false;

function onStartCountdown(e) if (!go) {
    e.cancel();
    go = true;
    new FlxTimer().start(1, startCountdown);
}

function Fkaer(str:String)
    return getModImage('exeBg/$str');

function addF(spr:Dynamic) if (spr != null) {
    spr.antialiasing = Options.antialiasing;
    spr.scale.set(1.2, 1.2);
    addSprite(spr);
}

var vgblack:FlxSprite;
var tentas:FlxSprite;

function create() {
    defaultCamZoom = 0.8;

    var sky:FlxSprite = new FlxSprite(-414, -240.8, Fkaer('sky'));
    addF(sky);

    var btrees:FlxSprite = new FlxSprite(-290.55, -298.3, Fkaer('backtrees'));
    btrees.scrollFactor.x = 1.1;
    addF(btrees);

    var bg:FlxSprite = new FlxSprite(-306, -334.65, Fkaer('trees'));
    bg.scrollFactor.x = 1.2;
    addF(bg);

    var bg2:FlxSprite = new FlxSprite(-309.95, -240.2, Fkaer('ground'));
    bg2.scrollFactor.x = 1.3;
    addF(bg2);

    var treething:FunkinSprite = new FunkinSprite(-409.95, -340.2, Fkaer('ExeAnimatedBG_Assets'));
	treething.addAnim('a', 'ExeBGAnim', 24, true);
    treething.playAnim('a');
	treething.antialiasing = Options.antialiasing;
	addSprite(treething);

    var tails:FlxSprite = new FlxSprite(700, 500, Fkaer('TailsCorpse'));
	tails.antialiasing = Options.antialiasing;
	addSprite(tails);
}

function postCreate() {
    vgblack = new FlxSprite().loadGraphic(getModImage('black_vignette'));
    vgblack.camera = camHUD;
    vgblack.alpha = 0;
    add(vgblack);

    tentas = new FlxSprite().loadGraphic(getModImage('tentacles_black'));
    tentas.camera = camHUD;
    tentas.alpha = 0;
	add(tentas);

    for (b in cpu) b.x -= 1000;
    camGame.followLerp = 0.09;
    health += 1;
}

var healthDrop:Float = 0.0000001;
// I have no idea if I recreated this fine. - Zanxt
function update() {
    var capper:Int = combo >= 40 ? 40 : combo;
    health -= healthDrop * (500 / ((capper + 1) / 8) * ((misses + 1) / 1.9));
    vgblack.alpha = 1 - (health / 2);
	tentas.alpha = 1 - (health / 2);
}

function onEvent(e) if (e.event.name == 'Camera Movement')
    defaultCamZoom = e.event.params[0] == 0 ? 0.8 : 0.9;

function onPlayerHit(e) e.healthGain = 0;
function onPlayerMiss(e) e.healthGain = 0;