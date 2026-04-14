var in:Int = 0;

static function addSprite(spr:Dynamic) if (spr != null) {
    spr.antialiasing = Options.antialiasing;
    insert(in++, spr);
}

function create() {
    usePsychSplashes = true;
    useCamMov = true;
    camMoveAmt = 14;
    defaultCamZoom = 0.63 + 0.36;
    comboGroup.visible = false;

    for (i in 0...3) {
        var spr:String = ['sinkdepths', 'sinkfloor', 'sinkceiling'][i];
        var sprites:FlxSprite = new FlxSprite([-50, -50, -70][i], [-80, 0, -50][i], getModImage('Sink/$spr'));
        sprites.scale.set(1.11, 1.1);
        sprites.updateHitbox();
        addSprite(sprites);
        if (i == 3) sprites.scrollFactor.set(0.9, 0.9);
    }
}

var waves:FunkinSprite;

function postCreate() {
    loadHud('PsychEngine');
    dad.alpha = .001;
    iconP2.visible = false;

    waves = new FunkinSprite().loadSprite(getModImage('Sink/waves'));
    waves.addAnim('idle', 'idle', 13, true);
    waves.playAnim('idle');
    waves.scale.set(1280/512, 820/512);
    waves.updateHitbox();
    waves.alpha = 0.06;
    waves.blend = "subtract";
    waves.camera = camHUD;
    insert(1, waves);
    FlxTween.tween(waves, {alpha: 0.12}, 0.8, {type: 4});

    var vignette:FlxSprite = new FlxSprite(0,0, getModImage('Sink/vignette'));
    vignette.camera = camHUD;
    insert(2, vignette);
}

var dead:Bool = false;

function beatHit() {
    if (!dead && curBeat % 4 == 0 && curStep > 526 && curStep < 641) {
        FlxTween.tween(camGame, {zoom: camGame.zoom - (camGame.zoom - 0.63) / 8}, 8.8, {onComplete: function() {
            defaultCamZoom = camGame.zoom -= 0.36 / 8;
        }});
    }
}

var first:Bool = true;
var dos:Bool = true;

function onDadHit(_) {
    if (first) {
        first = !first;
        dad.alpha = 0.45;
        FlxTween.tween(dad, {alpha: 0}, 0.6);
    }
    else if (!first && dos) {
        dos = !dos;
        FlxTween.tween(dad, {alpha: 0.1}, 0.6, {type: 4});
    }
}

function onPlayerHit(e) e.healthGain = 0;
function onPlayerMiss(e) e.healthGain = 0;