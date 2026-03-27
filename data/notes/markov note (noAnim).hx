function onNoteCreation(_) if (_.noteType == 'markov note (noAnim)')
	_.noteSprite = 'modNotes/Epiphany/markov';

function onPostNoteCreation(_) if (_.noteType == 'markov note (noAnim)') {
	_.note.offset.x += 50;
	_.note.offset.y += 65;
}

function onPlayerHit(e) if (e.noteType == "markov note (noAnim)")
	health = -1;

function onDadHit(_) if (_.noteType == 'markov note (noAnim)')
	_.animCancelled = true;

function onPlayerMiss(e) if (e.noteType == "markov note (noAnim)") { 
	e.cancel();
	deleteNote(e.note); 
}