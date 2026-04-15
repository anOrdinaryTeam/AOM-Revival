function postCreate()
    loadHud('PsychEngine', 'Fred, mamalo.');

function create() {

    defaultCamZoom = 0.69;

    useCamMov = true;
    camMoveAmt = 20;

    boyfriend.setPosition(770, 100);
    dad.setPosition(400, 130);
    
    var bg:FlxSprite = new FlxSprite().makeSolid(FlxG.width * 3, FlxG.height * 3, 0xFFFFFFFF);
    bg.setPosition(-1400,-700);
    insert(0, bg);

    var upline:FlxSprite = new FlxSprite().makeSolid(FlxG.width*2 , 60, 0xFF000000);
    //upline.setPosition(-1400,-750);
    upline.camera = camHUD;
    insert(1, upline);

    var downline:FlxSprite = new FlxSprite().makeSolid(FlxG.width*2, 70, 0xFF000000);
    //downline.setPosition(-1400,832.5);
    downline.setPosition(0,658);
    downline.camera = camHUD;
    insert(1, downline);
    
    // ruhs - Fred

}

function stepHit()

    switch(curStep){

        case 513, 577, 768:
            boyfriend.playAnim("Sonic Yeah", true);

        case 517, 581, 768:
            dad.playAnim("Blaze yeah", true);

    }