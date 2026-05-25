// based on 2.5/3.0 code 'cause i think 2.0 was hardcoded iirc
var dropTime:Float = 0;
var healthDrop:Float = 0;

function onNoteCreation(e) if (e.noteType == 'Phantom Note') {
    e.noteSprite = 'modNotes/EXE/PHANTOMNOTE_assets';
    e.note.earlyPressWindow = 0.1;
	e.note.latePressWindow = 0.2;
	if (e.strumLineID <= 0) e.note.wasGoodHit = true;
}

function onPlayerHit(e) if (e.noteType == 'Phantom Note') {
    misses++;
    dropTime = 10;
    healthDrop += 0.00025;
}

function onPlayerMiss(e) if (e.noteType == 'Phantom Note') { 
	e.cancel();
	deleteNote(e.note); 
}

function update(dt) if (dropTime > 0) {
    dropTime -= dt;
    health -= healthDrop * (dt / (1 / 120));
}