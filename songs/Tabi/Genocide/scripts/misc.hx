var chromaticAberration:CustomShader = new CustomShader('ChromaticAberration');
var bright:CustomShader = new CustomShader('Bright');
var chromDanced:Bool = false;
var chromeTimer:FlxTimer;

public function setBrightness(e:Float) bright.brightness = e;
public function setContrast(e:Float) bright.contrast = e;
public function setChrome(chromeOffset:Float) {
    chromaticAberration.rOffset = chromeOffset;
    chromaticAberration.gOffset = 0.0;
    chromaticAberration.bOffset = chromeOffset * -1;
}

public function chromaticDance(tabiTurn:Bool) {
	chromeTimer?.cancel();
	chromeTimer?.destroy();
	chromeTimer = new FlxTimer().start(2, resetChromeShit2, 1);

	var mxHealth:Float = 2;
	var chromeOffset:Float = (mxHealth - (health / mxHealth)) / 1000;

	if (tabiTurn) chromeOffset *= 2;
	if (!chromDanced) setChrome(chromeOffset);
	else setChrome(0.0);
	chromDanced = !chromDanced;
}

public function resetChromeShit2(?tmr:FlxTimer) if (!paused){
	setChrome(0.0);
	chromDanced = false;
}

function create() if (Options.gameplayShaders)
    for (i in [chromaticAberration, bright]) {
        camGame.addShader(i);
        camHUD.addShader(i);
        trace('shaders added');
    }

function update(_) if (Options.gameplayShaders) {
    setBrightness(((health / 2) - 1 < 0) ? 0 : (((health / 2) - 1) * 2) / 32);
    setContrast(((health / 2) - 1 < 0) ? 1 : 1 + ((health / 2) - 1) / 8);
}

function onDadHit(e) chromaticDance(true);
function onPlayerHit(e) chromaticDance(false);