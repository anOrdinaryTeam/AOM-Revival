var t:String = 'PokemonMaster/PixelChorizoNote';

function onNoteCreation(_) if (_.noteType == t) {
    _.noteSprite = 'modNotes/pokemonmaster/fuegopixelnotes';
    _.note.frameOffset.set(0, 5);
}

function onPlayerHit(e) if (e.noteType == t) {
    FlxG.sound.play(Paths.sound('pokemonmaster/Flame'));
    health -= 0.2;
    misses += 1;
}

function onPlayerMiss(e) if (e.noteType == t) {
	e.cancel();
	deleteNote(e.note); 
}