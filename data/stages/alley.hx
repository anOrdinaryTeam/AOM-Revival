using StringTools;

function preStageLoad() if (songName.startsWith('Ballistic'))
    stageName += '-ballistic';

function postCreate() {
    loadHud('KadeEngine', '1.4.2');

    if (songName.startsWith('Ballistic')) {
        var overlay:FlxSprite = new FlxSprite().loadGraphic(getModImage('thefunnyeffect'));
        overlay.antialiasing = Options.antialiasing;
        overlay.setGraphicSize(FlxG.width, FlxG.height);
        overlay.updateHitbox();
        overlay.screenCenter();
        overlay.camera = camHUD;
        overlay.alpha = 0.8;
        add(overlay);

        FlxTween.tween(overlay, {alpha: 0.3}, 2, {ease: FlxEase.quadInOut, type: 4});
    }
}

function create() {
    defaultCamZoom = 0.9;

    if (songName.startsWith('Ballistic')) {
        gf.playAnim('Scared', true);

        var bg:FunkinSprite = new FunkinSprite(-600, -200, getModImage('BallisticBackground'));
        bg.addAnim('idle', 'Background Whitty Moving', 16, true);
        bg.playAnim('idle');
        bg.antialiasing = Options.antialiasing;
        bg.scrollFactor.set(0.9, 0.9);
        addSprite(bg);
    }
    else {
        var bg:FlxSprite = new FlxSprite(-500, -300, getModImage('whittyBack'));
        bg.antialiasing = Options.antialiasing;
        bg.scrollFactor.set(0.9, 0.9);
        addSprite(bg);

        var floor:FlxSprite = new FlxSprite(-650, 600, getModImage('whittyFront'));
        floor.setGraphicSize(Std.int(floor.width * 1.1));
        floor.updateHitbox();
        floor.antialiasing = Options.antialiasing;
        floor.scrollFactor.set(0.9, 0.9);
        addSprite(floor);
    }
}

