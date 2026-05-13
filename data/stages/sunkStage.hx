var spong:FlxSprite;

function create() {
    defaultCamZoom = 0.9;
    boyfriend.x -= 100;
	dad.x = -180; dad.y = 200;

    var bg:FlxSprite = new FlxSprite().loadGraphic(getModImage('SunkBG'));
    bg.setGraphicSize(Std.int(bg.width * 0.8));
    bg.antialiasing = Options.antialiasing;
    bg.scrollFactor.set(.91, .91);
    bg.x -= 670; bg.y -= 260;
    bg.active = false;
    addSprite(bg);
}

function postCreate() {
    spong = new FlxSprite(dad.x + 190, dad.y + 220, getModImage('SpingeBinge'));
    spong.antialiasing = Options.antialiasing;
    spong.scale.set(1.2, 1.2);
    spong.updateHitbox();
    add(spong);
    spong.visible = false;
}

function stepHit() switch(curStep) {
    case 69: FlxTween.tween(FlxG.camera, {zoom: 2.2}, 4);
    case 96:
        FlxTween.cancelTweensOf(FlxG.camera);
		FlxG.camera.zoom = defaultCamZoom;
    case 538, 2273:
        spong.visible = true;
        dad.alpha = 0.01;

        new FlxTimer().start(0.7, () -> {
            spong.visible = false;
            dad.alpha = 1;
        });
}