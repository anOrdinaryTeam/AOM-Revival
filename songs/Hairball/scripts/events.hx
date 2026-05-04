var start:Bool = false;
function onStartCountdown(_) {
    if (!start) {
        _.cancel();

        camHUD.alpha = 0.001;
        new FlxTimer().start(0.1, () -> {
            dad.playAnim('intro');
            playModSound('brokenpad');
        });

        new FlxTimer().start(2, () -> {
            start = true;
            startCountdown();
            FlxTween.tween(camHUD, {alpha: 1}, 1);
        });
    }
}