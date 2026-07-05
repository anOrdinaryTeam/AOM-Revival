public var hudItems:FlxTypedGroup<Dynamic> = new FlxTypedGroup();

function onHudLoad(hud) if (hud == 'MFM') {
    hudItems.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, hudItems);

    for (i in cpuStrums) i.x -= 45;
    for (i in playerStrums) i.x -= 45;

    var whiteBox:FlxSprite = new FlxSprite(0, downscroll ? healthBarBG.y - 65 : healthBarBG.y + 35).makeSolid(600, 30, FlxColor.BLACK);
    whiteBox.screenCenter(FlxAxes.X);
    whiteBox.alpha = 0.3;
    hudItems.add(whiteBox);

    for (i in 0...4) {
        var score:FunkinText = new FunkinText(0, whiteBox.y + 4, 0, "", 16, false);
        score.scrollFactor.set();
        score.antialiasing = true;
        hudItems.add(score);

        switch(i) {
            case 0:
                score.text = 'DEATHS: ' + PlayState.deathCounter;
                score.x = whiteBox.x + 10;
            case 1:
                score.text = 'MISSED: 0';
                score.x = whiteBox.x + 120;
            case 2:
                score.text = 'RATING: Unrated';
                score.x = whiteBox.x + 250;
            case 3:
                score.text = 'SCORE: 0';
                score.x = whiteBox.x + 450;
        }
    }
}

function onRatingUpdate(_) {
    var color:FlxColor = switch(_.rating.rating) {
        case 'S++': 0xDDEC05;
        default: _.rating.color;
    };
    hudItems.members[0].colorTransform.color = color;

    hudItems.members[2].text = 'MISSED: ' + misses;
    hudItems.members[3].text = 'RATING: ' + _.rating.rating;
    hudItems.members[4].text = 'SCORE: ' + songScore;
}