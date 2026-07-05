import flixel.addons.effects.FlxTrail;

playCutscenes = true;
cutscene = 'Mods/$currentMod/MFM-Intro.hx';

var skin:String = getSaveData('MFM_altNotes') ? 'old' : 'new';
var devilbg_1:FlxSprite;

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

    devilbg_1 = new FlxSprite(420, -310, getModImage('devil/sprite'));
    devilbg_1.antialiasing = Options.antialiasing;
    addSprite(devilbg_1);
    FlxTween.angle(devilbg_1, devilbg_1.angle, -360, 3, {type: 2});

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

    trail = new FlxTrail(dad, null, 10, 15, 0.3, 0.069);
    trail.color = dad.iconColor;
    setObjectOrder(trail, getObjectOrder(dad));
    trail.visible = false;
}

function onNoteCreation(e) {
    if (e.strumLineID == 1 && usingSkins) return;
    e.noteSprite = 'modNotes/MFM/$skin';
}

function onStrumCreation(e) {
    if (e.player == 1 && usingSkins) return;
    e.sprite = 'modNotes/MFM/$skin';
}

function stepHit() switch(curStep) {
    case 128 | 576 | 1153: trail.visible = true;
    case 191 | 607 | 1276: trail.visible = false;
}

function onEvent(e) if (e.event.name == 'Camera Movement') {
    var bfTurn:Bool = e.event.params[0] == 1;
    var toAngle:Float = bfTurn ? 360 : -360;
    
    FlxTween.cancelTweensOf(devilbg_1);
    FlxTween.angle(devilbg_1, devilbg_1.angle, (devilbg_1.angle + toAngle), 3, {type: 2});
}