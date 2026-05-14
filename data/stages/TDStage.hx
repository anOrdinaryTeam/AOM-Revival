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
    precacheCharacter(0, 'EXE/TDoll-alt');

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
var typeFly:String = '';

function update() {
    floaty += 0.03;

    if (typeFly == 'hovering' || typeFly == 'circling') {
        dad.y += Math.sin(floaty) * 1.3;
        opponentCam.y += Math.sin(floaty) * 1.3;
    }

    if (typeFly == 'circling') {
        dad.x += Math.cos(floaty) * 1.3;
        opponentCam.x += Math.cos(floaty) * 1.3;
    }
}

var ogX:Float = 0;
var ogXcpu:Float = 0;

function stepHit() switch(curStep) {
    case 64: typeFly = 'hovering';
    case 128, 319, 866: typeFly = 'circling';

    case 256, 575: FlxTween.tween(dad, {x: -150, y: 330}, 0.2, {onComplete: () -> {
		dad.setPosition(-150, 330);
		typeFly = 'hovering';
		floaty = 41.82;
	}});

    case 588:
        bg.visible = 0.001;
        boyfriend.alpha = 0.001;
        changeCharacter(0, 'EXE/TDoll-alt');

        ogX = player.members[0].x;
        ogXcpu = cpu.members[0].x;

        for (otherHide in [iconP1, iconP2, healthBar, healthBarBG])
            otherHide.alpha = 0;

        for (hide in hudItems)
            hide.alpha = 0;

        for (hideCpu in cpu)
            hideCpu.x -= 1000;

        for (i => note in player.members) {
            note.alpha = 0;
            note.x = 435 + 115 * i;
        }
    case 593: camGame.snapToTarget();
    case 860:
        bg.visible = 1;
        boyfriend.alpha = 1;
        changeCharacter(0, 'EXE/TDoll');

        for (otherHide in [iconP1, iconP2, healthBar, healthBarBG])
            otherHide.alpha = 1;

        for (hide in hudItems)
            hide.alpha = 1;

        for (i => hiCpu in cpu.members)
            hiCpu.x = ogXcpu + 115 * i;

        for (i => note in player.members) {
            note.alpha = 1;
            note.x = ogX + 115 * i;
        }
    case 1120:
        FlxTween.tween(dad, {x: -150, y: 330}, 0.2, {onComplete: () -> {
            dad.setPosition(-150, 330);
            typeFly = '';
        }});
}

function onDadHit(e) if (!e.note.isSustainNote && curStep > 588 && curStep < 860) {
    player.forEachAlive(note -> alphaShit(note));
    player.notes.forEachAlive(note -> alphaShit(note));
}   

function alphaShit(obj:Dynamic) if (obj != null) {
    obj.alpha = 0.7;

    if (obj.alpha != 0) new FlxTimer().start(0.01, (tmr) -> {
        obj.alpha -= 0.03;
        if (obj.alpha != 0) tmr.reset();
    });
}