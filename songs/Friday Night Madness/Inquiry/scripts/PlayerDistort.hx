var Distort:FunkinShader;
var distortIntensity:Float;

function postCreate() if (Options.gameplayShaders) {
    Distort = FunkinShader.fromFile(Paths.fragShader('Distort'));
    Distort.negativity = 0.0;
    Distort.active = false;
    boyfriend.shader = Distort;
}

function beatHit() if (Distort != null && curBeat % 4 == 0) {
    Distort.active = FlxG.random.bool(20);
    trace(Distort.active);
}

function stepHit() if (Distort != null)
    distortIntensity = FlxG.random.float(5, 6);

function update() if (Distort != null)
    Distort.binaryIntensity = distortIntensity;