var SnowShader:FunkinShader;
var SnowLayer:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
public var SnowMethod:Int = getSaveData('Frostbite_SnowHQ') ? 1 : 0; // 0 = Low | 1 = High

function create() {
    if (SnowMethod == 1 && Options.gameplayShaders) {
        SnowShader = FunkinShader.fromFile(Paths.fragShader('snowfall'));
        SnowShader.intensity = 0.0;
        camOther.addShader(SnowShader);
    }
    else if (SnowMethod == 0) {
        SnowLayer.camera = camOther;
        add(SnowLayer);
    }
}

function update(dt:Float) {
    if (SnowMethod == 1 && SnowShader != null) {
        var time:Float = Conductor.songPosition / (Conductor.stepCrochet * 8);
        SnowShader.time = time;
    }
}

public function addSnowAmount(amount:Int, timestep:Float) {
    var realTime:Float = (timestep * Conductor.stepCrochet) / 1000;
    
    if (SnowMethod == 0 && SnowLayer != null) {
        // Low
        new FlxTimer().start(realTime, () -> {
            var randomSnow:Int = FlxG.random.int(1, 10);
            var spr:SnowFlake = new SnowFlake(randomSnow);
            SnowLayer.add(spr);
        }, amount);
    }
    else if (SnowMethod == 1 && SnowShader != null) {
        // High
        FlxTween.tween(SnowShader, {amount: amount}, realTime);
    }
}

public function setIntensity(intensity:Float, time:Float) {
    var realTime:Float = (time * Conductor.stepCrochet) / 1000;
    trace('Changing Intensity to: $intensity in time: $realTime');

    if (SnowMethod == 0 && SnowLayer != null) for (snow in SnowLayer) {
        FlxTween.cancelTweensOf(snow);
        FlxTween.tween(snow, {intensity: intensity}, realTime);
    }
    else if (SnowMethod == 1 && SnowShader != null) {
        FlxTween.cancelTweensOf(SnowShader);
        FlxTween.tween(SnowShader, {intensity: intensity}, realTime);
    }
}

class SnowFlake extends FunkinSprite
{
    var speedX = {min: 1.4, max: 4};
    var speedY = {min: 1.8, max: 3.7};

    var amplitude = {min: 1, max: 15};
    var frequency = {min: 0.01, max: 0.05};

    var alphas = {min: 0.8, max: 1};
    var scales = {min: 0.6, max: 2.5};

    var xOffset = {start: 1600, end: -200};
    var yOffset = {start: -200, end: 900};

    public var intensity:Float = 1.0;
    var time:Float = 0;

    var currentSpeedX:Float = 0;
    var currentSpeedY:Float = 0;
    var currentAmplitude:Float = 0;
    var currentFrequency:Float = 0;

    public function new(Anim:Int):Void {
        super(0, 0, FrostPath('snow2'));
        this.addAnim('snow', Anim, 0, false);
        this.playAnim('snow', true);
        this.antialiasing = Options.antialiasing;
        this.color = 0xDBE2FA;
        this.restartSnow();
    }

    public function restartSnow():Void
    {
        var randomScale:Float = FlxG.random.float(scales.min, scales.max);
        var randomStart:Float = FlxG.random.float(xOffset.end, xOffset.start);
        var randomAlpha:Float = FlxG.random.float(alphas.min, alphas.max);
        var randomSpeedX:Float = FlxG.random.float(speedX.min, speedX.max);
        var randomSpeedY:Float = FlxG.random.float(speedY.min, speedY.max);
        var randomAmplitude:Float = FlxG.random.float(amplitude.min, amplitude.max);
        var randomFrequency:Float = FlxG.random.float(frequency.min, frequency.max);

        this.setPosition(randomStart, yOffset.start);
        this.scale.set(randomScale, randomScale);
        this.updateHitbox();
        this.alpha = randomAlpha;

        this.currentSpeedX = randomSpeedX;
        this.currentSpeedY = randomSpeedY;
        this.currentAmplitude = randomAmplitude;
        this.currentFrequency = randomFrequency;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        this.time += elapsed;
        this.y += currentSpeedY * (1.5 + intensity);
        this.x += (-currentSpeedX * (0.5 + intensity)) + FlxMath.fastSin(time / currentFrequency) * (currentAmplitude * intensity) * elapsed;

        if (this.y >= yOffset.end)
            this.restartSnow();

    }
}