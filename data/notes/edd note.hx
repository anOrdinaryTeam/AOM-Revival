function onNoteHit(_) {
    if (_.noteType == "edd note") {
        _.cancelAnim();
        edd.playSingAnim(_.direction);
    }
}