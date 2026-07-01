function create() {
    defaultCamZoom = 0.9;

    var bg:FlxSprite = new FlxSprite(-240, -630, getModImage('devil/bg'));
    bg.antialiasing = Options.antialiasing;
    addSprite(bg);

    var floor:FlxSprite = new FlxSprite(-240, -630, getModImage('devil/floor'));
    floor.antialiasing = Options.antialiasing;
    addSprite(floor);

    var pillars:FlxSprite = new FlxSprite(-240, -630, getModImage('devil/pillars'));
    pillars.antialiasing = Options.antialiasing;
    addSprite(pillars);

    var devilbg_0:FlxSprite = new FlxSprite(-240, -630, getModImage('devil/circ0'));
    devilbg_0.antialiasing = Options.antialiasing;
    addSprite(devilbg_0);

    var devilbg_1:FlxSprite = new FlxSprite(420, -310, getModImage('devil/sprite'));
    devilbg_1.antialiasing = Options.antialiasing;
    addSprite(devilbg_1);
    FlxTween.angle(devilbg_1, 0, 360, 2, {type: 2});

    var devilbg_2:FlxSprite = new FlxSprite(-240, -630, getModImage('devil/circ2'));
    devilbg_2.antialiasing = Options.antialiasing;
    addSprite(devilbg_2);
}

function postCreate() {
    boyfriend.scale.set(0.8, 0.8);
	gf.scale.set(0.8, 0.8);
	dad.scale.set(0.8, 0.8);

    var amt:Int = 100;
    var tmr:Float = 2;
    FlxTween.tween(dad, {x: dad.x + amt}, tmr + 0.4, {type: 4, ease: FlxEase.sineInOut});
    FlxTween.tween(dad, {y: dad.y + amt + 50}, tmr, {type: 4, ease: FlxEase.sineInOut});

    FlxTween.tween(opponentCam, {x: opponentCam.x + amt}, tmr + 0.4, {type: 4, ease: FlxEase.sineInOut});
    FlxTween.tween(opponentCam, {y: opponentCam.y + amt}, tmr, {type: 4, ease: FlxEase.sineInOut});
}