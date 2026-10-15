var didTweenOut:Bool = false;
var didFadeFlash:Bool = false;
var didRoar:Bool = false;
var didRoarShake:Bool = false;
var didRoarOut:Bool = false;
var stoppedBopping:Bool = false;
var secondCorruptRoar:Bool = false;

var corruptroBlackCover:FlxSprite = new FlxSprite().makeSolid(1280*3, 720*3, FlxColor.BLACK);

function fire() {
    var flames:FunkinSprite = stageSprites.get('flames');
    if (backgroundLevel > 1 && flames?.alpha == HIDDEN) {
        flames?.y -= 1000;
        flames?.alpha = 1;
    }
}

function mainTrans() if (backgroundLevel > 1) {
    var crack:FunkinSprite = stageSprites.get('crack');
    crack?.playAnim('appear');

    if (flashingLights) {
        var bgFlash:FlxSprite = stageSprites.get('bgFlash');
        bgFlash?.alpha = 1;
        if (bgFlash != null) FlxTween.tween(bgFlash, {alpha: 0}, 1);

        var vortex:FlxSprite = stageSprites.get('vortex');
        vortex?.alpha = 1;

        for (crystal in crystals) {
            crystal?.alpha = 1;
            crystal?.y -= 1500;
        }
    }
}

function scaleRocks() if (backgroundLevel > 0) {
    var rocks:FunkinSprite = stageSprites.get('rocks');
    var rocksLeft:FunkinSprite = stageSprites.get('rocksLeft');
    
    if (rocks?.scale.x == 1) {
        rocks?.scale.x += .1;
        rocks?.scale.y += .1;

        rocksLeft?.scale.x += .1;
        rocksLeft?.scale.y += .1;
    }
}

function postCreate() {
    useCamMov = true;
    camMoveAmt = 30;

    corruptroBlackCover.screenCenter();
    corruptroBlackCover.scrollFactor.set(0, 0);
    add(corruptroBlackCover);
}

function update() {
    if (!didTweenOut && !startingSong) {
        FlxTween.tween(corruptroBlackCover, {alpha: 0.4}, 13);
        didTweenOut = true;
    }

    if (!didFadeFlash && curBeat >= 36) {
        FlxTween.cancelTweensOf(corruptroBlackCover);
        corruptroBlackCover.alpha = 0;
        camGame.flash(-1, 0.5, true);
        didFadeFlash = true;
    }

    if (!didRoar && curBeat >= 216) {
        defaultCamZoom += .2;
        didRoar = true;
    }

    if (!didRoarShake && curStep >= 216*4 + 1) {
        camGame.shake(0.01, 8);
        didRoarShake = true;
    }

    if (curBeat >= 216 && curBeat < 228)
        setCamPos((opponentCam.x - 400), (opponentCam.y + 40));
}

function postUpdate() if (!didRoarOut && curBeat >= 228) {
    defaultCamZoom -= .2;
    FlxG.camera.zoom = defaultCamZoom;
    forceCamPos = false;
    didRoarOut = true;
}

public function StageTransform()
{
    mainTrans();
	fire();
	scaleRocks();
}

function beatHit(beat) {
    if (beat >= 616 && beat <= 808) {
        camGame.zoom += 0.03;
        camHUD.zoom += 0.03;
    }

    if (!stoppedBopping && curBeat >= 808) {
        camZooming = false;
        stoppedBopping = true;
    }
}

function stepHit(step) if (!secondCorruptRoar && step >= 1824) {
    healthDrainPoison *= 1.1;
    secondCorruptRoar = true;
}