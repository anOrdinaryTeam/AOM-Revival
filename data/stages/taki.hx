import flixel.addons.effects.FlxTrail;
defaultCamZoom = 0.6;

function create() {
    addSprite(bg = new FlxSprite(-200, -100, getModImage('taki')));
    bg.antialiasing = Options.antialiasing;

    var evilTrail:FlxTrail = new FlxTrail(dad, null, 24, 0.6, 0.3, 0.069);
	// evilTrail.framesEnabled = false;
	insert(members.indexOf(dad), evilTrail);
}

function postCreate() {
    

    loadHud('KadeEngine', '1.4.3');
}

function onDadHit(e) {
    if (e.character.curCharacter == boyfriend.curCharacter) return;

    e.healthGain = 0.02;
    gf.playAnim('fear', true);
}

function onPlayerHit(e)
    e.healthGain += 0.01;