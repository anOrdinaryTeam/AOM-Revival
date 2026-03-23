var bg:FunkinSprite;
var Foolhardy:Bool;

function create() {
    Foolhardy = songName == 'Foolhardy';
    camFollow.setPosition(740, 600);

    defaultCamZoom = Foolhardy ? 0.9 : 0.7;

    if (Foolhardy) {
        gf.y += 140;
        boyfriend.x += 80;
        boyfriend.y += 140;
    }
    else {
        boyfriend.x += 80;
        boyfriend.y += 140;
    }

    var spr:String = Foolhardy ? 'Maze' : 'Zardy2BG';
    bg = new FunkinSprite(-600, -200, getModImage('maze/$spr'));
    bg.addAnim('idle', 'Stage', Foolhardy ? 16 : 24, true);
    bg.playAnim('idle');
    bg.scrollFactor.set(0.9, 0.9);
    bg.antialiasing = Options.antialiasing;
    addSprite(bg);
}

function postCreate() {
    dad.alpha = 0.001;
    setSkin(0, Foolhardy ? 'zardy' : 'zardyDark');
}

function onCountdown(e)
    if (e.swagCounter == 1) FlxTween.tween(dad, {alpha: 1});

function stepHit()
    if (Foolhardy)
        if (curStep == 2427) {
            camGame.shake(0.025, 0.2);
            for (i in [dad, iconP2]) FlxTween.tween(i, {alpha: 0.8}, 0.4);
            bg.animation.curAnim.frameRate = 20;
        }
        else if (curStep == 2943)
            for (i in [dad, iconP2]) FlxTween.tween(i, {alpha: 0}, 0.4);