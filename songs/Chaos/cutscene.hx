function create() {
	var fred:FlxSprite = new FlxSprite(-30, 100).makeSolid(FlxG.width * 1.5, FlxG.height * 1.6, FlxColor.BLACK);
	add(fred);

	game.persistentUpdate = true;

	new FlxTimer().start(0.5, () -> {
		FlxTween.tween(fred, {alpha: 0}, 0.5, {onComplete: () -> remove(fred)});

		new FlxTimer().start(1, () -> {
			FlxTween.tween(FlxG.camera, {zoom: 1.5}, 3, {ease: FlxEase.cubeOut});
			FlxG.camera.flash(FlxColor.RED, 0.2);
			playModSound('robot');
		});

		new FlxTimer().start(2, () -> {
			chamber.playAnim('a', true);
			playModSound('sonic');
		});

		new FlxTimer().start(6, close);
	});
}