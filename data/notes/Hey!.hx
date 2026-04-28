function onPlayerHit(_) {
    if (_.noteType == 'Hey!') {
        _.cancelAnim();
        boyfriend.playAnim('hey');
    }
}

function onDadHit(_) {
    if (_.noteType == 'Hey!') {
        _.cancelAnim();
        dad.playAnim('hey');
    }
}