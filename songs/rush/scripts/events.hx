var upline:FlxSprite;
var downline:FlxSprite;

function create() {

    upline = new FlxSprite().makeSolid(FlxG.width*2 , 60, 0xFF000000);
    //upline.setPosition(-1400,-750);
    upline.camera = camHUD;
    insert(1, upline);

    downline = new FlxSprite().makeSolid(FlxG.width*2, 70, 0xFF000000);
    //downline.setPosition(-1400,832.5);
    downline.setPosition(0,658);
    downline.camera = camHUD;
    insert(1, downline);
    
}

function stepHit()

    switch(curStep){

        case 513, 577, 768:
            boyfriend.playAnim("Sonic Yeah", true);

        case 517, 581, 768:
            dad.playAnim("Blaze yeah", true);

        case 5:
            var FlxTween.tween(upline, {y: upline.y - 100}, 1, {ease: FlxEase.backInOut});
            var FlxTween.tween(strum, {y: strum.y - 600, angle: -360});

    }