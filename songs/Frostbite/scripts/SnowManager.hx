var SnowShader:FunkinShader;
var SnowLayer:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();

// Parameters for Low Setting
var xOffset = {start: 1600, end: -200};
var yOffset = {start: -200, end: 900};

var speedX = {min: 1.4, max: 4};
var speedY = {min: 1.8, max: 3.7};

var scale = {min: 0.8, max: 2};
var ease:FlxEase = FlxEase.quadInOut;

public var SnowMethod:Int = 0; // 0 = Low | 1 = High

function create() {
    if (SnowMethod == 1 && Options.gameplayShaders) {
        SnowShader = FunkinShader.fromFile(Paths.fragShader('snowfall'));
        camOther.addShader(SnowShader);
    }
    else if (SnowMethod == 0) {
        SnowLayer.camera = camOther;
        add(SnowLayer);
        addSnowAmount(75);
    }
}

function update() {
    if (SnowMethod == 1 && SnowShader != null) {
        var time:Float = Conductor.songPosition / (Conductor.stepCrochet * 8);
        SnowShader.time = time;
    }
}

public function addSnowAmount(amount:Int) {
    // Low
    if (SnowMethod == 0) for (i in 0...amount) {
        var randomSnow:Int = FlxG.random.int(1, 20);
        var randomScale:Float = FlxG.random.float(scale.min, scale.max);
        var randomStart:Float = FlxG.random.float(xOffset.end, xOffset.start);

        var spr:FlxSprite = new FlxSprite(randomStart, yOffset.start, FrostPath('SnowShit/$randomSnow'));
        spr.antialiasing = Options.antialiasing;
        spr.scale.set(randomScale, randomScale);
        spr.updateHitbox();
        spr.color = 0xEAEEFD;
        SnowLayer.add(spr);

        if (spr != null) {
            var randomSpeedX:Float = FlxG.random.float(speedX.min, speedX.max);
            var randomSpeedY:Float = FlxG.random.float(speedY.min, speedY.max);

            FlxTween.tween(spr, {x: xOffset.end}, randomSpeedX, {ease: ease, type: 2});
            FlxTween.tween(spr, {y: yOffset.end}, randomSpeedY, {ease: ease, type: 2});
        }
    }
}