camZooming = true;

function create() {
    defaultCamZoom = 0.6;

    var bg:FlxSprite = new FlxSprite(-600, -300, getModImage('stages/normal/normal_stage'));
    bg.antialiasing = Options.antialiasing;
    bg.scrollFactor.set(0.9, 0.9);
    addSprite(bg);

    var sumtable:FlxSprite = new FlxSprite(-600, -300, getModImage('stages/normal/sumtable'));
    sumtable.antialiasing = Options.antialiasing;
    sumtable.scrollFactor.set(0.9, 0.9);
    add(sumtable);
}

function onEvent(e) if (e.event.name == 'Camera Movement') {
    FlxTween.cancelTweensOf(defaultCamZoom);
    FlxTween.tween(this, {defaultCamZoom: e.event.params[0] == 0 ? 0.55 : 0.65}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
}