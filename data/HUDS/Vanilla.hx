public var score:FunkinText;

function onHudLoad(hud) if (hud == 'Vanilla') {
    for (i in cpuStrums) i.x -= 45;
    for (i in playerStrums) i.x -= 45;

    score = new FunkinText(770, downscroll ? healthBarBG.y - 35 : healthBarBG.y + 45, 0, "Score:0", 20);
    score.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, 'center');
    score.camera = camHUD;
    score.scrollFactor.set();
    add(score);
}

function onRatingUpdate()
    score.text = 'Score:$songScore';