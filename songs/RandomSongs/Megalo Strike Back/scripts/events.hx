var oppStrumsOffsets:Array<Float> = [];
var playerStrumsOffsets:Array<Float> = [];

var ogX_player:Float = 0;
var ogX_camPlayer:Float = 0;

var ogX_cpu:Float = 0;
var ogX_camCpu:Float = 0;

var black:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
var swaped:Bool = false;

function postCreate() {
    for (i in 0...4) {
        oppStrumsOffsets.push(cpu.members[i].x);
        playerStrumsOffsets.push(player.members[i].x);
    }

    dad.animation.finishCallback = (Anim) -> {
        if (Anim == 'saveStart') dad.playAnim('saveLoop', true);
        if (Anim == 'saveEnd') dad.dance();
    }

    ogX_player = boyfriend.x;
    ogX_camPlayer = playerCam.x;

    ogX_cpu = dad.x;
    ogX_camCpu = opponentCam.x;

    black.scrollFactor.set();
    black.camera = camHUD;
    black.alpha = 0.001;
    add(black);
}

function stepHit() switch(curStep) {
    case 928: scrollSpeed += 0.5;
    case 1168: dad.playAnim('saveStart', true);
    case 1225: dad.playAnim('saveEnd', true);
    case 2020:
        defaultCamZoom += 0.3;
        dad.playAnim('look', true);
        camGame.shake(0.01, 6.35);
    case 2078:
        defaultCamZoom -= 0.3;
        dad.dance();
    case 2053, 2276: swap();
    case 2357: FlxTween.tween(black, {alpha: 1}, 1);
    case 2380:
        defaultCamZoom += 0.5;
        camHUD.alpha = 0;
        camGame.shake(0.01, 6.40);

        opponentCam.x -= 200;
        dad.playAnim('look', true);
    case 2403:
        camGame.alpha = 0;
        camHUD.alpha = 1;
}

function swap() {
    swaped = !swaped;
    var bfStrums:Array<Float> = swaped ? oppStrumsOffsets.copy() : playerStrumsOffsets.copy();
    var charaStrums:Array<Float> = swaped ? playerStrumsOffsets.copy() : oppStrumsOffsets.copy();

    for (i in 0...4) {
        cpu.members[i].x = charaStrums[i];
        player.members[i].x = bfStrums[i];
    }
    camGame.flash(-1, 0.5);

    playerCam.x = swaped ? ogX_camCpu : ogX_camPlayer;
    boyfriend.x = swaped ? ogX_cpu : ogX_player;
    boyfriend.swapLeftRightAnimations();
    boyfriend.flipX = swaped;

    opponentCam.x = swaped ? ogX_camPlayer : ogX_camCpu;
    dad.x = swaped ? ogX_player : ogX_cpu;
    dad.swapLeftRightAnimations();
    dad.flipX = swaped;
}