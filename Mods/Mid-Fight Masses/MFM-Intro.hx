function create() {
    var isGospel:Bool = PlayState.SONG.meta.name == 'Gospel';
    var introCamPos:Array<Int> = isGospel ? [750, 0] : [750, -200];
    var introZoom:Float = 1.5;
    game.persistentUpdate = true;
    game.camFollow.setPosition(introCamPos[0], introCamPos[1]);
    FlxG.camera.snapToTarget();

    FlxTween.tween(FlxG.camera, {zoom: introZoom}, 0.001);
    FlxTween.tween(FlxG.camera, {zoom: game.defaultCamZoom}, 1.7, {ease: FlxEase.sineInOut, startDelay: 0.1});

    new FlxTimer().start(2, close);
}