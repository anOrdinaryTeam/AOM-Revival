var t:String = 'PokemonMaster/ChorizoNote';

function onNoteCreation(_) if (_.noteType == t) {
    _.noteSprite = 'modNotes/pokemonmaster/fuegoflechas';
    _.note.frameOffset.set(0, 20);
}

function onPlayerHit(e) if (e.noteType == t) {
    FlxG.sound.play(Paths.sound('pokemonmaster/Flame'));
    charizard.playAnim('attack');
    health -= .2;
    misses += 1;
}

function onPlayerMiss(e) if (e.noteType == t) {
	e.cancel();
	deleteNote(e.note); 
}