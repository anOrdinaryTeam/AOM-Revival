var layer:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var enabled:Bool = false;
var last:Int = 0;

function postCreate() {
    layer.camera = camHUD;
    add(layer);

    for (i in 1...6) {
        var spr:FlxSprite = new FlxSprite(120, 0, SprPath('dropimages/image$i'));
        spr.antialiasing = Options.antialiasing;
        spr.scale.set(2.7, 2.7);
        spr.updateHitbox();
        spr.alpha = 0.001;
        layer.add(spr);
    }
}

function onPsychEvent(n, v1) if (n == 'Screamers') {
    enabled = v1 == 'on' ? true : false;
    if (!enabled) layer.forEachAlive(n -> n.alpha = 0);
}

function beatHit() if (enabled) {
    var newImg:Int = last;
    while(newImg == last)
        newImg = FlxG.random.int(0, 4);

    last = newImg;
    layer.forEachAlive(n -> n.alpha = 0);
    layer.members[last].alpha = 0.3;
}