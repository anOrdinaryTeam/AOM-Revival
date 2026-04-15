function onDadHit(e) if (e.noteType == 'Tricky Sing') {
    tricky.playSingAnim(e.direction);
    e.cancelAnim();
}