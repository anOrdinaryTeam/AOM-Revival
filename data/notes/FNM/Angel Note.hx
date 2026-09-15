var curDamage:Float = 0.4;
var flashHit:FlxSprite;

function create() {
    flashHit = new FlxSprite().loadGraphic(getModImage('gris'));
    flashHit.antialiasing = true;
    flashHit.alpha = 0.001;
    flashHit.scrollFactor.set();
    flashHit.camera = camHUD;
    insert(1, flashHit);
}

function onNoteCreation(e) {
    if (e.noteType != 'FNM/Angel Note') return;
    e.noteSprite = 'modNotes/FNM/NOTE_AngelNote';
    e.note.splash = 'angel';
    if (e.strumLineID <= 0) e.note.wasGoodHit = true;
}

function onPlayerHit(e) {
    if (e.noteType != 'FNM/Angel Note') return;
    e.healthGain -= curDamage;
    e.animCancelled = true;
    e.character.playSingAnim(e.direction, 'miss');
    curDamage += 0.1;

    flashHit.alpha = 1;
    camGame.shake(0.01, 0.1);
    playModSound('holyNoteHit', 0.8);
    FlxTween.cancelTweensOf(flashHit);
    FlxTween.tween(flashHit, {alpha: 0}, 0.3, {ease: FlxEase.quadInOut});
}

function onPlayerMiss(e) if (e.noteType == 'FNM/Angel Note') {
	e.cancel();
	deleteNote(e.note); 
}