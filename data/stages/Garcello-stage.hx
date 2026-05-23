function preStageLoad()
    useStageData = false;

function create() {
    defaultCamZoom = 0.9;

	var bg:FlxSprite = new FlxSprite(-500, -170);
    bg.antialiasing = Options.antialiasing;

    var alley:FlxSprite = new FlxSprite(-500, -200);
    alley.antialiasing = Options.antialiasing;

    switch(curSong) {
        case 'headache' | 'nerves':
            bg.loadGraphic(getModImage('stage/garStagebg'));
            addSprite(bg);

            alley.loadGraphic(getModImage('stage/garStage'));
            addSprite(alley);

        case 'release':
            bg.loadGraphic(getModImage('stage/garStagebgAlt'));
            addSprite(bg);

            var smoke1:FunkinSprite = new FunkinSprite(0, -290, getModImage('stage/garSmoke'));
            smoke1.antialiasing = Options.antialiasing;
	        smoke1.setGraphicSize(Std.int(smoke1.width * 1.7));
	        smoke1.scrollFactor.set(0.7, 0.7);
	        smoke1.alpha = 0.3;
	        addSprite(smoke1);

            smoke1.addAnim('idle', 'smokey', 13, true);
            smoke1.playAnim('idle');

            alley.loadGraphic(getModImage('stage/garStagealt'));
            addSprite(alley);

            var corpse:FlxSprite = new FlxSprite(-230, 540, getModImage('stage/gardead'));
            corpse.antialiasing = Options.antialiasing;
            addSprite(corpse);

            var smoke2:FunkinSprite = new FunkinSprite(0, 0, getModImage('stage/garSmoke'));
            smoke2.antialiasing = Options.antialiasing;
	        smoke2.setGraphicSize(Std.int(smoke2.width * 1.6));
	        smoke2.scrollFactor.set(1.1, 1.1);
	        add(smoke2);

            smoke2.addAnim('idle', 'smokey', 15, true);
            smoke2.playAnim('idle');

        case 'fading':
            bg.loadGraphic(getModImage('stage/garStagebgRise'));
            addSprite(bg);

            alley.loadGraphic(getModImage('stage/garStageRise'));
            addSprite(alley);

            var corpse:FlxSprite = new FlxSprite(-230, 540, getModImage('stage/gardead'));
            corpse.antialiasing = Options.antialiasing;
            addSprite(corpse);
    }
}