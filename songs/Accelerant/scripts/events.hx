camZooming = true;

function stepHit() switch(curStep) {
    case 20:
        FlxTween.tween(this, {defaultCamZoom: 0.75}, 0.2);
        playModSound('hankready', 0.6);
        dad.playAnim('ready', true);
        opponentCam.x -= 80;
        opponentCam.y += 20;
    case 31:
        tweenZoom(0.7, 0.15);
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
            FlxTween.tween(opponentCam, {y: opponentCam.y + 30}, 0.8);
            FlxTween.tween(playerCam, {y: playerCam.y + 30}, 0.8);
        });
    case 662:
        dad.idleSuffix = '-alt';
        tricky.alpha = 1;
        tricky.playAnim('entrance', true);
        FlxTween.tween(gfArmsUp, {x: gfArmsUp.x + 2000}, 0.2);

        camGame.followLerp = 0.2;
        tweenZoom(0.85, 0.1);
        setCamPos(camFollow.x - 120, camFollow.y - 160);

        curLaserPoint = 40;
        laser.x = 690;
    case 736:
        camGame.followLerp = 0.04;
        tricky.playAnim('scream', true);
        tweenZoom(0.7, 2);
        FlxTween.tween(camFollow, {x: camFollow.x + 120, y: camFollow.y + 160}, 2);
        new FlxTimer().start(2, () -> forceCamPos = false);
    case 928:
        tricky.playAnim('turn', true, "LOCK");
        camGame.followLerp = 0.2;
        setCamPos(camFollow.x - 120, camFollow.y - 160);

    case 936:
        playModSound('Hayyyyy');
        tricky.playAnim('getShot', true);
        FlxTween.tween(tricky, {y: tricky.y - 500}, 0.5, {ease: FlxEase.quadInOut, onComplete: () -> {
            setObjectOrder(tricky, getObjectOrder(floor));
            FlxTween.tween(tricky, {y: tricky.y + 2000}, 1, {ease: FlxEase.quadInOut});
        }});

        dad.playAnim('shot', true);
        dad.idleSuffix = '';
        camGame.followLerp = 0.04;
        FlxTween.tween(camFollow, {x: camFollow.x + 120, y: camFollow.y + 160}, 2);
        new FlxTimer().start(2, () -> forceCamPos = false);
    case 1012:
        gfHotdog.playAnim('walk');
        FlxTween.tween(gfHotdog, {x: 1120}, 2.5, {onComplete: gfHotdog.dance});

    case 959, 1264:
        if (curDiff == 'hard')
            canGruntsSpawn = !canGruntsSpawn;
        else
            hellClownShows();
    
    case 722:
        if (curDiff == 'fucked')
            lever.playAnim('idle');
    case 1136:
        if (curDiff == 'fucked')
            lever.playAnim('idleR');
}

function tweenZoom(target:Float, time:Float) {
    var to:Float = target;
    FlxTween.tween(FlxG.camera, {zoom: to}, time, {onComplete: () -> defaultCamZoom = to});
}