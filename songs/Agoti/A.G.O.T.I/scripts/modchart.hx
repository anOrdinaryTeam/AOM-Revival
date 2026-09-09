var defY_Strum:Float = 0;

function postCreate()
    defY_Strum = cpu.members[0].y;

function onNoteCreation(e) {
    e.note.strumRelativePos = false;
    e.note.noteAngle = 0.001;
}

function update() {
    var currentBeat = (Conductor.songPosition / 1000) * (Conductor.bpm / 60);
    for (strum in strumLines) for (i in 0...4) {
        var note = strum.members[i];
        note.y = defY_Strum + 10 * Math.cos((currentBeat + i * 0.25) * Math.PI);
    }
}

function flipNotes() for (strum in strumLines) for (i in 0...4) {
    var note = strum.members[i];
    FlxTween.tween(note, {angle: 360}, 0.6, {ease: FlxEase.cubeInOut, onComplete: () -> note.angle = 0});
}

function stepHit() switch(curStep) {
    case 120, 248, 375, 632, 696, 824, 952, 1208:
        flipNotes();
}