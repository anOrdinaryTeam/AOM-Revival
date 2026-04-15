var upline:FlxSprite;
var downline:FlxSprite;

function create() {

    upline = new FlxSprite().makeSolid(FlxG.width*2 , FlxG.height, 0xFF000000);
    upline.setPosition(0,-658);
    upline.camera = camHUD;
    insert(1, upline);

    downline = new FlxSprite().makeSolid(FlxG.width*2, FlxG.height*2, 0xFF000000);
    downline.setPosition(0,658);
    downline.camera = camHUD;
    insert(1, downline);
    
}

function stepHit()

    switch(curStep){

        case 513:

            boyfriend.playAnim("Sonic Yeah", true);

            FlxTween.tween(upline, {y: upline.y + 50}, 1, {ease: FlxEase.backInOut});
            FlxTween.tween(downline, {y: downline.y - 50}, 1, {ease: FlxEase.backInOut});
            defaultCamZoom = 0.79;

            for (strum in player)
                FlxTween.tween(strum, {y: 120}, 1, {ease: FlxEase.backInOut});

            for (strum in cpu)
                FlxTween.tween(strum, {y: 120}, 1, {ease: FlxEase.backInOut});

            for (acheude in [healthBar, healthBarBG, iconP1, iconP2])
                FlxTween.tween(acheude, {alpha: 0}, 0.5);

        case 577:
            boyfriend.playAnim("Sonic Yeah", true);

        case 517, 581:
            dad.playAnim("Blaze yeah", true);

        case 637:

            defaultCamZoom = 0.69;

            FlxTween.tween(upline, {y: upline.y - 50}, 1, {ease: FlxEase.backInOut});
            FlxTween.tween(downline, {y: downline.y + 50}, 1, {ease: FlxEase.backInOut});

            for (strum in player)
                FlxTween.tween(strum, {y: 50}, 1, {ease: FlxEase.backInOut});

            for (strum in cpu)
                FlxTween.tween(strum, {y: 50}, 1, {ease: FlxEase.backInOut});

            for (acheude in [healthBar, healthBarBG, iconP1, iconP2])
                FlxTween.tween(acheude, {alpha: 1}, 0.5);    
            
        case 768:
            dad.playAnim("Blaze yeah", true);
            boyfriend.playAnim("Sonic Yeah", true);

    }