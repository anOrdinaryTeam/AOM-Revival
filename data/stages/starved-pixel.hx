import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxStringUtil;

function loadStageSpr(str:String) return getModImage('Prey/$str');
introLength = 0;

var camOther:FlxCamera = new FlxCamera();
var cinematicBarsGrp:FlxTypedGroup<Dynamic> = new FlxTypedGroup();
var lyricTimer:FlxTimer = new FlxTimer();

var sonicHUD:FlxTypedGroup<Dynamic> = new FlxTypedGroup();
var stardustBgPixel:FlxBackdrop;
var stardustFloorPixel:FlxBackdrop;
defaultCamZoom = 0.6;

function setSpeed(i:Int) {
    stardustBgPixel.velocity.x = -i * 100;
    stardustFloorPixel.velocity.x = (-i - 30) * 100;
}

function create() {
    stardustBgPixel = new FlxBackdrop(loadStageSpr('stardustBg'), FlxAxes.X);
    stardustBgPixel.scrollFactor.set(0.4, 0.4);
    stardustBgPixel.antialiasing = false;
    addSprite(stardustBgPixel);

    stardustFloorPixel = new FlxBackdrop(loadStageSpr('stardustFloor'), FlxAxes.X);
    stardustFloorPixel.antialiasing = false;
    add(stardustFloorPixel);

    stardustBgPixel.screenCenter();
	stardustFloorPixel.screenCenter();
    stardustBgPixel.visible = false;
    stardustFloorPixel.visible = false;
    setSpeed(6);

    camOther.bgColor = 0;
    FlxG.cameras.add(camOther, false);

    cinematicBarsGrp.camera = camOther;
    add(cinematicBarsGrp);
    for (i in 0...2) {
        var bars:FlxSprite = new FlxSprite(0, [-170, 720][i]).makeSolid(FlxG.width, 170, FlxColor.BLACK);
        cinematicBarsGrp.add(bars);
    }

    var lyricText:FlxText = new FlxText(0, 0, FlxG.width, '');
    lyricText.setFormat(Paths.font("PressStart2P.ttf"), 24, -1, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    lyricText.alpha = 0;
    lyricText.screenCenter();
    lyricText.y += 250;
    cinematicBarsGrp.add(lyricText);

    useCamMov = true;
    camMoveAmt = 14;
}

function postCreate() {
    camHUD.alpha = 0;
    precacheCharacter(0, 'starved-pixel');
    precacheCharacter(1, 'bf-Sonic-Peelout');

    if (getSaveData('allowCustomHud')) {
        for (i in [scoreTxt, accuracyTxt, missesTxt]) i.visible = false;
        healthBar.x += 150;
        healthBarBG.x += 150;
        sonicHUD.camera = camHUD;
        insert(members.indexOf(iconP2) + 1, sonicHUD);

        for (i in 0...6) {
            var text:FlxText = new FlxText(20, 540 + (50 * i), FlxG.width, '', 45);
            text.font = Paths.font('Sonic1.ttf');
            text.borderStyle = FlxTextBorderStyle.OUTLINE;
            text.borderSize = 1.9;
            text.borderColor = FlxColor.BLACK;
            sonicHUD.add(text);

            switch(i) {
                case 0,1,2: text.color = FlxColor.YELLOW;
                case 3,4,5:
                    text.color = FlxColor.WHITE;
                    text.alignment = 'right';
            }
            switch(i) {
                case 0: text.text = 'SCORE';
                case 1: text.text = 'TIME';
                case 2: text.text = 'MISSES';
                case 3,4,5: text.text = '0';
            }
        }

        var xScreen:Float = -FlxG.width;
        sonicHUD.members[3].setPosition(xScreen + 290, sonicHUD.members[0].y);
        sonicHUD.members[4].setPosition(xScreen + 250, sonicHUD.members[1].y);
        sonicHUD.members[5].setPosition(xScreen + 260, sonicHUD.members[2].y);
    }
}

function onRatingUpdate(_) if (sonicHUD != null) {
    sonicHUD.members[3].text = songScore;
    sonicHUD.members[5].text = misses;
}

function update(_) if (sonicHUD != null) {
    var songCalc:Float = Conductor.songPosition;
    var secondsTotal:Int = Math.floor(songCalc / 1000);
	if(secondsTotal < 0) secondsTotal = 0;

    sonicHUD.members[4].text = FlxStringUtil.formatTime(secondsTotal, false);
}

function onStrumCreation(event) {
    if (e.player == 1 && usingSkins) return;    
    event.cancel();

    var strum = event.strum;
    strum.loadGraphic(Paths.image('modNotes/Prey/prey-pixels'), true, 17, 17);
    strum.animation.add("static", [event.strumID]);
    strum.animation.add("pressed", [4 + event.strumID, 8 + event.strumID], 12, false);
    strum.animation.add("confirm", [12 + event.strumID, 16 + event.strumID], 24, false);
    strum.scale.set(6, 6);
    strum.updateHitbox();
}

function onNoteCreation(event) {
    if (e.strumLineID == 1 && usingSkins) return; 
    event.cancel();

    var note = event.note;
    if (note.isSustainNote) {
        note.loadGraphic(Paths.image('modNotes/Prey/preyEnds'), true, 7, 6);
        note.animation.add("hold", [event.strumID]);
        note.animation.add("holdend", [4 + event.strumID]);
    } else {
        note.loadGraphic(Paths.image('modNotes/Prey/prey-pixels'), true, 17, 17);
        note.animation.add("scroll", [4 + event.strumID]);
    }
    note.scale.set(6, 6);
    note.updateHitbox();
	note.splash = 'blood';
}

var lyricInt:Int = 0;
var lyrics:Array<Dynamic> = [
    ['Seems that bucket of bolts had to lay off the nitro this time around!', 3, '-1'],
    ['Hey Red Head!', 0, '-1'],
    ['Might wanna repair your toys!', 1.1, '-1'],
    ["You don't even know your fate, hedgehog...", 3.7, 'RED'],
    ['*Maniacal kackling*', 8.9, 'RED'],
    ["Man, you really like scrambling your own plans don't'cha-", 3, '-1']
];

function stepHit()
    switch(curStep) {
        case 1: FlxG.camera.fade(FlxColor.BLACK, 6, true); //FlxTween.tween(boyfriend, {alpha: 1}, 6);
        case 128:
            camZooming = true;
            FlxG.camera.flash(FlxColor.WHITE, 2);
            FlxG.camera.zoom = 2;
            new FlxTimer().start(2, () -> camZooming = false);
            stardustBgPixel.visible = true;
            stardustFloorPixel.visible = true;
        case 246:
            FlxTween.tween(dad, {x: 580}, 1, {ease: FlxEase.cubeInOut});
            FlxTween.tween(camHUD, {alpha: 1}, 1.2,{ease: FlxEase.cubeInOut});
            camZooming = true;
        case 1530: FlxTween.tween(camHUD, {alpha: 0}, 0.75,{ease: FlxEase.cubeInOut});
        case 1505:
            FlxTween.tween(dad, {x: -1500}, 5, {ease: FlxEase.cubeInOut});
            FlxTween.angle(dad, 0, -180, 5, {ease: FlxEase.cubeInOut});
        case 1542: dad.visible = false;
        case 1544:
            cinematicBars(true);
            changeCharacter(0, 'starved-pixel');
            dad.setPosition(-950, 200);
            opponentCam.set(1500, 800);
        case 1546,1587,1599,1624,1675,3334:
            LyricText(lyrics[lyricInt][0], lyrics[lyricInt][1], lyrics[lyricInt][2]);
            lyricInt++;
        case 1547:
            health = 1;

            boyfriend.playAnim("first dialogue");
            boyfriend.animation.finishCallback = function(name:String) {
                if (name == 'first dialogue') {
                    setSpeed(16);
                    changeCharacter(1, 'bf-Sonic-Peelout');
                    boyfriend.playAnim('idle', true);
                }
            }

            dad.playAnim("dialogue", true);
            dad.animation.finishCallback = function(name:String) {
                if (name == 'dialogue') {
                    setSpeed(8);
                    cinematicBars(false);
                }
            }
        case 1548: dad.visible = true;
        case 1570: FlxTween.tween(dad, {x: 1300}, 2.5,{ease: FlxEase.cubeInOut});
        case 1780: FlxTween.tween(camHUD, {alpha: 1}, 1.0);
        case 3328:
	        FlxTween.tween(camHUD, {alpha: 0}, 1,{ease: FlxEase.cubeInOut});
	        FlxTween.tween(dad, {x: -300}, 4,{ease: FlxEase.cubeInOut});
        case 3335: boyfriend.playAnim("dialogue peel");
        case 3364:
            cinematicBars(true);
            var gotcha:FlxSprite = new FlxSprite(boyfriend.x + 1500, boyfriend.y + 505, loadStageSpr('furnace_gotcha'));
			gotcha.setGraphicSize(Std.int(gotcha.width * 5));
			gotcha.antialiasing = false;
			gotcha.flipX = true;
			add(gotcha);
            FlxTween.tween(gotcha, {x: boyfriend.x + 500}, 0.2, {onComplete: remove(gotcha)});
        case 3367:
            FlxG.camera.flash(FlxColor.RED, 2);
            boyfriend.visible = dad.visible = false;
            stardustBgPixel.visible = stardustFloorPixel.visible = false;	
    }

function cinematicBars(show:Bool) {
    FlxTween.tween(cinematicBarsGrp.members[0], {y: show ? 0 : -170}, 0.5, {ease: FlxEase.quadOut});
	FlxTween.tween(cinematicBarsGrp.members[1], {y: show ? 550 : 720}, 0.5, {ease: FlxEase.quadOut});
}

function LyricText(text:String, ?duration:Float, ?color:String = '-1') {
    var Lyric:FlxText = cinematicBarsGrp.members[2];

    FlxTween.cancelTweensOf(text);
    if (lyricTimer != null) lyricTimer.cancel();

    Lyric.text = text;
    Lyric.color = color == '-1' ? -1 : FlxColor.fromString(color);
    if (Lyric.alpha != 1 || duration == 0) FlxTween.tween(Lyric, {alpha: 1}, 0.2);
    if (duration > 0 && (duration != 0 || duration != null)) lyricTimer.start(duration, () -> FlxTween.tween(Lyric, {alpha: 0}, 0.2));
}
