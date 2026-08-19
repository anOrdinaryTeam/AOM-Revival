import flixel.text.FlxBitmapText;
public var score:FlxBitmapText;

function onHudLoad(hud) if (hud == 'Vanilla') {
    for (i in cpuStrums) i.x -= 45;
    for (i in playerStrums) i.x -= 45;

    score = new FlxBitmapText(770, downscroll ? healthBarBG.y - 35 : healthBarBG.y + 45, "Score:0", getBitmapFont('VCR'));
    setBmdFormat(score, FlxColor.WHITE, 'center', 'outline', 6, FlxColor.BLACK);
    setBmdSize(score, 0.23);
    score.camera = camHUD;
    score.antialiasing = true;
    score.scrollFactor.set();
    add(score);
}

function onRatingUpdate()
    score.text = 'Score:$songScore';