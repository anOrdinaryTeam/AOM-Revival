defaultCamZoom = 0.78;

function preStageLoad()
    useStageData = false;

function addBg(spr:FlxSprite) if (spr != null) {
    spr.antialiasing = Options.antialiasing;
    addSprite(spr);
}

function create() {
    gf.setPosition(950, 740);
    dad.setPosition(320, 630);
    boyfriend.setPosition(1660, 710);

    var bg:FlxSprite = new FlxSprite(-600, -300, getModImage('Prison/background'));
    bg.scale.set(1.2, 1.5);
    bg.updateHitbox();
    addBg(bg);
}

function onDadHit(e) {
    if (e.character.curCharacter == boyfriend.curCharacter) return;
    camGame.shake(0.02, 0.1, null, true, 0x01);
}