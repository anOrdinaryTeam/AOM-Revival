var start:Bool = false;
function onStartCountdown(_) {
    camHUD.alpha = 0;
    if (!start) { _.cancel();
        playSound('Kapi/start');
        if (curSong == 'hairball') {
            new FlxTimer().start(.1, () -> {
                dad.playAnim('intro');
                playModSound('brokenpad');
            });
            new FlxTimer().start(1.8, () -> {
                start = true;
                startCountdown();
            });
        }
        else {
            new FlxTimer().start(.8, () -> {
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