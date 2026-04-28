public var camOther:FlxCamera = new FlxCamera();
public function loadSpr(str:String) return getModImage(str);

function create() {
    useCamMov = true;
    defaultCamZoom = 1.0;
    camGame.followLerp = 0.05;

    camOther.bgColor = 0;
    FlxG.cameras.add(camOther, false);

    boyfriend.y += 25;
    boyfriend.cameraOffset.x -= 100; boyfriend.cameraOffset.y -= 25;
    boyfriend.scrollFactor.set(1.37, 1);

    dad.setPosition(120, 220);
    dad.scrollFactor.set(1.37, 1);
	
    gf.scrollFactor.set(1.37, 1); // tf

    camFollow.setPosition(600, 500);

    var sSKY:FlxSprite = new FlxSprite(-222, -16 + 150, loadSpr('sonicStage/SKY'));
    addSprite(sSKY);

    for (i in 0...8) {
        var hill:FunkinSprite = new FunkinSprite(-264, -156 + 150, loadSpr('sonicStage/grass'));
        hill.addAnim('idle', ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight'][i], 0, false);
        hill.playAnim('idle');
        hill.scrollFactor.set(1.1, 1);
        addSprite(hill);
    }

    if (!Options.lowMemoryMode) {
        var bg2:FlxSprite = new FlxSprite(-345, -289 + 170, loadSpr('sonicStage/FLOOR2'));
        bg2.scrollFactor.set(1.2, 1);
        addSprite(bg2);
    }

    var bg:FlxSprite = new FlxSprite(-297, -246 + 150, loadSpr('sonicStage/FLOOR1'));
    bg.scrollFactor.set(1.3, 1);
    addSprite(bg);

    for (i in 0...3) {
        var spr:FunkinSprite = new FunkinSprite();
        spr.loadSprite(loadSpr('sonicStage/stage'));
        spr.addAnim('idle', ['one', 'two', 'three'][i], 0, false);
        spr.playAnim('idle');
        switch(i) {
            case 0: // knuckles
                spr.setPosition(185 + 100, -350 + 150);
                spr.scrollFactor.set(1.36, 1);
            case 1: // eggman
                spr.setPosition(-218, -219 + 150);
                spr.scrollFactor.set(1.32, 1);
            case 2: // tails
                spr.setPosition(-199 - 150, -259 + 150);
                spr.scrollFactor.set(1.34, 1);
        }
        addSprite(spr);
    }

    var sticklol:FunkinSprite = new FunkinSprite(-100, 50);
    if (Options.lowMemoryMode) sticklol.loadSprite(loadSpr('sonicStage/TailsSpikeUnamited'));
    else {
        sticklol.loadSprite(loadSpr('sonicStage/TailsSpikeAnimated'));
        sticklol.addAnim('idle', 'Tails Spike Animated instance 1', 4, true);
        sticklol.playAnim('idle');
    }
    sticklol.setGraphicSize(Std.int(sticklol.width * 1.2));
	sticklol.updateHitbox();
    sticklol.scrollFactor.set(1.37, 1);
    addSprite(sticklol);
}

function stepHit() switch(curStep){
    case 764:
        // shakeCam[0] = true;
        FlxG.camera.flash(FlxColor.RED, 4);
    // case 791: shakeCam[0] = false;
    case 1305:
        FlxTween.tween(camHUD, {alpha: 0}, 0.3);
        dad.playAnim('Get Ya', true);
        vocals.volume = 1; // just in case.
    case 1362:
        FlxG.camera.shake(0.002, 0.6);
		camHUD.shake(0.002, 0.6);
    case 1432:
        FlxTween.tween(camHUD, {alpha: 1}, 0.3);
        dad.dance();
}