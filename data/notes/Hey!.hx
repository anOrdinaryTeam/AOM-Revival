function onNoteHit(_)
    if (_.noteType == 'Hey!'){
        _.cancelAnim();
        for(char in _.characters) char.playAnim('hey');
    }