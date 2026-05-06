var traffic:FunkinSprite;
function create() {
    traffic = new FunkinSprite(-430, -250).loadSprite(getImage('modCountdowns/Kapi/traffic'));
    traffic.camera = camHUD;

    traffic.addAnim('idle', 'idle', 8, false);
    traffic.addAnim('red', 'red', 8, false);
    traffic.addAnim('yellow', 'yellow', 8, false);
    traffic.addAnim('green', 'green', 8, false);
    traffic.addAnim('go', 'go', 8, false);
    traffic.playAnim('idle');

    add(traffic);
}

var start:Bool = false;
function onStartCountdown(_) {
    if (!start) { _.cancel();
        playSound('Kapi/start');
        if (curSong == 'hairball') {
            camHUD.alpha = 0;
            new FlxTimer().start(.1, () -> {
                dad.playAnim('intro');
                playModSound('brokenpad');
            });
            new FlxTimer().start(1.8, () -> {
                FlxTween.tween(camHUD, {alpha: 1}, 0.5);
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
            traffic.playAnim('red');
        case 1:
            _.soundPath = 'Kapi/count';
            traffic.playAnim('yellow');
        case 2:
            _.soundPath = 'Kapi/count';
            traffic.playAnim('green');
        case 3:
            _.soundPath = 'Kapi/go';
            traffic.playAnim('go');
            new FlxTimer().start(1, () -> FlxTween.tween(traffic, {alpha: 0}, 1, {onComplete: () -> remove(traffic, true)}));
    }
}

function onPostCountdown(_)
    remove(_.sprite, true);