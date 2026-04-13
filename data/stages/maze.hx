public var bg:FunkinSprite;
var Foolhardy:Bool;

function create() {
    Foolhardy = songName == 'Foolhardy';
    defaultCamZoom = Foolhardy ? 0.9 : 0.7;

    var spr:String = Foolhardy ? 'Maze' : 'Zardy2BG';
    bg = new FunkinSprite(-600, -200, getModImage('maze/$spr'));
    bg.addAnim('idle', 'Stage', Foolhardy ? 16 : 24, true);
    bg.playAnim('idle');
    bg.scrollFactor.set(0.9, 0.9);
    bg.antialiasing = Options.antialiasing;
    addSprite(bg);
}

function postCreate() {
    dad.alpha = 0.001;
    setSkin(0, Foolhardy ? 'zardy' : 'zardyDark');
}

function onCountdown(e)
    if (e.swagCounter == 1) FlxTween.tween(dad, {alpha: 1});