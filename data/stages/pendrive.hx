introLength = 0;

var wave   = new CustomShader('pendrive/wave');
var glitch = new CustomShader('pendrive/glitch2');
var chrom  = new CustomShader('pendrive/chromAbb');
var mosaic = new CustomShader('pendrive/mosaic');

var bg:FlxSprite;
var bg2:FlxSprite;

var circle:FlxSprite;
var fog:FlxSprite;
var behind:FlxSprite;
var comp2:FlxSprite;
var desk:FlxSprite;
var comp:FlxSprite;
var frame:FlxSprite;

function create() {
    boyfriend.iconColor = 0xFF35487c;

    defaultCamZoom = .55;

    useCamMov = true;
    camMoveAmt = 25;

    bg = new FlxSprite(0, 50, getModImage('Countdown/penbg'));
    bg.antialiasing = Options.antialiasing;
    addSprite(bg);

    circle = new FlxSprite(-20, 0, getModImage('Countdown/circle'));
    circle.antialiasing = Options.antialiasing;
    addSprite(circle);

    bg2 = new FlxSprite(0, 50, getModImage('Countdown/penbg2'));
    bg2.antialiasing = Options.antialiasing;
    // addSprite(bg2);

    fog = new FlxSprite(0, 50, getModImage('Countdown/fog3'));
    fog.antialiasing = Options.antialiasing;
    fog.scale.set(2, 2);
    fog.alpha = .001;
    addSprite(fog);

    behind = new FlxSprite(-275, 75, getModImage('Countdown/bgthingreal'));
    behind.antialiasing = Options.antialiasing;
    behind.scale.set(1.25, 1.25);
    behind.updateHitbox();
    addSprite(behind);

    comp2 = new FlxSprite(-275, 75, getModImage('Countdown/compute2'));
    comp2.antialiasing = Options.antialiasing;
    comp2.scale.set(1.25, 1.25);
    comp2.updateHitbox();
    addSprite(comp2);

    desk = new FlxSprite(-275, 75, getModImage('Countdown/desk'));
    desk.antialiasing = Options.antialiasing;
    desk.scale.set(1.25, 1.25);
    desk.updateHitbox();
    addSprite(desk);

    comp = new FlxSprite(-275, 75, getModImage('Countdown/computer'));
    comp.antialiasing = Options.antialiasing;
    comp.scale.set(1.25, 1.25);
    comp.updateHitbox();
    addSprite(comp);

    frame = new FlxSprite(-275, 75, getModImage('Countdown/frame'));
    frame.antialiasing = Options.antialiasing;
    frame.scale.set(1.25, 1.25);
    frame.updateHitbox();
    addSprite(frame);
}

function postCreate() {
    iconP1.setIcon('Countdown/b1');

    wave.speed     = .0025;
    wave.intensity = 6;
    wave.bloom     = 0;

    glitch.AMT   = 0;
    glitch.SPEED = .5;

    for (huh in [wave, glitch])
        huh.iTime = .1;

    bg.shader  = wave;
    bg2.shader = wave;

    camGame.addShader(glitch);

    chrom.amount = 0;
    comp.shader = chrom;

    mosaic.pixel = .1;
    camGame.addShader(mosaic);

}

function postUpdate(elapsed:Float) {
    for (huh in [wave, glitch])
        huh.iTime = huh.iTime + elapsed;
}

function tweenMosaic(value, time, ?ease:FlxEase = FlxEase.linear, ?remove = false) {
	FlxTween.tween(mosaic, {pixel: value}, time, {ease: ease, onComplete: () -> {
		if (remove) FlxTween.num(mosaic, {pixel: .1}, .5);
    }});
}

function tweenChrom(value, time, ?ease:FlxEase = FlxEase.linear, ?remove = false) {
	FlxTween.tween(chrom, {amount: value}, time, {ease: ease, onComplete: () -> {
        if (remove) comp.shader = null;
    }});
}

function tweenGlitch(value, time, ?ease:FlxEase = FlxEase.linear,?remove = false) {
	FlxTween.tween(glitch, {AMT: value}, time, {ease: ease, onComplete: () -> {
        if (remove) glitch.AMT = 0;
    }});
}

function numbers() {
    var X:Int = FlxG.random.int(600, 1500);
    var Y:Int = FlxG.random.int(600, 1100);

	var number:FunkinText = new FunkinText(X, Y, 0, FlxG.random.int(1, 10), 120);
    number.setFormat(Paths.font('pendrive/sonic-1-hud-font.ttf'), 120, FlxColor.WHITE);
    addSprite(number);

    number.angle = FlxG.random.int(-5,5);
    number.alpha = 0;

    FlxTween.tween(number, {alpha: 1}, 1, {onComplete: () -> {
        FlxTween.tween(number, {alpha: 0}, 2, {onComplete: () -> remove(number, true) });
    }});

    FlxTween.circularMotion(number, number.x, number.y, 10, 0, FlxG.random.bool(50), 2, true);
}