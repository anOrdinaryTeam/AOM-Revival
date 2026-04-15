function create() {
    defaultCamZoom = 0.75;
    gf.scale.set(0.5, 0.5);

    for (i in 0...7) {
        var bg:FlxSprite = new FlxSprite(-600, -200, getModImage('InkingMistake/bg$i'));
        bg.antialiasing = Options.antialiasing;
        bg.scrollFactor.set(0.92 + i * 0.025, 0.92 + i * 0.025);
        addSprite(bg);
        if (i > 1) FlxTween.tween(bg, {y: bg.y + 50}, (Math.random()* 5 + 5) / 2, {ease: FlxEase.quadInOut, type: 4});
    }

    var bg:FlxSprite = new FlxSprite(-600, -230, getModImage('InkingMistake/ground'));
    bg.antialiasing = Options.antialiasing;
    bg.scrollFactor.set(0.9, 0.9);
    addSprite(bg);

    var lg:FlxSprite = new FlxSprite(-600, -200, getModImage('InkingMistake/fg'));
    lg.antialiasing = Options.antialiasing;
    lg.scrollFactor.set(0.9, 0.9);
    add(lg);

    FlxTween.tween(lg, {alpha: 0.4}, 2, {ease: FlxEase.quadInOut, type: 4, loopDelay:0.5});
}