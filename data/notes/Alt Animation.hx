function onNoteHit(_) if (_.noteType == 'Alt Animation') {
    _.animSuffix = "-alt";

    if (songName == 'Accelerant' && _.note.isSustainNote) {
        _.animCancelled = true;
        _.character.lastHit = Conductor.songPosition;
    }
}