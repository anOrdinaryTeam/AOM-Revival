function postCreate() {
    loadHud('KadeEngine', '1.2.1');
    importScript('data/scripts/xEventShit');
}

function onNoteCreation(e) e.noteSprite = "modNotes/X/NOTE_assets";
function onStrumCreation(e) e.sprite = "modNotes/X/NOTE_assets";