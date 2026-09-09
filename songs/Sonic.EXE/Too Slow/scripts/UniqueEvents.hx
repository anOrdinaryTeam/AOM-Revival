var flashJumpscare:FlxSprite = new FlxSprite();
var sonicJumpscare:FunkinSprite = new FunkinSprite();
var daStatic:FunkinSprite = new FunkinSprite();

function postCreate() {
    flashJumpscare.loadGraphic(loadSpr('Jumpscares/simplejump'));
    flashJumpscare.camera = camOther;
    flashJumpscare.setGraphicSize(FlxG.width, FlxG.height);
	flashJumpscare.screenCenter();
    flashJumpscare.alpha = 0.0001;
    add(flashJumpscare);

	daStatic.loadSprite(loadSpr('daSTAT'));
    daStatic.addAnim('static', 'staticFLASH', 24, false);
    daStatic.playAnim('static');
	daStatic.animation.finishCallback = (_) -> daStatic.visible = false;
    daStatic.camera = camOther;
    daStatic.setGraphicSize(FlxG.width, FlxG.height);
    daStatic.screenCenter();
    daStatic.alpha = 0.0001;
    add(daStatic);

	sonicJumpscare.loadSprite(loadSpr('Jumpscares/sonicJUMPSCARE'));
	sonicJumpscare.addAnim('jump', 'sonicSPOOK', 24, false);
	sonicJumpscare.playAnim('jump');
	sonicJumpscare.screenCenter();
	sonicJumpscare.scale.set(1.1, 1.1);
	sonicJumpscare.y += 370;
	sonicJumpscare.camera = camOther;
	sonicJumpscare.alpha = 0.0001;
	add(sonicJumpscare);
}

static function simpleJumpscare() {
    if (flashJumpscare.alpha == 0.0001) flashJumpscare.alpha = 1;
    flashJumpscare.visible = true;
    new FlxTimer().start(0.2, (_) -> flashJumpscare.visible = false);

    daStatic.visible = true;
    daStatic.playAnim('static');
    daStatic.alpha = FlxG.random.float(0.1, 0.5);

    playModSound('sppok');
    playModSound('staticBUZZ');
}

static function singleStatic() {
    daStatic.visible = true;
    daStatic.playAnim('static');
    daStatic.alpha = FlxG.random.float(0.1, 0.5);
    playModSound('staticBUZZ');
}

static function Jumpscare() {
	sonicJumpscare.alpha = 1;
    sonicJumpscare.playAnim('jump');
	playModSound('exeJump');
	playModSound('datOneSound');
}

function stepHit() {
    switch(curStep) {
        case 921, 1178, 1337: simpleJumpscare();
		case 1723: Jumpscare();
		case 27, 130, 265, 450, 645, 800, 855, 889, 938, 981,
			1030, 1065, 1105, 1123, 1245, 1345, 1432, 1454, 1495,
			1521, 1558, 1578, 1599, 1618, 1647, 1657, 1692, 1713,
			1738, 1747, 1761, 1785, 1806, 1816, 1832, 1849, 1868,
			1887, 1909: singleStatic();
    }
}