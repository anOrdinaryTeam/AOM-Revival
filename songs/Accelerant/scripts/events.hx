camZooming = true;

function stepHit() switch(curStep) {
    case 20:
        FlxTween.tween(this, {defaultCamZoom: 0.75}, 0.2);
        playModSound('hankready', 0.6);
        dad.playAnim('ready', true);
        opponentCam.x -= 80;
        opponentCam.y += 20;
    case 31:
        // defaultCamZoom = 0.7;
        FlxTween.tween(FlxG.camera, {zoom: 0.7}, 0.15, {onComplete: () -> defaultCamZoom = 0.7});
        opponentCam.x += 80;
        opponentCam.y -= 20;

        new FlxTimer().start(1, () ->{
            FlxTween.tween(helicopter, {x: 3000}, 8);
        });
    case 289:
        FlxTween.tween(opponentCam, {y: opponentCam.y - 110}, 0.6);
        FlxTween.tween(playerCam, {y: playerCam.y - 110}, 0.6);
        
        new FlxTimer().start(0.6, () -> {
            sanford.alpha = deimos.alpha = 1;
            sanford.playAnim('entering', true);
            deimos.playAnim('entering', true);
        });

        new FlxTimer().start(0.9, () -> {
            FlxTween.tween(opponentCam, {y: opponentCam.y + 30}, 0.6);
            FlxTween.tween(playerCam, {y: playerCam.y + 30}, 0.6);
        });
}