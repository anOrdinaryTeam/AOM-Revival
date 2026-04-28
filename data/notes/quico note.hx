function onNoteHit(_) {
    if (_.noteType == 'quico note') {
        _.cancelAnim();
        quico.playSingAnim(_.direction);
    }
    if (_.noteType == 'quico hey') {
        _.cancelAnim();
        quico.playAnim('hey');
    }
}