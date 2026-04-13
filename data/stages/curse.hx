camZooming = true;

function create() {
    defaultCamZoom = 0.6;

    var bg:FlxSprite = new FlxSprite(-600, -300, getModPath('stages/normal/normal_stage'));
    bg.antialiasing = Options.antialiasing;
    bg.scrollFactor.set(0.9, 0.9);
    addSprite(bg);

    var sumtable:FlxSprite = new FlxSprite(-600, -300, getModPath('stages/normal/sumtable'));
    sumtable.antialiasing = Options.antialiasing;
    sumtable.scrollFactor.set(0.9, 0.9);
    add(sumtable);
}

function onEvent(e) if (e.event.name == 'Camera Movement')
    if (e.event.params[0] == 0) FlxTween.tween(this, {defaultCamZoom: 0.55}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
    else if (e.event.params[0] == 1) FlxTween.tween(this, {defaultCamZoom: 0.65}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});