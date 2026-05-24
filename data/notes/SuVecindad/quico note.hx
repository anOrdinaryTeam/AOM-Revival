function onNoteHit(_) {
    if (_.noteType == 'SuVecindad/quico note') {
        _.cancelAnim();
        quico.playSingAnim(_.direction);
    }
}