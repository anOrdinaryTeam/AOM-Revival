var screamer:FlxSprite;
var timer:FlxTimer = new FlxTimer();

function postCreate() {
    screamer = new FlxSprite(120, 0, SprPath('dropimages/image3'));
    screamer.antialiasing = Options.antialiasing;
    screamer.scale.set(2.7, 2.7);
    screamer.updateHitbox();
    screamer.camera = camHUD;
    screamer.alpha = 0.001;
    add(screamer);
}

function onPsychEvent(n, v1, v2) if (n == 'TinkyScreamer') {
    screamer.alpha = 1;
    timer?.cancel();
    timer.start(0.05, () -> screamer.alpha = 0);
}