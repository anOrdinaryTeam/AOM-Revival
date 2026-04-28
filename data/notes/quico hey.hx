function onNoteHit(_) {
    if (_.noteType == 'quico hey') {
        _.cancelAnim();
        quico.playAnim('hey');
    }
}