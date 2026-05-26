function postCreate()
    loadHud('ForeverEngine', '0.3.1');

function create() {
    defaultCamZoom = 0.5;

    useCamMov = true;
    camMoveAmt = 50;

    gf.alpha = 0;

    precacheCharacter(0, 'Summit/red_angry');

    var sky:FlxSprite = new FlxSprite(-1000, -300, getModImage('Summit/mtsilversky'));
    sky.scrollFactor.set(0.5, 0.5);
    sky.scale.set(2, 2);
    sky.updateHitbox();
    insert(1, sky);

    var floor:FlxSprite = new FlxSprite(-1000, -250, getModImage('Summit/mtsilverground'));
    floor.scrollFactor.set(0.9, 0.9);
    floor.scale.set(2, 2);
    floor.updateHitbox();
    insert(2, floor);

    var fog:FlxSprite = new FlxSprite(-1000, 650, getModImage('Summit/mtsilverground'));
    fog.scrollFactor.set(0.9, 0.9);
    fog.scale.set(2, 2);
    fog.updateHitbox();
    insert(3, fog);
}

function stepHit()
    if (curStep == 352)
        changeCharacter(0, 'Summit/red_angry');