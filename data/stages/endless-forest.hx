var pillars1:FunkinSprite;
var pillars2:FunkinSprite;

function loadStageSpr(str:String)
    return getModImage('endless-forest/$str');

function create() {
    defaultCamZoom = 0.9;
    camMoveAmt = 15;
    camFollow.setPosition(800, 500);

    var SKY:FlxSprite = new FlxSprite(-600, -200, loadStageSpr('sonicFUNsky'));
    SKY.setGraphicSize(Std.int(SKY.width * 0.9));
    SKY.antialiasing = Options.antialiasing;
    SKY.scrollFactor.set(0.3, 0.3);
    addSprite(SKY);

    var bush:FlxSprite = new FlxSprite(-42, 171, loadStageSpr('Bush 1'));
    bush.antialiasing = Options.antialiasing;
    bush.scrollFactor.set(0.3, 0.3);
    addSprite(bush);

    pillars2 = new FunkinSprite(182, -100, loadStageSpr('Majin Boppers Back'));
    pillars2.antialiasing = Options.antialiasing;
    pillars2.addAnim('idle', 'MajinBop2 instance 1', 24, false);
    pillars2.playAnim('idle');
    pillars2.scrollFactor.set(0.6, 0.6);
    addSprite(pillars2);

    var bush2:FlxSprite = new FlxSprite(132, 354, loadStageSpr('Bush2'));
    bush2.antialiasing = Options.antialiasing;
    bush2.scrollFactor.set(0.3, 0.3);
    addSprite(bush2);

    pillars1 = new FunkinSprite(-169, -167, loadStageSpr('Majin Boppers Front'));
    pillars1.antialiasing = Options.antialiasing;
    pillars1.addAnim('idle', 'MajinBop1 instance 1', 24, false);
    pillars1.playAnim('idle');
    pillars1.scrollFactor.set(0.6, 0.6);
    addSprite(pillars1);

    var floor:FlxSprite = new FlxSprite(-340, 660, loadStageSpr('floor BG'));
    floor.antialiasing = Options.antialiasing;
    floor.scrollFactor.set(0.5, 0.5);
    addSprite(floor);
}

var fgmajin:FunkinSprite;
var fgmaji2:FunkinSprite;

function postCreate() {
    fgmajin = new FunkinSprite(1126, 903, loadStageSpr('majin FG1'));
    fgmajin.addAnim('idle', 'majin front bopper1', 24, false);
    fgmajin.playAnim('idle');
    fgmajin.scrollFactor.set(0.8, 0.8);
    add(fgmajin);

    fgmajin2 = new FunkinSprite(-293, 871, loadStageSpr('majin FG2'));
    fgmajin2.addAnim('idle', 'majin front bopper2', 24, false);
    fgmajin2.playAnim('idle');
    fgmajin2.scrollFactor.set(0.8, 0.8);
    add(fgmajin2);

    graphicCache.cache(loadStageSpr('go'));
    graphicCache.cache(loadStageSpr('one'));
    graphicCache.cache(loadStageSpr('two'));
    graphicCache.cache(loadStageSpr('three'));
    graphicCache.cache(Paths.image('modNotes/EXE/Majin_Notes'));
}

function onNoteCreation(e) {
    e.note.strumRelativePos = false;
    e.note.noteAngle = 0.001;
}

function beatHit() if (curBeat % 1 == 0) {
    pillars1.playAnim('idle', true);
    pillars2.playAnim('idle', true);

    fgmajin.playAnim('idle', true);
    fgmajin2.playAnim('idle', true);
}

var spinSteps:Array<Int> = [272, 276, 336, 340, 400, 404, 464, 468, 528, 532, 
    592, 596, 656, 660, 720, 724, 784, 788, 848, 852, 912, 916, 976, 980, 
    1040, 1044, 1104, 1108, 1424, 1428, 1488, 1492, 1552, 1556, 1616, 1620
];

var e:Int = 0;
function FunCountdown() {
    var shit:FlxSprite = new FlxSprite().loadGraphic(loadStageSpr(['three', 'two', 'one', 'go'][e]));
    shit.scrollFactor.set();
    shit.screenCenter();
	shit.alpha = 0.5;
    shit.y -= 100;
    add(shit);

    e++;
    FlxTween.tween(shit, {alpha: 0, y: shit.y + 100}, Conductor.crochet / 1000, {ease: FlxEase.cubeOut, onComplete: () -> {
        remove(shit, true);
    }});

}

function CountdownZoom() {
    var curZoom:Float = FlxG.camera.zoom;
    var newZoom:Float = curZoom + 0.3;
    FlxTween.tween(FlxG.camera, {zoom: newZoom}, 0.7, {ease: FlxEase.cubeInOut, onComplete: (t) -> defaultCamZoom = newZoom});
}

function stepHit() {
    if (spinSteps.contains(curStep)) for (str in strumLines) for (i in 0...4) {
        var strum = str.members[i];
        FlxTween.angle(strum, 0, 360, 0.2, {ease: FlxEase.quintOut});
    }

    switch(curStep) {
        case 888:
            FlxTween.tween(camHUD, {alpha: 0}, 0.7, {ease: FlxEase.cubeInOut});
            setCamPos(690, 820);
            CountdownZoom();
            FunCountdown();
        case 891, 896:
            CountdownZoom();
            FunCountdown();
        case 899:
            FunCountdown();
            changeNoteSkin('modNotes/EXE/Majin_Notes', player, 'both', false);
            changeNoteSkin('modNotes/EXE/Majin_Notes', cpu, 'both', false);

            forceCamPos = false;
            FlxTween.tween(camHUD, {alpha: 1}, 0.7, {ease: FlxEase.cubeInOut});
            FlxTween.tween(FlxG.camera, {zoom: 0.9}, 0.7, {ease: FlxEase.cubeInOut, onComplete: () -> defaultCamZoom = 0.9});
    }
}