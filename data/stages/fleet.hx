var statSfx:FlxSound;
var bgs:Array<FlxSprite> = [];

function create() {
    defaultCamZoom = 0.92;
    useCamMov = true;
    camMoveAmt = 30;
    statSfx = FlxG.sound.load(Paths.getPath('Assets-RandomSongs/sounds/stat.ogg'));

    for (str in ['alt', 'normal']) {
        var bg:FlxSprite = new FlxSprite().loadGraphic(getModImage('Phantasm/$str'));
        bg.antialiasing = Options.antialiasing;
        addSprite(bg);
        bgs.push(bg);
    }

    var staticc:FunkinSprite = new FunkinSprite();
    staticc.addAnim('idle', 'idle', 16, true);
    staticc.camera = camHUD;
    staticc.alpha = 0.001;
    staticc.scale.set(3, 3);
    staticc.updateHitbox();
    insert(1, staticc);
}

function postCreate() {
    loadHud('PsychEngine');
    for (w in cpu) w.visible = false;
}

function stepHit() switch(curStep) {
    // fleet phase
    case 384, 768, 1151, 1172, 1276, 1282, 1304, 1536, 1922, 1937, 1943, 1956:

    // sonic phase
    case 640, 1024, 1154, 1176, 1279, 1300, 1408, 1792, 1926, 1940, 1946, 1960:
}

function fleetwaySwitch() {
    //doTweenAlpha('fleetON', 'fx', 0, 1, 'linear')
	//playSound('stat', 0.3)
}