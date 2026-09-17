var Distort:FunkinShader;
var distortIntensity:Float;
var vals = [4.5, 7];

function postCreate() if (Options.gameplayShaders) {
    Distort = FunkinShader.fromFile(Paths.fragShader('Distort'));
    Distort.negativity = 0.0;
    Distort._active = false;
    boyfriend.shader = Distort;
}

function beatHit() if (Distort != null && curBeat % 2 == 0 && FlxG.random.bool(30))
    Distort._active = !Distort._active;

function stepHit() if (Distort != null)
    distortIntensity = FlxG.random.float(vals[0], vals[1]);

function update() if (Distort != null)
    Distort.binaryIntensity = distortIntensity;