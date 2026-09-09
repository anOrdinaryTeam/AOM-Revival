var tinky:FlxSprite;
var timer:FlxTimer = new FlxTimer();

function postCreate() {
    tinky = new FlxSprite(650, 350, SprPath('tinky'));
    tinky.antialiasing = Options.antialiasing;
    tinky.scale.set(0.01, 0.01);
    tinky.camera = camHUD;
    tinky.alpha = 0.001;
    add(tinky);
}

function onPsychEvent(n, v1) if (n == 'Tinky' && v1 == 'on') {
    tinky.alpha = 1;
    FlxTween.cancelTweensOf(tinky);
    FlxTween.tween(tinky.scale, {x: 6, y: 6}, 0.6, {ease: FlxEase.quintIn});

    timer?.cancel();
    timer.start(0.58, () -> {
        tinky.scale.set(0.01, 0.01);
        tinky.alpha = 0.001;
    });
}