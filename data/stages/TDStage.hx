var bg:FlxSprite;
var introSpr:FunkinSprite = new FunkinSprite();
var countdownGrp:Array<FlxSprite> = [];

function create() {
    defaultCamZoom = 0.9;

    bg = new FlxSprite().loadGraphic(getModImage('TailsBG'));
	bg.setGraphicSize(Std.int(bg.width * 1.2));
	bg.antialiasing = Options.antialiasing;
	bg.scrollFactor.set(.91, .91);
	bg.x -= 370; bg.y -= 130;
	bg.active = false;
	addSprite(bg);

    introSpr.loadSprite(getModImage('TD-Intro/start'));
    introSpr.addAnim('idle', 'Start', 24, false);
    introSpr.antialiasing = Options.antialiasing;
    introSpr.camera = camHUD;
    introSpr.screenCenter();
    add(introSpr);

    for (str in ['ready', 'set', 'go']) {
        var sc:Float = str == 'go' ? 0.7 : 0.5;
        var spr:FlxSprite = new FlxSprite().loadGraphic(getModImage('TD-Intro/$str'));
        spr.antialiasing = Options.antialiasing;
        spr.camera = camHUD;
        spr.scale.set(sc, sc);
        spr.screenCenter();
        spr.alpha = 0.001;
        add(spr);
        countdownGrp.push(spr);
    }
}

function postCreate() {
    var stat:FunkinSprite = new FunkinSprite().loadSprite(getModImage('daSTAT'));
    stat.addAnim('idle', 'staticFLASH', 24, true);
    stat.playAnim('idle');
    stat.camera = camHUD;
    stat.alpha = 0.05;
    stat.antialiasing = Options.antialiasing;
    stat.setGraphicSize(FlxG.width, FlxG.height);
    stat.screenCenter();
    add(stat);

    if (Options.gameplayShaders) {
        var filter:CustomShader = new CustomShader('vcrDistortion');
        camGame.addShader(filter);
        camHUD.addShader(filter);
    }
}

var go:Bool = false;
function onStartCountdown(e) if (!go) {
    e.cancel();
    go = true;

    var curCountdown:Int = 0;
    introSpr.playAnim('idle', true);
    introSpr.animation.finishCallback = () -> new FlxTimer().start(Conductor.crochet / 3000, (tmr) -> { 
        if (curCountdown != 3) {
            var spr:FlxSprite = countdownGrp[curCountdown];
            var sc:Float = curCountdown == 2 ? 0.9 : 1.1;

            spr.alpha = 1;
            playModSound(['ready', 'set', 'go'][curCountdown]);
            FlxTween.tween(spr.scale, {x: sc, y: sc}, Conductor.crochet / 500, {onComplete: () -> remove(spr)});
            new FlxTimer().start(0.7, () -> spr.alpha = 0.001);

            curCountdown++;
            if (curCountdown <= 3) tmr.reset(Conductor.crochet / 700);
        }
        else
            startCountdown();
    });
}

var floaty:Float = 0;
var flyX:Bool = false;
var flyY:Bool = false;

function update() {
    floaty += 0.03;

    if (flyX) {
        dad.x += Math.cos(floaty) * 1.3;
        opponentCam.x += Math.cos(floaty) * 1.3;
    }

    if (flyY) {
        dad.y += Math.sin(floaty) * 1.3;
        opponentCam.y += Math.sin(floaty) * 1.3;
    }
}

function stepHit() switch(curStep) {
    case 64: flyY = true;
    case 128: flyX = true;
}

// cuz botplay
// function onDadHit(e) if (e.character.curCharacter == 'EXE/TDoll' && (curStep > 588 && curStep < 860) && !e.note.isSustainNote) {
//     for (p in player) alphaShit(p);
//     for (p in player.notes) alphaShit(p);
// }

function alphaShit(obj:Dynamic) if (obj != null) {
    obj.alpha = 0.7;

    if (obj.alpha != 0) new FlxTimer().start(0.01, (tmr) -> {
        obj.alpha -= 0.03;
        if (obj.alpha != 0) tmr.reset();
    });
}