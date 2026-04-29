var bgRocks:FlxSprite;

function create() {
    defaultCamZoom = 0.6;

    var white:FlxSprite = new FlxSprite().makeSolid(FlxG.width * 5, FlxG.height * 5, FlxColor.WHITE);
    white.screenCenter();
    white.scrollFactor.set();
    addSprite(white);

    var void:FunkinSprite = new FunkinSprite(0, 0);
    void.loadSprite(getModImage('void/The_void'));
    void.addAnim('move', 'VoidShift', 50, true);
    void.playAnim('move');
    void.setGraphicSize(Std.int(void.width * 2.5));
    void.screenCenter();
    void.x += 55; void.y += 250;
    void.antialiasing = Options.antialiasing;
    void.scrollFactor.set(0.7, 0.7);
    addSprite(void);

    bgRocks = new FlxSprite(-1000, -700, getModImage('void/Void_Back'));
    bgRocks.setGraphicSize(Std.int(bgRocks.width * 0.5));
    bgRocks.antialiasing = Options.antialiasing;
    bgRocks.scrollFactor.set(0.7, 0.7);
    addSprite(bgRocks);

    var frontRocks:FlxSprite = new FlxSprite(-1000, -600, getModImage('void/Void_Front'));
    frontRocks.updateHitbox();
    frontRocks.antialiasing = Options.antialiasing;
    frontRocks.scrollFactor.set(0.9, 0.9);
    addSprite(frontRocks);
}

function postCreate()
    iconP1.setIcon('Agoti/bf-alt');

function update(_) {
    gf.y = -120 + Math.sin((Conductor.songPosition / 1000)*(Conductor.bpm/60) * 2.0) * 5.0;
    bgRocks.y = -700 + Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 2.0) * 0.8;
}