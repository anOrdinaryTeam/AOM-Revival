var speaker:FunkinSprite = new FunkinSprite(-650, 600);

function create() {
    defaultCamZoom = 0.55;

    var white:FlxSprite = new FlxSprite().makeSolid(FlxG.width * 5, FlxG.height * 5, -1);
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

    var bgpillar:FunkinSprite = new FunkinSprite(-1000, -700);
    bgpillar.loadSprite(getModImage('void/Pillar_BG_Stage'));
	bgpillar.addAnim('move', 'Pillar_BG', 24, true);
	bgpillar.playAnim('move');
	bgpillar.setGraphicSize(Std.int(bgpillar.width * 1.25));
	bgpillar.antialiasing = Options.antialiasing;
	bgpillar.scrollFactor.set(0.7, 0.7);
	addSprite(bgpillar);

    speaker.loadSprite(getModImage('void/LoudSpeaker_Moving'));
	speaker.addAnim('bop', 'StereoMoving', 24, false);
	speaker.antialiasing = Options.antialiasing;
	speaker.scrollFactor.set(0.9, 0.9);
	addSprite(speaker);
}

function postCreate()
    iconP1.setIcon('Agoti/bf-alt');

function beatHit()
    speaker.playAnim('bop');

function update(dt) {
    FlxG.camera.angle = Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm/60) * -1.0) * 1.5;
	camHUD.angle = Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm/60) * 1.0) * 2.0;
    gf.y = -350 + Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 2.0) * 5.0;
}