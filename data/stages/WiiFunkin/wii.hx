function preStageLoad()
    useStageData = false;

function create() {
    dad.setPosition(130, 100);
    boyfriend.setPosition(1000, 150);
    gf.setPosition(430, -150);

    switch(curSong) {
        case 'light it up' | 'ruckus' | 'target practice': defaultCamZoom = .8;
            var bg:FlxSprite = new FlxSprite(-550, -475, getModImage('wii1/swordfight'));
            bg.scrollFactor.set(0.9, 0.9);
            addSprite(bg);

        case 'sporting' | 'boxing match': defaultCamZoom = .9;
            var bg:FlxSprite = new FlxSprite(-700, -700, getModImage('wii2/boxingnight1'));
            bg.scrollFactor.set(0.9, 0.9);
            addSprite(bg);

            var night:FlxSprite = new FlxSprite(-700, -700, getModImage('wii2/boxingnight2'));
            night.scrollFactor.set(0.8, 0.8);
            addSprite(night);

            var ring:FlxSprite = new FlxSprite(-700, -700, getModImage('wii2/boxingnight3'));
            ring.scrollFactor.set(0.9, 0.9);
            addSprite(ring);
    }
}