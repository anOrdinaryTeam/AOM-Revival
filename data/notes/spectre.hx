var spr:String = downscroll ? 'SpectreNoteDownscroll' : 'SpectreNote';
var noteFadeTime:Float = 0.0010;
var noteOpacity:Float = 0.5;
var spectreHit:Bool = false;
var enemySpectreHit:Bool = false;

function update(_) {
    var elapsed:Float = _;
    
    player.notes.forEach(function(note) {
        if (!spectreHit)
            if (noteFadeTime * elapsed > noteOpacity) noteOpacity = 0;
            else noteOpacity -= noteFadeTime * elapsed;
        else
            if (noteOpacity > 1) {
                noteOpacity = 1;
                spectreHit = false;
            }
            else
                noteOpacity += elapsed;
    
        var boundNoteOpacity = Math.max(0, Math.min(1, noteOpacity));
        note.alpha = boundNoteOpacity;
    });
}

function onNoteCreation(_)
    if (_.noteType == 'spectre') {
        _.note.alpha = 1;
        _.noteSprite = 'modNotes/Corruptro/' + spr;
        _.note.forceIsOnScreen = true;
        _.note.earlyPressWindow = 0.5;
		_.note.latePressWindow = 0.5;
        if (_.strumLineID <= 0) _.note.wasGoodHit = true;
    }

function onPlayerHit(_)
    if (_.noteType == 'spectre') {
        playModSound('SpectreArrow');
        spectreHit = true;
        if (_.strumLineID == 0) FlxTween.tween(_.note, {alpha: 1}, 0.5);
    }

function onPlayerMiss(_)
    if (_.noteType == 'spectre') {
        _.cancel();
        deleteNote(_.note);
    }