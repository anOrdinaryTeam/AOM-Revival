var t:String = 'Expurgation Note';

function onNoteCreation(_) if (_.noteType == t) {
    _.noteSprite = 'modNotes/Tricky/deathNotes';
    _.note.forceIsOnScreen = true;
    _.note.earlyPressWindow = 0.1;
	_.note.latePressWindow = 0.2;
    if (_.strumLineID <= 0) _.note.wasGoodHit = true;
}

function onPostNoteCreation(_) if (_.noteType == t && !downscroll)
    _.note.frameOffset.y = 55;

function onPlayerHit(e) if (e.noteType == t) {
    e.animCancelled = true;
    e.healthGain -= 20;
}

function onPlayerMiss(e) if (e.noteType == t) {
	e.cancel();
	deleteNote(e.note); 
}