import flixel.text.FlxBitmapText;
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

    var accWb:FlxSprite = new FlxSprite(0, downscroll ? healthBarBG.y - 65 : healthBarBG.y + 35).makeSolid(200, 30, FlxColor.BLACK);
    accWb.alpha = 0.3;
    accWb.x = (whiteBox.x + whiteBox.width) + 60;
    hudItems.add(accWb);

    var texts:Array<String> = ['DEATHS: ${PlayState.deathCounter}', 'MISSES: 0', 'RATING: Unrated', 'SCORE: 0', 'ACCURACY: 0%'];
    for (i => text in texts) {
        var score:FlxBitmapText = new FlxBitmapText(0, whiteBox.y + 4, text, getBitmapFont('VCR'));
        setBmdFormat(score, FlxColor.WHITE, 'none', 'OUTLINE', 0, -1);
        setBmdSize(score, 0.22);
        score.scrollFactor.set();
        score.antialiasing = true;
        hudItems.add(score);

        switch(i) {
            case 0: score.x = whiteBox.x + 10;
            case 1: score.x = whiteBox.x + 120;
            case 2: score.x = whiteBox.x + 240;
            case 3: score.x = whiteBox.x + 450;
            case 4: score.x = accWb.x + 20;
        }
    }
}

function onRatingUpdate(_) {
    var color:FlxColor = switch(_.rating.rating) {
        case 'S++': 0xDDEC05;
        default: _.rating.color;
    };
    var rating:String = misses == 0 ? 'PERFECT COMBO' : _.rating.rating;
    var acc:Float = CoolUtil.quantize(accuracy * 100, 100);

    hudItems.members[0].colorTransform.color = color;
    hudItems.members[1].colorTransform.color = color;

    hudItems.members[3].text = 'MISSED: $misses';
    hudItems.members[4].text = 'RATING: $rating';
    hudItems.members[5].text = 'SCORE: $songScore';
    hudItems.members[6].text = 'ACCURACY: $acc%';
}