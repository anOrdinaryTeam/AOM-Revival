var statSfx:FlxSound;
var bgs:Array<FlxSprite> = [];
var staticc:FunkinSprite = new FunkinSprite();

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

    staticc.loadSprite(getModImage('Phantasm/vintage'));
    staticc.addAnim('idle', 'idle', 16, true);
    staticc.camera = camHUD;
    staticc.alpha = 0.001;
    staticc.scale.set(3, 3);
    staticc.updateHitbox();
    insert(1, staticc);
}

function postCreate() {
    precacheCharacter(1, 'fleetway');
    loadHud('PsychEngine');
    for (w in cpu) w.visible = false;
}

function stepHit() switch(curStep) {
    // fleet phase
    case 384, 768, 1151, 1172, 1276, 1282, 1304, 1536, 1922, 1937, 1943, 1956:
        fleetwaySwitch(true);

    // sonic phase
    case 640, 1024, 1154, 1176, 1279, 1300, 1408, 1792, 1926, 1940, 1946, 1960:
        fleetwaySwitch(false);
}

function fleetwaySwitch(bool:Bool) {
    staticc.playAnim('idle', true);
    staticc.alpha = 1;
    FlxTween.cancelTweensOf(staticc);
    FlxTween.tween(staticc, {alpha: 0}, 1);

    bgs[1].alpha = bool ? 0 : 1;
    playModSound('stat', 0.3);
    changeCharacter(1, bool ? 'fleetway' : 'sonic');
}