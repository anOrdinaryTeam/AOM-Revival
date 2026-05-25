playCutscenes = true;
introLength = 0;

public var chamber:FunkinSprite;

var emeraldbeam:FunkinSprite;
var emeraldbeamYellow:FunkinSprite;
var bgA:FunkinSprite;
var bgB:FunkinSprite;

var floor:FunkinSprite;
var pebles:FunkinSprite;

var dodgeIcon:FunkinSprite;

function ChaosPath(str:String)
    return getModPath('chamber/$str');

function create() {
    defaultCamZoom = 0.7;
    forceCamPos = true;
    camHUD.alpha = 0.001;
    dad.alpha = 0.001;

    var wall:FlxSprite = new FlxSprite(-2379.05, -1211.1, ChaosPath('Wall'));
    wall.antialiasing = Options.antialiasing;
    wall.scrollFactor.set(1.1, 1.1);
    addSprite(wall);

    floor = new FunkinSprite(-2349, 921.25, ChaosPath('Floor'));
    floor.antialiasing = Options.antialiasing;
    floor.addAnim('a', 'normal');
    floor.addAnim('b', 'yellow');
	floor.playAnim('a');
    floor.scrollFactor.set(1.1, 1.1);
    addSprite(floor);

    if (!PlayState.seenCutscene) {
        bgA = new FunkinSprite(-2629.05, -1344.05, ChaosPath('BGblue'));
        bgA.antialiasing = Options.antialiasing;
        bgA.addAnim('a', 'BGblue');
        bgA.playAnim('a');
        bgA.scrollFactor.x = 1.1;
        addSprite(bgA);
    }

    bgB = new FunkinSprite(-2629.05, -1344.05, ChaosPath('BGyellow'));
    bgB.antialiasing = Options.antialiasing;
    bgB.addAnim('a', 'BGyellow');
    bgB.playAnim('a');
    bgB.scrollFactor.x = 1.1;
    bgB.alpha = PlayState.seenCutscene ? 1 : 0.001;
    addSprite(bgB);

    if (!PlayState.seenCutscene) {
        emeraldbeam = new FunkinSprite(0, -1576.95, ChaosPath('Emerald Beam'));
        emeraldbeam.antialiasing = Options.antialiasing;
        emeraldbeam.addAnim('a', 'Emerald Beam instance 1', 24, true);
        emeraldbeam.playAnim('a');
        emeraldbeam.scrollFactor.x = 1.1;
        addSprite(emeraldbeam);
    }

    emeraldbeamYellow = new FunkinSprite(-300, -1576.95, ChaosPath('Emerald Beam Charged'));
	emeraldbeamYellow.antialiasing = Options.antialiasing;
	emeraldbeamYellow.addAnim('a', 'Emerald Beam Charged instance 1', 24, true);
	emeraldbeamYellow.playAnim('a');
	emeraldbeamYellow.scrollFactor.x = 1.1;
    emeraldbeamYellow.alpha = PlayState.seenCutscene ? 1 : 0.001;
	addSprite(emeraldbeamYellow);

    var emeralds:FunkinSprite = new FunkinSprite(326.6, -191.75, ChaosPath('Emeralds'));
	emeralds.antialiasing = Options.antialiasing;
	emeralds.addAnim('a', 'TheEmeralds instance 1', 24, true);
	emeralds.playAnim('a');
	emeralds.scrollFactor.x = 1.1;
	addSprite(emeralds);

    chamber = new FunkinSprite(0, 0, ChaosPath('theChamber'));
    chamber.antialiasing = Options.antialiasing;
    chamber.addAnim('a', 'Chamber Sonic Fall', 24, false);
    chamber.scrollFactor.x = 1.1;
    setObjectOrder(chamber, getObjectOrder(dad) + 1);

    pebles = new FunkinSprite(-462.15, 1043.3, ChaosPath('pebles'));
    pebles.antialiasing = Options.antialiasing;
    pebles.addAnim('a', 'pebles instance 1');
    pebles.addAnim('b', 'pebles instance 2');
	pebles.playAnim('a');
    pebles.scrollFactor.set(1.1, 1.1);
    add(pebles);

    var porker:FunkinSprite = new FunkinSprite(2880.15 + 200, -762.8, ChaosPath('porker'));
	porker.antialiasing = Options.antialiasing;
	porker.addAnim('porkerbop', 'Porker FG', 24, true);
    porker.playAnim('porkerbop');
	porker.scrollFactor.x = 1.4;
    add(porker);
}

function postCreate() {
    camGame.followLerp = 0.06;
    PlayState.instance.comboGroup.x += 200;

    dodgeIcon = new FunkinSprite().loadSprite(ChaosPath('spacebar_icon'));
    dodgeIcon.antialiasing = Options.antialiasing;
    dodgeIcon.camera = camHUD;
    dodgeIcon.scale.set(0.5, 0.5);
    dodgeIcon.addAnim('a', 'space', 24, false);
    dodgeIcon.playAnim('a');
    dodgeIcon.alpha = 0.001;
    dodgeIcon.screenCenter();
    dodgeIcon.x -= 60;
    add(dodgeIcon);

    precacheCharacter(1, 'EXE/bf-super');
    for (cache in ['anims1', 'anims2', 'anims3'])
        precacheCharacter(0, 'EXE/fleetway-$cache');
}

function onSongStart() {
    camFollow.setPosition(900, 700);
    camGame.snapToTarget();

    playModSound('beam');

    FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.2, {ease: FlxEase.cubeOut});
    FlxG.camera.shake(0.02, 0.2);
	FlxG.camera.flash(FlxColor.WHITE, 0.2);

    floor.playAnim('b');
    pebles.playAnim('b');
    chamber.playAnim('a', true, 'NONE', false, chamber.frames.frames.length);

    bgB.alpha = 1;
    emeraldbeamYellow.alpha = 1;

    if (!PlayState.seenCutscene) {
        remove(bgA, false);
        remove(emeraldbeam, false);
    }
}

var canDodge:Bool = false;
var dodging:Bool = false;
var canFly:Bool = true;
var floaty:Float = 0;

function dodgeEvent() {
    var stepEvent:Int = 0;
    canDodge = true;

    dodgeIcon.alpha = 1;
    dodgeIcon.playAnim('a', true);

    new FlxTimer().start(0, (tmr) -> {
        stepEvent++;

        if (stepEvent < 4)
            tmr.reset(0.32);

        if (stepEvent == 3) {
            canFly = false;
            changeCharacter(0, 'EXE/fleetway-anims3');
            dad.playAnim('laser', true);
            dad.animation.finishCallback = (Anim) -> {
                if (Anim == 'laser') {
                    canFly = true;
                    changeCharacter(0, 'EXE/fleetway');
                }
            }
        }
        else if (stepEvent == 4)
            remove(dodgeIcon, true);
    });
}

function stepHit() switch(curStep) {
    case 399, 528, 656, 784, 1040, 1168, 1296, 1552, 1680, 1808, 1952:
        changeCharacter(0, 'EXE/fleetway');

    case 383, 512, 640, 776, 1036, 1152:
        changeCharacter(0, 'EXE/fleetway-anims1');
        dad.playAnim(switch(curStep) {
            case 383: 'a';
            case 512: 'b';
            case 640: 'c';
            case 776: 'd';
            case 1036: 'e';
            case 1152: 'f';
        }, true, 'LOCK');

    case 1261, 1543, 1672, 1792, 1936:
        changeCharacter(0, 'EXE/fleetway-anims2');
        dad.playAnim(switch(curStep) {
            case 1261: 'a';
            case 1543: 'b';
            case 1672: 'c';
            case 1792: 'd';
            case 1936: 'e';
        }, true, 'LOCK');

    case 9:
        dad.alpha = 1;
        FlxTween.tween(dad, {y: dad.y - 500}, 0.5, {ease: FlxEase.cubeOut});
        FlxTween.tween(camFollow, {y: camFollow.y - 400}, 0.5, {ease: FlxEase.cubeOut});
    case 15:
        dad.playAnim('fastanim', true, "LOCK");
        FlxTween.tween(dad, {x: 61.15, y: -94.75}, 2, {ease: FlxEase.cubeOut});
        FlxTween.tween(camFollow, {x: camFollow.x - 400}, 2, {ease: FlxEase.cubeOut});
    case 64:
        opponentCam.set(camFollow.x, camFollow.y);
        forceCamPos = false;
        FlxTween.tween(camHUD, {alpha: 1}, 0.2, {ease: FlxEase.cubeOut});
    case 256:
        dodgeEvent();
    case 1008:
        playModSound('SUPERBF');
        changeCharacter(1, 'EXE/bf-super');

        FlxG.camera.shake(0.02, 0.2);
		FlxG.camera.flash(FlxColor.YELLOW, 0.2);
}

function update() {
    floaty += 0.03;

    if (FlxG.keys.justPressed.SPACE && canDodge) {
        dodging = true;
        boyfriend.playAnim('dodge', true, 'LOCK');
        boyfriend.animation.finishCallback = (Anim) -> {
            if (Anim == 'dodge') {
                dodging = false;
                canDodge = false;
                boyfriend.dance();
            }
        }
    }

    // might be more large than the og code but its more safety
    if (dad.curCharacter == 'EXE/fleetway-anims3') {
        var curAnim:String = dad.animation.curAnim.name;
        var curFrame:Int = dad.animation.curAnim.curFrame;

        if ((curAnim == 'laser' && curFrame == 15) && !dodging)
            health -= 999;
    }

    if (!forceCamPos && canFly) {
        dad.y += Math.sin(floaty) * 1.3;
        opponentCam.y += Math.sin(floaty) * 1.3;
    }
}