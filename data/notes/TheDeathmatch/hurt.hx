function onNoteCreation(_) {
    if (_.noteType == 'TheDeathmatch/hurt') {
        _.noteSprite = 'modNotes/TheDeathmatch/evildeath note';
        _.note.frameOffset.set(50, 50);
    }
}

function onPlayerHit(_)
    if (_.noteType == 'TheDeathmatch/hurt') {
        _.animSuffix = "miss";
        _.healthGain = 0;

        health -= .125;
        misses += 1;
}

function onPlayerMiss(_) {
    if (_.noteType == 'TheDeathmatch/hurt') {
	    _.cancel();
        deleteNote(_.note);
    }
}