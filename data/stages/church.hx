import flixel.addons.effects.FlxTrail;
var trail:FlxTrail;

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
}

function postCreate() {
    boyfriend.scale.set(0.8, 0.8);
	gf.scale.set(0.8, 0.8);
	dad.scale.set(0.8, 0.8);

    if (songName == 'Zavodila')
        opponentCam.y -= 20;

    trail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
    // setObjectOrder(trail, getObjectOrder(dad));
}

var goIdle:FlxTimer = new FlxTimer();

function onDadHit(e) if (songName == 'Zavodila') {
    if (getSaveData('MFM_ruvShake')) {
        FlxG.camera.shake(0.01, 0.07);
        camHUD.shake(0.01, 0.015);
    }
    
    gf.playAnim('scared');
    goIdle?.cancel();
    goIdle.start(0.6, () -> gf.dance());
}