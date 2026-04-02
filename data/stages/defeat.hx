function create() {
    defaultCamZoom = 0.9;
    var bg:FlxSprite = new FlxSprite(0, 100, getModImage('defeatfnf'));
    bg.setGraphicSize(Std.int(bg.width * 2));
    bg.antialiasing = Options.antialiasing;
    addSprite(bg);

    gf.visible = false;
}

function postCreate()
    loadHud('KadeEngine', '1.6.1');

function postHudLoad() {
    healthBar.visible = healthBarBG.visible = false;
    iconP1.visible = iconP2.visible = false;
    hudItems.members[0].visible = false;
}

function onCountdown(_) if (_.swagCounter == 1) {
    for (strum in player)
        FlxTween.tween(strum, {x: strum.x - 275, angle: -360}, 0.6, {ease: FlxEase.sineInOut});
    for (strum in cpu)
        FlxTween.tween(strum, {x: strum.x - 600, angle: -360}, 0.6, {ease: FlxEase.sineInOut});
}