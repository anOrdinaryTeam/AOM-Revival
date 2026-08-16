var hank:FunkinSprite;

function create() {
    defaultCamZoom = 0.35;

    var bg:FlxSprite = new FlxSprite(-1000, -1000, getModImage('stages/fourth/bg'));
    bg.antialiasing = Options.antialiasing;
    bg.scrollFactor.set(0.9, 0.9);
    bg.setGraphicSize(Std.int(bg.width * 5));
    addSprite(bg);

    var stageFront:FlxSprite = new FlxSprite(-1600, -400, getModImage('stages/hellclwn/island_but_red'));
    stageFront.antialiasing = Options.antialiasing;
    stageFront.scrollFactor.set(0.9, 0.9);
    stageFront.setGraphicSize(Std.int(stageFront.width * 2.6));
    addSprite(stageFront);

    hank = new FunkinSprite(500, -150, getModImage('stages/hellclwn/Hank'));
    hank.addAnim('dance','Hank', 24);
    hank.playAnim('dance');
    hank.scrollFactor.set(0.9, 0.9);
    hank.setGraphicSize(Std.int(hank.width * 1.55));
    hank.antialiasing = Options.antialiasing;
    addSprite(hank);
}

function onDadHit(e) {
    if (e.character.curCharacter == boyfriend.curCharacter) return;
    camGame.shake(0.02, 0.2);
}

function beatHit()
    hank.playAnim('dance');