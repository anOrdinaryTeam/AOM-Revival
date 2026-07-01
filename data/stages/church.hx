function create() {
    var suffix:String = switch(songName) {
        default: '1';
        case 'Worship': '2';
        case 'Zavodila': '3';
    }
    defaultCamZoom = 0.9;

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
}

function postCreate() {
    boyfriend.scale.set(0.8, 0.8);
	gf.scale.set(0.8, 0.8);
	dad.scale.set(0.8, 0.8);
}

var goIdle:FlxTimer = new FlxTimer();

function onDadHit(e) if (songName == 'Zavodila') {
    FlxG.camera.shake(0.01, 0.05);
	camHUD.shake(0.01, 0.015);
    gf.playAnim('scared');

    goIdle?.cancel();
    goIdle.start(0.6, () -> gf.dance());
}