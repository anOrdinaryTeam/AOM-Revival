function postCreate() {
    loadHud('KadeEngine', '1.2.1');
    importScript('data/scripts/xEventShit');
}

var skin:String = 'modNotes/X/NOTE_assets';
function onNoteCreation(_) {
    if (_.strumLineID == 1 && usingSkins) return;
    _.noteSprite = skin;
    if (_.strumLineID == 1) _.note.splash = 'x';
}

function onStrumCreation(_) {
    if (_.player == 1 && usingSkins) return;
    _.sprite = skin;
}