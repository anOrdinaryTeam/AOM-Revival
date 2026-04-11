// var strumTimes:Array<Float> = [];

// function postCreate() for (strum in strumLines) for (i in 0...4) {
//     var note = strum.members[i];
//     if (note.strumTime == note.nextNote.strumTime) strumTimes.push(note.strumTime);
// }

function onNoteHit(e) {
    // var hitBy:Character = e.player ? 
    if (e.note.strumTime == e.note.nextNote.strumTime) {
        // strumTimes.shift();
        trace('Double Note!');
    }
}