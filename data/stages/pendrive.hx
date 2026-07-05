introLength = 0;

var iTimeShaders:Array<FlxRuntimeShader> = [];
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

var wave = new CustomShader('pendrive/wave');
function postCreate() {
    iconP1.setIcon('Countdown/b1');

    wave.speed = 0.0025;
    wave.intensity = 6;
    wave.bloom = 0;
    wave.iTime = .1;

    bg.shader = wave;
    bg2.shader = wave;
}

function postUpdate(elapsed:Float) {
    wave.iTime = wave.iTime + elapsed;
}