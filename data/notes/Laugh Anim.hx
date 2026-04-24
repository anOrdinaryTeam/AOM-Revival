function onNoteCreation(_) if (_.noteType == 'Laugh Anim') {
    if (songName == 'Too Slow') _.noteSprite = 'modNotes/EXE/STATICNOTE_assets';
    _.note.forceIsOnScreen = true;
}

function onDadHit(_) if (_.noteType == 'Laugh Anim') {
    _.animCancelled = true;
    dad.playAnim('Laugh', true);
}