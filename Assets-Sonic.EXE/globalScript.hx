function postCreate() {
    useCamMov = true;
    loadHud('KadeEngine', '1.5.4');
    setRatingPrefix('EXE');
}

function onNoteCreation(_) if (songName != 'Endless')
    _.note.splash = 'blood';