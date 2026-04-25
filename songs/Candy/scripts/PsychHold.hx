import haxe.ds.ObjectMap;

var frozenCharacters:ObjectMap<Character, Bool> = new ObjectMap();
var frozenStrums:ObjectMap<Strum, Bool> = new ObjectMap();

function onNoteHit(e) {
    if (e.noteType == 'No Animation' || e.noteType == 'No Anim') return;
    for (char in e.characters){
        if (e.note.isSustainNote) frozenCharacters.set(char, true);
        if (e.note.animation.name == "holdend") frozenCharacters.set(char, false);
    }
    if (e.note.isSustainNote) frozenStrums.set(strumLines.members[e.note.strumLine.ID].members[e.note.strumID], true);
    if (e.note.animation.name == "holdend") frozenStrums.set(strumLines.members[e.note.strumLine.ID].members[e.note.strumID], false);
}

function postUpdate(elapsed:Float) {
    for (char in frozenCharacters.keys()) {
        var bool = frozenCharacters.get(char);
        char.animation.paused = bool;
    }
    for (char in frozenStrums.keys()) char.animation.paused = frozenStrums.get(char);
}

function onPlayerMiss(e){
    for (a in e.characters) frozenCharacters.set(a, false);
    frozenStrums.set(strumLines.members[e.note.strumLine.ID].members[e.note.strumID], false);
}