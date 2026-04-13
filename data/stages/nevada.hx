static function modPath(str:String)
    return getModImage(str);

function create() {
    var isMadness:Bool = curSong == 'madness' ? true : false;
    var spr:String = isMadness ? 'island_but_rocks_float' : 'island_but_dumb';
    defaultCamZoom = 0.75;

    if (!isMadness) {
        var bg:FlxSprite = new FlxSprite(-405, -300, modPath('stages/red'));
        bg.antialiasing = Options.antialiasing;
        bg.scrollFactor.set(0.9, 0.9);
        addSprite(bg);
    }

    var stageFront:FlxSprite = new FlxSprite(-1100, -460, modPath('stages/' + spr));
    stageFront.setGraphicSize(Std.int(stageFront.width * 1.4));
    stageFront.antialiasing = Options.antialiasing;
    stageFront.scrollFactor.set(0.9, 0.9);
    addSprite(stageFront);

    var light = new FlxSprite(-470, -150, modPath('stages/hue'));
    light.setGraphicSize(Std.int(light.width * 0.9));
    light.updateHitbox();
    light.antialiasing = Options.antialiasing;
    light.blend = "screen";
    light.alpha = 0.7;
    light.scrollFactor.set(1.2, 1.2);
    add(light);
}