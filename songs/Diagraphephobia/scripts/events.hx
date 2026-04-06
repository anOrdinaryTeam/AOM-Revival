var transition:FunkinSprite = new FunkinSprite();

function postCreate() {
    precacheCharacter(0, 'eteled_crazy');

    transition.loadSprite(getModImage('effects/glitchAnim'));
    transition.addAnim('play', 'g', 24, false);
    transition.camera = camHUD;
    transition.scale.set(2, 2);
    transition.alpha = 0.001;
    insert(1, transition);
}

function beatHit() switch(curBeat) {
    case 111:
        doTrans();
        switchStage(true);
    case 142:
        doTrans();
        switchStage(false);
        cleanGlitchedBGS();
}

function stepHit() switch(curStep) {
    case 731:
        defaultCamZoom += 0.4;
    case 739:
        defaultCamZoom -= 0.4;
}

function switchStage(bool:Bool) {
    startGlitchedBGS = bool;
    hallway.alpha = bool ? 1 : 0;
    mainBG.alpha = miibuttons.alpha = overlay.alpha = bool ? 0 : 1;
    changeCharacter(0, bool ? 'eteled_crazy' : 'eteled_mad');
}

function doTrans() {
    transition.alpha = 1;
    transition.playAnim('play');
    playModSound('Glitch-Transition-Sound-Effect', 0.6);
    new FlxTimer().start(0.6, () -> transition.alpha = 0);
}