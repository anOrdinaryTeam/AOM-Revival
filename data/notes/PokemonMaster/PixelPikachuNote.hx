var t:String = 'PokemonMaster/PixelPikachuNote';

function onNoteCreation(_) if (_.noteType == t) {
    _.noteSprite = 'modNotes/pokemonmaster/flechassssssss';
    _.note.frameOffset.set(0, 5);
}


function onPlayerHit(e) if (e.noteType == t) {
    FlxG.sound.play(Paths.sound('pokemonmaster/Thunder'));
    e.animCancelled = true;
    health -= 0.2;
    misses += 1;
}

function onPlayerMiss(e) if (e.noteType == t) {
	e.cancel();
	deleteNote(e.note); 
}