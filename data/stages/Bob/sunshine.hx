function create() {
    var prefix:String = songName == 'Sunshine-bob' ? 'happy' : 'withered';

    var bg:FlxSprite = new FlxSprite(-100).loadGraphic(getModImage('$prefix/sky'));
	bg.antialiasing = Options.antialiasing;
	bg.scrollFactor.set(0.1, 0.1);
	addSprite(bg);
	
	var ground:FlxSprite = new FlxSprite(-537, -158, getModImage('$prefix/ground'));
	ground.antialiasing = Options.antialiasing;
	addSprite(ground);
}