var black:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);

function postCreate() {
    black.camera = camHUD;
    black.alpha = 0;
    setObjectOrder(black, getObjectOrder(healthBar) - 1);
}

function onPsychEvent(n, v1, v2) if (n == 'BlackScreen') {
    var speed:Float = Std.parseFloat(v2);
    FlxTween.cancelTweensOf(black);
    FlxTween.tween(black, {alpha: v1 == 'on' ? 1 : 0}, speed > 0 ? speed : 0.001);
}