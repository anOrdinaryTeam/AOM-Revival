// this code sucks
var faded:Bool = false;
var wat:Bool = false;

function create() {
    game.dad.visible = game.gf.visible = game.camHUD.visible = false;
    game.camFollow.setPosition(1200, 500);
    game.camGame.snapToTarget();
    game.persistentUpdate = true;

    game.dad.playAnim('idle');
    game.dad.animation.finishCallback = function(anim:String) {
        if (anim == 'idle') game.dad.playAnim('idle');
    }
    game.boyfriend.playAnim('idle');
    game.boyfriend.animation.finishCallback = function(anim:String) {
        if (anim == 'idle') game.boyfriend.playAnim('idle');
    }

    var ground:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Tricky/ground'));
    var wind:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Tricky/wind'));
    var cloth:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Tricky/cloth'));
    var metal:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Tricky/metal'));
    var buildUp:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Tricky/trickyIsTriggered'));

    var red:FlxSprite = new FlxSprite(-300, -120).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.fromRGB(19, 0, 0));
    red.scrollFactor.set();

    var animation:FlxSprite = new FlxSprite(-50,200);
    animation.frames = Paths.getSparrowAtlas('Tricky_Dir/stages/intro');
    animation.animation.addByPrefix('fuckyou','Symbol', 24, false);
    animation.setGraphicSize(Std.int(animation.width * 1.2));
    animation.antialiasing = Options.antialiasing;
    game.insert(game.members.indexOf(game.dad) + 1, animation);

    var nevada:FlxSprite = new FlxSprite(180, FlxG.height * 0.7 - 110);
    nevada.frames = Paths.getSparrowAtlas('Tricky_Dir/stages/somewhere');
    nevada.animation.addByPrefix('nevada', 'somewhere idfk', 24, false);
    nevada.setGraphicSize(Std.int(nevada.width * 0.5));
    nevada.antialiasing = Options.antialiasing;

    for (i in [red, nevada]) game.add(i);

    new FlxTimer().start(0.001, function(t:FlxTimer) {
        nevada.animation.play('nevada');
        new FlxTimer().start(1, function() {
            new FlxTimer().start(0.1, () -> red.alpha -= 0.1, 10);
        });
    });

    new FlxTimer().start(1, function(t:FlxTimer) {
        animation.animation.play('fuckyou');
        wind.fadeIn();

        new FlxTimer().start(2.80, () -> ground.play());
        new FlxTimer().start(3.50, () -> metal.play());

        new FlxTimer().start(5, function(t:FlxTimer) {
            game.camFollow.setPosition(game.camFollow.x - 650, game.camFollow.y + 170);
            FlxTween.tween(FlxG.camera, {zoom: 1.1}, 0.2);

            new FlxTimer().start(1.95, () -> cloth.play());
            new FlxTimer().start(3.25, () -> buildUp.fadeIn());

            new FlxTimer().start(3.60, function(t:FlxTimer) { 
                FlxG.camera.shake(0.01, 3);
                FlxG.camera.zoom = game.defaultCamZoom;

                game.camFollow.setPosition(game.camFollow.x + 100, game.camFollow.y - 50);
                game.boyfriend.playAnim('scared');

                new FlxTimer().start(1.10, function(t:FlxTimer) {
                    buildUp.fadeOut();
                    new FlxTimer().start(0.1, () -> red.alpha += 0.4, 3);

                    new FlxTimer().start(1.90, function(t:FlxTimer) {
                        new FlxTimer().start(0.3, () -> red.alpha -= 0.1, 10);
                        new FlxTimer().start(3, () -> close());

                        game.remove(animation);
                        game.camFollow.y -= 150;
                        game.camGame.snapToTarget();
                        game.boyfriend.animation.stop();
                        game.boyfriend.playAnim('idle');
                        game.dad.visible = game.gf.visible = game.camHUD.visible = true;
                    });
                });
            });
        });
    });
}