// importScript('data/scripts/xEventShit');

function create() {
    defaultCamZoom = 0.75;

    gf.scale.set(0.5, 0.5);
    gf.x -= 50; gf.y += 20;

    boyfriend.x += 200; boyfriend.y += 70; 
    boyfriend.cameraOffset.x -= 120; boyfriend.cameraOffset.y -= 80;

    dad.x -= 135; dad.y += 220;

    for (i in 0...7) {
        var bg:FlxSprite = new FlxSprite(-600, -200, getModPath('InkingMistake/bg' + i));
        bg.antialiasing = Options.antialiasing;
        bg.scrollFactor.set(0.92 + i * 0.025, 0.92 + i * 0.025);
        addSprite(bg);
        if (i > 1) FlxTween.tween(bg, {y: bg.y + 50}, (Math.random()* 5 + 5) / 2, {ease: FlxEase.quadInOut, type: 4});
    }

    var bg:FlxSprite = new FlxSprite(-600, -230, getModPath('InkingMistake/ground'));
    bg.antialiasing = Options.antialiasing;
    bg.scrollFactor.set(0.9, 0.9);
    addSprite(bg);

    var lg:FlxSprite = new FlxSprite(-600, -200, getModPath('InkingMistake/fg'));
    lg.antialiasing = Options.antialiasing;
    lg.scrollFactor.set(0.9, 0.9);
    add(lg);

    FlxTween.tween(lg, {alpha:0.4}, 2, {ease: FlxEase.quadInOut, type: 4, loopDelay:0.5});
}