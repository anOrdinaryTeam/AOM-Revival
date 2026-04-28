var t:String = 'PixelChorizoNote';

function onNoteCreation(_) if (_.noteType == t) {
    _.noteSprite = 'modNotes/pokemonmaster/fuegopixelnotes';
    _.note.forceIsOnScreen = true;
    _.note.earlyPressWindow = 0.4;
	_.note.latePressWindow = 0.4;
    if (_.strumLineID <= 0) _.note.wasGoodHit = true;
}

function onPostNoteCreation(_) if (_.noteType == t) {
    _.note.offset.x -= 0;
    _.note.offset.y = 55;
}

function onPlayerHit(e) if (e.noteType == t) {
    FlxG.sound.play(Paths.sound('pokemonmaster/Flame'));
    e.animCancelled = true;
    health = health - 0.2;
    misses = misses+1;
    //e.healthGain -= -0.45; siseven ashjasjhashjasashjsahjhjadsjhhasjdkasdjhkasdjkashdjkashdjkasdhaqshz<<<<zzz
}

function onPlayerMiss(e) if (e.noteType == t) {
	e.cancel();
	deleteNote(e.note); 
}