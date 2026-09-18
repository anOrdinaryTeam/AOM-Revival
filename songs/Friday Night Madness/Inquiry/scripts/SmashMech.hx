var spr:FunkinSprite;
var bg:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.fromString('#FF0000'));
var sound:FlxSound = FlxG.sound.load(getModSoundPath('glitchloop'));

var totalToSmash:Int = 0;

function postCreate() {
    var layer:FlxCamera = new FlxCamera();
    layer.bgColor = 0;
    FlxG.cameras.add(layer, false);

    sound.volume = 0.9;
    sound.looped = true;

    bg.alpha = 0.001;
    bg.camera = layer;
    add(bg);

    spr = new FunkinSprite(0, 0,getModImage('space'));
    spr.addAnim('press', 'space', 24, true);
    spr.antialiasing = Options.antialiasing;
    spr.camera = layer;
    spr.scale.set(0.9, 0.9);
    spr.updateHitbox();
    spr.screenCenter();
    spr.alpha = 0.001;
    add(spr);
}

public function initSmashing()
{
    sound.play();
    totalToSmash = 10;

    spr.alpha = 1;
    spr.playAnim('press');

    FlxTween.tween(bg, {alpha: 1}, 3);
}

function endSmashing()
{
    sound.stop();
    spr.alpha = 0;
    spr.animation.stop();

    FlxTween.cancelTweensOf(bg);
    FlxTween.tween(bg, {alpha: 0}, 0.3);
    FlxTween.tween(spr, {alpha: 0}, 0.3);
}

function update() if ((bg != null && spr != null && sound != null) && totalToSmash >= 1) {
    health -= 0.002;

    if (FlxG.keys.justPressed.SPACE) totalToSmash--;
    if (totalToSmash <= 0) endSmashing();
}