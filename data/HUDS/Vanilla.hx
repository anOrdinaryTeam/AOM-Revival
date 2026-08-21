import AomText;
public var score:FlxBitmapText;

function onHudLoad(hud) if (hud == 'Vanilla') {
    for (i in cpuStrums) i.x -= 45;
    for (i in playerStrums) i.x -= 45;

    score = new AomText(770, downscroll ? healthBarBG.y - 35 : healthBarBG.y + 45, "Score:0", 0.23);
    score.setFormat(-1, 'center', 'outline', 6, FlxColor.BLACK);
    score.camera = camHUD;
    score.scrollFactor.set();
    add(score);
}

function onRatingUpdate()
    score.text = 'Score:$songScore';