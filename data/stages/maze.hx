public var bg:FunkinSprite;
var FH:Bool;

function preStageLoad() if (!FH)
    stageName += '-BS';

function create() {
    FH = songName == 'Foolhardy';
    defaultCamZoom = FH ? 0.9 : 0.7;
    dad.alpha = 0.001;

    var spr:String = FH ? 'Maze' : 'Zardy2BG';
    bg = new FunkinSprite(-600, -200, getModImage('maze/$spr'));
    bg.addAnim('idle', 'Stage', FH ? 16 : 24, true);
    bg.playAnim('idle');
    bg.scrollFactor.set(0.9, 0.9);
    bg.antialiasing = Options.antialiasing;
    addSprite(bg);
}

function onCountdown(e)
    if (e.swagCounter == 1) FlxTween.tween(dad, {alpha: 1});