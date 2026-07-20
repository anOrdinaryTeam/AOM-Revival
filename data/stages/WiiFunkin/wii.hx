function preStageLoad()
    useStageData = false;

function create() {
    defaultCamZoom = .8;

    dad.setPosition(130, 100);
    boyfriend.setPosition(1000, 150);
    gf.setPosition(430, -150);

    var bg:FlxSprite = new FlxSprite(-550, -475, getModImage('wii1/swordfight'));
    bg.scrollFactor.set(0.9, 0.9);
    addSprite(bg);
}