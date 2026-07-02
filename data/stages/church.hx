import flixel.addons.effects.FlxTrail;

var bgFade:FlxSprite;
var circSelever:FlxSprite;
var trail:FlxTrail;

var trailShows:Map<String, Dynamic> = [];
var goIdle:FlxTimer = new FlxTimer();

function create() {
    defaultCamZoom = 0.9;
    var suffix:String = switch(songName) {
        default: '1';
        case 'Worship': '2';
        case 'Zavodila': '3';
        case 'Casanova': '-s';
    }

    var bg:FlxSprite = new FlxSprite(-240, -630, getModImage('church$suffix/bg'));
	bg.antialiasing = Options.antialiasing;
	addSprite(bg);
	
	var pillars:FlxSprite = new FlxSprite(-240, -630, getModImage('church$suffix/pillars'));
	pillars.antialiasing = Options.antialiasing;
	addSprite(pillars);
	
	var floor:FlxSprite = new FlxSprite(-240, -630, getModImage('church$suffix/floor'));
	floor.antialiasing = Options.antialiasing;
	addSprite(floor);

    if (songName == 'Zavodila') {
        var brokePillar:FlxSprite = new FlxSprite(-240, -630, getModImage('church3/pillarbroke'));
	    brokePillar.antialiasing = Options.antialiasing;
	    setObjectOrder(brokePillar, getObjectOrder(gf) + 1);
    }
    else if (songName == 'Casanova') {
        circSelever = new FlxSprite(-90, 100, getModImage('church-s/circ'));
        circSelever.antialiasing = Options.antialiasing;
        circSelever.scale.set(0.01, 0.01);
        FlxTween.angle(circSelever, 0, 360, 3, {type: 2});
        setObjectOrder(circSelever, getObjectOrder(dad));
    }

    bgFade = new FlxSprite(bg.x, bg.y).makeSolid(bg.width, bg.height, FlxColor.BLACK);
    bgFade.alpha = 0.01;
    setObjectOrder(bgFade, getObjectOrder(gf) + 1);
}

function postCreate() {
    boyfriend.scale.set(0.8, 0.8);
	gf.scale.set(0.8, 0.8);
	dad.scale.set(0.8, 0.8);

    if (songName == 'Zavodila')
        opponentCam.y -= 20;

    trail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
    trail.color = dad.iconColor;
    setObjectOrder(trail, getObjectOrder(dad));
    trail.visible = false;

    trailShows.set("Parish", [387, 451]);
    trailShows.set("Worship", [515, 543, 643, 672]);
    trailShows.set("Zavodila", [131, 195, 655, 685, 1047, 1111]);
    trailShows.set("Casanova", [288, 352, 448, 512, 576, 768, 896, 1024, 1088, 1152, 1216]);
}

function onDadHit(e) if (songName == 'Zavodila') {
    if (getSaveData('MFM_ruvShake')) {
        FlxG.camera.shake(0.01, 0.07);
        camHUD.shake(0.01, 0.015);
    }
    
    gf.playAnim('scared');
    goIdle?.cancel();
    goIdle.start(0.6, () -> gf.dance());
}

function stepHit() if (trailShows.get(songName).contains(curStep))
    showTrail();

function onCountdown(e) if (songName == 'Casanova' && e.swagCounter == 3) {
    dad.playAnim('Intro', true);
    SeleverThing(true);
}

public function SeleverThing(_isIntro:Bool) {
    var isIntro:Bool = _isIntro;
    circSelever.alpha = 1;
    circSelever.scale.set(0.1, 0.1);

    FlxTween.tween(circSelever.scale, {x: 0.8, y: 0.8}, 0.4, {ease: FlxEase.quintInOut});
    FlxTween.tween(bgFade, {alpha: 0.6}, 0.3, {ease: FlxEase.sineInOut});

    if (isIntro) {
        FlxTween.tween(FlxG.camera, {zoom: 1.2}, 0.4);
        dad.playAnim('Intro', true);
    }
    
    new FlxTimer().start(0.8, () -> {
        FlxTween.tween(bgFade, {alpha: 0}, 0.4, {ease: FlxEase.sineInOut});
        FlxTween.tween(circSelever, {alpha: 0}, 2, {ease: FlxEase.sineInOut});

        if (isIntro)
            FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.4, {ease: FlxEase.sineInOut});
    });
}

function showTrail() {
    trail.visible = true;
    new FlxTimer().start(3.50, () -> trail.visible = false);
}