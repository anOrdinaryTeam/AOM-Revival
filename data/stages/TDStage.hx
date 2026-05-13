var bg:FlxSprite;

function create() {
    defaultCamZoom = 0.9;

    bg = new FlxSprite().loadGraphic(getModImage('TailsBG'));
	bg.setGraphicSize(Std.int(bg.width * 1.2));
	bg.antialiasing = Options.antialiasing;
	bg.scrollFactor.set(.91, .91);
	bg.x -= 370; bg.y -= 130;
	bg.active = false;
	addSprite(bg);
}

function postCreate() {
    var stat:FunkinSprite = new FunkinSprite().loadSprite(getModImage('daSTAT'));
    stat.addAnim('idle', 'staticFLASH', 24, true);
    stat.playAnim('idle');
    stat.camera = camHUD;
    stat.alpha = 0.05;
    stat.antialiasing = Options.antialiasing;
    stat.setGraphicSize(FlxG.width, FlxG.height);
    stat.screenCenter();
    add(stat);
}

var floaty:Float = 0;
var flyX:Bool = false;
var flyY:Bool = false;

function update() {
    floaty += 0.03;

    if (flyX) {
        dad.x += Math.cos(floaty) * 1.3;
        opponentCam.x += Math.cos(floaty) * 1.3;
    }

    if (flyY) {
        dad.y += Math.sin(floaty) * 1.3;
        opponentCam.y += Math.sin(floaty) * 1.3;
    }
}

function stepHit() switch(curStep) {
    case 64: flyY = true;
    case 128: flyX = true;
}