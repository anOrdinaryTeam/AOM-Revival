function onNoteCreation(_) if (_.noteType == 'markov note') {
	_.noteSprite = 'modNotes/Epiphany/markov';
	_.note.earlyPressWindow = 0.1;
	_.note.latePressWindow = 0.2;
	if (_.strumLineID <= 0) _.note.wasGoodHit = true;
}

function onPostNoteCreation(_) if (_.noteType == 'markov note') {
	_.note.offset.x -= 4000;
	_.note.offset.y += 16;
}

function onPlayerHit(e) if (e.noteType == "markov note")
	health = -1;

function onDadHit(_) if (_.noteType == 'markov note')
	_.animCancelled = true;

function onPlayerMiss(e) if (e.noteType == "markov note") { 
	e.cancel();
	deleteNote(e.note); 
}