function onNoteCreation(_) if (_.noteType == 'fireNote') {
    _.noteSprite = 'modNotes/Tricky/fire';
    _.note.forceIsOnScreen = true;
    _.noteScale = 0.7;
    _.note.updateHitbox();
    _.note.earlyPressWindow = 0.1;
	_.note.latePressWindow = 0.2;
    if (_.strumLineID <= 0) _.note.wasGoodHit = true;
}

function onPostNoteCreation(_) if (_.noteType == 'fireNote')
    if (downscroll) _.note.frameOffset.y -= 75;
    else _.note.frameOffset.y -= 70;

function onPlayerHit(_) if (_.noteType == 'fireNote') {
    _.healthGain -= 0.45;
    playSound('burnSound');
}

function onPlayerMiss(_) if (_.noteType == 'fireNote') {
    _.cancel();
    deleteNote(_.note);
}

function onDadHit(e) if (e.noteType == 'fireNote') {
    e.animCancelled = true;
    e.cancel();
    deleteNote(e.note);
}