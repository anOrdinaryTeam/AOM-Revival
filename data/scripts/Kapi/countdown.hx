var start:Bool = false;
function onStartCountdown(_) {
    if (!start) {
        _.cancel();
        camHUD.alpha = 0.001;
        playSound('Kapi/start');
        if (curSong == 'hairball') {
            new FlxTimer().start(0.1, () -> {
                dad.playAnim('intro');
                playModSound('brokenpad');
            });
            new FlxTimer().start(2, () -> {
            start = true;
            startCountdown();
            });
        }
        else {
            new FlxTimer().start(1, () -> {
                start = true;
                startCountdown();
            });
        }
    }
}

function onCountdown(_) {
    switch(_.swagCounter) {
        case 0:
            _.soundPath = 'Kapi/count';
        case 1:
            _.soundPath = 'Kapi/count';
        case 2:
            _.soundPath = 'Kapi/count';
        case 3:
            _.soundPath = 'Kapi/go';
            FlxTween.tween(camHUD, {alpha: 1}, 0.25);
    }
}

function onPostCountdown(_) {
    // remove(_.sprite, true);
}