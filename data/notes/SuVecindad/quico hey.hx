function onNoteHit(_) {
    if (_.noteType == 'SuVecindad/quico hey') {
        _.cancelAnim();
        quico.playAnim('hey');
    }
}