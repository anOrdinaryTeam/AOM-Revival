function preStageLoad() if (songName == 'Relighted')
    stageName += '-gaster';

function create() {
    defaultCamZoom = 0.75;

    var bg:FlxSprite = new FlxSprite(-600, -200, getModPath('Overwrite/bg'));
    bg.antialiasing = Options.antialiasing;
    bg.scrollFactor.set(0.9, 0.9);
    addSprite(bg);

    if (curSong == 'overwrite') {
        gf.x += -80; gf.y-= 80;
        gf.scale.set(0.8, 0.8);
        boyfriend.x += 200; boyfriend.cameraOffset.x -= 100;
        dad.x -= 100; dad.y += 200;

        for (i in 0...7){
            var sqr:FlxSprite = new FlxSprite(-600 + 400 * i, -200, getModPath('Overwrite/square'));
            sqr.antialiasing = Options.antialiasing;
            sqr.scrollFactor.set(1.2, 1.2);
            addSprite(sqr);
            FlxTween.tween(sqr, {y: sqr.y + 200}, (Math.random() * 5 + 1) / 3, {ease: FlxEase.quadInOut, type: 4, loopDelay: Math.random() / 2});
        }
    }
    else {
        gf.scale.set(0.4, 0.4);
        gf.x -= 55; gf.y -= 180;

        boyfriend.scale.set(0.8,0.8);
        boyfriend.x += 200; boyfriend.y += 90;

        dad.x -= 400; dad.y -= 50;
        trace(gf.getPosition());

        for (i in 0...7){
            var sqr:FunkinSprite = new FunkinSprite(-790 + 400 * i, 240 + [300, 175, 75, 0, 0, 75, 175, 300][i]);
            sqr.loadSprite(getModPath('Overwrite/rpgfire'));
            sqr.addAnim('idle', 'fire_iddle', 24, true);
            sqr.playAnim("idle");
            sqr.antialiasing = Options.antialiasing;
            sqr.scrollFactor.set(0.93, 0.93);            
            sqr.scale.set(0.6 * [1.2, 1.1, 1.05, 1, 1, 1.05, 1.1, 1.2][i], 0.6 * [1.2, 1.1, 1.05, 1, 1, 1.05, 1.1, 1.2][i]);
            addSprite(sqr);
        }
    }

    var lg:FlxSprite = new FlxSprite(-600, -200, getModPath('Overwrite/light'));
    lg.antialiasing = Options.antialiasing;
    lg.scrollFactor.set(0.9, 0.9);
    add(lg);
    FlxTween.tween(lg, {alpha:0.4}, 2, {ease: FlxEase.quadInOut, type: FlxTween.PINGPONG, loopDelay: 0.5});
}