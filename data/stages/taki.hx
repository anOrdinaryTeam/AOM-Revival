defaultCamZoom = 0.6;

function create() {
    addSprite(bg = new FlxSprite(-200, -100, getModImage('taki')));
    bg.antialiasing = Options.antialiasing;
}

function onDadHit(e) {
    if (e.character.curCharacter == boyfriend.curCharacter) return;

    gf.playAnim('fear', true);
}