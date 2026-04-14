function postCreate()
    loadHud('PsychEngine', 'Fred, mamalo.');

function create() {

    defaultCamZoom = 0.69;

    useCamMov = true;
    camMoveAmt = 20;

    boyfriend.setPosition(770, 100);
    dad.setPosition(400, 130);

    var bg:FlxSprite = new FlxSprite().makeSolid(FlxG.width * 10, FlxG.height * 10, 0xFFFFFFFF);
    bg.setPosition(-1400,-700);
    insert(0, bg);

}