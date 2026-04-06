var transition:FunkinSprite = new FunkinSprite();
var screaming:Bool = false;

function postCreate() {
    precacheCharacter(0, 'eteled_crazy');

    transition.loadSprite(getModImage('effects/glitchAnim'));
    transition.addAnim('play', 'g', 24, false);
    transition.camera = camHUD;
    transition.scale.set(2, 2);
    transition.alpha = 0.001;
    insert(1, transition);

    camZooming = true;
}

function beatHit() switch(curBeat) {
    case 111:
        doTrans();
        switchStage(true);
    case 143:
        doTrans();
        switchStage(false);
        cleanGlitchedBGS();
}

function stepHit() switch(curStep) {
    case 696:
        screaming = true;
        camGame.followLerp = 0.2;

        dad.playAnim('scream', true);
        defaultCamZoom += 0.4;
        opponentCam.x -= 250;
    case 704:
        screaming = false;
        camGame.followLerp = 0.04;

        opponentCam.x += 250;
        defaultCamZoom -= 0.4;
}

function onDadHit(e)
	e.animCancelled = screaming;

function switchStage(bool:Bool) {
    startGlitchedBGS = bool;
    hallway.alpha = bool ? 1 : 0;
    mainBG.alpha = miibuttons.alpha = overlay.alpha = bool ? 0 : 1;
    changeCharacter(0, bool ? 'eteled_crazy' : 'eteled_mad');
    gf.color = bool ? 0x0F6C6B6B : -1;
}

function doTrans() {
    transition.alpha = 1;
    transition.playAnim('play');
    playModSound('Glitch-Transition-Sound-Effect', 0.6);
    new FlxTimer().start(0.6, () -> transition.alpha = 0);
}