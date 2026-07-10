var prefix:String = getSaveData('Bob_happy') ? 'hell_happy' : 'hell';

var bobSfx:FlxSound;
var bobScreenBG:FlxSprite;
var bobScreen:FlxSprite = new FlxSprite();

function bobStage(str:String)
    return getModImage('$prefix/$str');

function create() {
    var bg:FlxSprite = new FlxSprite(-100).loadGraphic(bobStage('hell'));
	bg.antialiasing = Options.antialiasing;
	bg.scrollFactor.set(0.1, 0.1);
	addSprite(bg);

    var thingidk:FlxSprite = new FlxSprite(-271).loadGraphic(bobStage('middlething'));
	thingidk.antialiasing = Options.antialiasing;
	thingidk.scrollFactor.set(0.3, 0.3);
	addSprite(thingidk);

    var dead:FlxSprite = new FlxSprite(-60, 50).loadGraphic(bobStage('theydead'));
	dead.antialiasing = Options.antialiasing;
	dead.scrollFactor.set(0.8, 0.8);
	addSprite(dead);

    var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(bobStage('ground'));
	ground.antialiasing = true;
	addSprite(ground);
}

function postCreate() {
    bobScreenBG = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
    bobScreenBG.scrollFactor.set();
    bobScreenBG.camera = camHUD;
    bobScreenBG.alpha = 0.001;
    add(bobScreenBG);

    bobScreen.loadGraphic(bobStage('bobscreen'));
    bobScreen.antialiasing = Options.antialiasing;
    bobScreen.camera = camHUD;
    bobScreen.setGraphicSize(FlxG.width, FlxG.height);
    bobScreen.updateHitbox();
    bobScreen.screenCenter();
    bobScreen.alpha = 0.001;
    add(bobScreen);

    bobSfx = FlxG.sound.load(getModSoundPath('bobscreen'));
}

public function bobMad() {
    bobScreenBG.alpha = bobScreen.alpha = 1;
    FlxTween.shake(bobScreen, 0.05, 0.5);
    bobSfx.play();

    new FlxTimer().start(0.5, () -> {
        bobScreenBG.alpha = bobScreen.alpha = 0;
        bobSfx.stop();
    });
}