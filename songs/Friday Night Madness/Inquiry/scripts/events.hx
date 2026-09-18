function stepHit(e) switch(e) {
    // mech
    case 26, 300, 424, 493, 521, 572, 817, 914, 1035:
        initSmashing();
    // flips cam
    case 798, 876, 1040, 1162:
        flipCamera();

    case 728: FlxTween.tween(blackGame, {alpha: 1}, 3, {ease: FlxEase.smoothStepIn});
    case 755: blackHud.alpha = 0.7;
    case 775: scrapJumpscare.playAnim('boo', true);
    case 784:
        defaultCamZoom = 0.609;
        bg.loadGraphic(getModImage('Prison/fondo_scaface'));
        for (newStage in stageBroken) newStage.alpha = 1;
        
        remove(blackGame, true);
        remove(blackHud, true);
}

var flipped:Bool = false;
function flipCamera() {
    FlxTween.tween(camGame, {angle: flipped ? 0 : 180}, 0.4);
    flipped = !flipped;
}