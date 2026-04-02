// importScript('data/scripts/TrickyLines');
graphicCache.cache(Paths.getPath('Assets-Tricky/images/stages/fourth/mech/Sign_Post_Mechanic.png'));

var signPostCam:FlxCamera = new FlxCamera();
var exSpikes:FunkinSprite;
var clones:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();

function create() {
    defaultCamZoom = 0.55;
    boyfriend.y -= 160; boyfriend.x += 350;
    dad.x -= 250; dad.y -= 365;
	gf.x += 345; gf.y -= 25;

    var bg:FlxSprite = new FlxSprite(-10, -10, getModImage('stages/fourth/bg'));
    bg.antialiasing = Options.antialiasing;
    bg.scrollFactor.set(0.9, 0.9);
    bg.setGraphicSize(Std.int(bg.width * 4));
    addSprite(bg);

    var cover:FlxSprite = new FlxSprite(-180, 755, getModImage('stages/fourth/cover'));
    cover.antialiasing = true;
    cover.scrollFactor.set(0.9, 0.9);
    cover.setGraphicSize(Std.int(cover.width * 1.55));
    
    var hole:FlxSprite = new FlxSprite(50, 530, getModImage('stages/fourth/Spawnhole_Ground_BACK'));
    hole.setGraphicSize(Std.int(hole.width * 1.55));
    hole.antialiasing = Options.antialiasing;
    hole.scrollFactor.set(0.9, 0.9);
    insert(members.indexOf(dad) - 1, hole);

    for (i in 0...2) {
        var clone:FunkinSprite = new FunkinSprite(0, dad.y + 140);
        clone.loadSprite(getModImage('stages/fourth/Clone'));
        clone.addAnim('appaer', 'Clone', 24, false);
        clone.alpha = 0.001;
        clone.antialiasing = Options.antialiasing;
        clones.add(clone);

        switch(i) {
            case 0: clone.x = dad.x - 20;
            case 1: clone.x = dad.x + 390;
        }
    }

    exSpikes = new FunkinSprite(dad.x - 70, dad.y + 170);
    exSpikes.loadSprite(getModImage('stages/fourth/FloorSpikes'));
    exSpikes.addAnim('spike','Floor Spikes', 24, false);
    exSpikes.playAnim('spike');
    exSpikes.visible = false;

    var converHole:FlxSprite = new FlxSprite(7, 578, getModImage('stages/fourth/Spawnhole_Ground_COVER'));
    converHole.antialiasing = Options.antialiasing;
    converHole.scrollFactor.set(0.9, 0.9);
    converHole.setGraphicSize(Std.int(converHole.width * 1.3));

    var energyWall:FlxSprite = new FlxSprite(1350,-690, getModImage("stages/fourth/Energywall"));
    energyWall.antialiasing = Options.antialiasing;
    energyWall.scrollFactor.set(0.9, 0.9);
    addSprite(energyWall);
                
    var stageFront:FlxSprite = new FlxSprite(-350, -355, getModImage('stages/fourth/daBackground'));
    stageFront.antialiasing = Options.antialiasing;
    stageFront.scrollFactor.set(0.9, 0.9);
    stageFront.setGraphicSize(Std.int(stageFront.width * 1.55));
    addSprite(stageFront);

    insert(members.indexOf(dad) + 1, clones);
    insert(members.indexOf(clones) + 1, cover);
    insert(members.indexOf(cover) + 1, converHole);
    insert(members.indexOf(converHole) + 1, exSpikes);
}

function postCreate() {
    signPostCam.bgColor = 0;
    FlxG.cameras.add(signPostCam, false);
}

function spawnClone(side:Int) {
    if (clones.members[side].alpha == 1) return;
    clones.members[side].alpha = 1;
    clones.members[side].playAnim('appaer');
    new FlxTimer().start(3.05, () -> clones.members[side].alpha = 0);
}

function onDadHit(_)
    if (_.direction == 2) {
        exSpikes.visible = true;
        if (exSpikes.animation.finished)
            exSpikes.playAnim('spike');
    }
    else if (!exSpikes.animation.finished) {
        exSpikes.animation.resume();
        exSpikes.animation.finishCallback = function(pog:String) {
            exSpikes.visible = false;
            exSpikes.animation.finishCallback = null;
        }
    }

function update(_)
    if (exSpikes.animation.frameIndex >= 3 && dad.animation.curAnim.name == 'singUP')
        exSpikes.animation.pause();

var lastbeat:Int = 0;
function beatHit() {
    if (curBeat % 8 == 4 && lastbeat != curBeat){
        lastbeat = curBeat;
        spawnClone(FlxG.random.int(0, 1));
    }

    if (curBeat == 532 || curBeat == 536)
        dad.playAnim('Hank', true);
}

function doStopSign(sign:Int, fuck:Bool = false) {
	var daSign:FunkinSprite = new FunkinSprite();
	daSign.loadSprite(getModImage('stages/fourth/mech/Sign_Post_Mechanic'));
	daSign.setGraphicSize(Std.int(daSign.width * 0.67));
	daSign.camera = signPostCam;

	switch(sign) {
	    case 0:
			daSign.addAnim('sign','Signature Stop Sign 1', 24, false);
			daSign.x = FlxG.width - 650;
			daSign.angle = -90;
			daSign.y = -300;
		case 2:
			daSign.addAnim('sign','Signature Stop Sign 3', 24, false);
			daSign.x = FlxG.width - 780;
			daSign.angle = -90;
			daSign.y = downscroll ? -200 : -980;
		case 3:
			daSign.addAnim('sign','Signature Stop Sign 4', 24, false);
			daSign.x = FlxG.width - 1070;
			daSign.angle = -90;
			daSign.y = -145;
	}
    add(daSign);

	daSign.flipX = fuck;
	daSign.playAnim('sign');
	daSign.animation.finishCallback = function() {
        remove(daSign);
    };
}

function stepHit() {
    switch(curStep) {
        case 384, 1218, 1567, 1917, 1927, 2193: doStopSign(0);
        case 511:
			doStopSign(2);
			doStopSign(0);
        case 720, 1184, 1600: doStopSign(2);
        case 610, 991, 1200, 1706, 2336: doStopSign(3);
        case 1235, 1584, 1923, 1932, 2036, 2258, 2326, 2604: doStopSign(0, true);
        case 1328:
            doStopSign(0, true);
            doStopSign(2);
        case 2032:
			doStopSign(2);
			doStopSign(0);
        case 2162:
			doStopSign(2);
			doStopSign(3);
        case 2304:
			doStopSign(0, true);
			doStopSign(0);
        case 2447:
			doStopSign(2);
			doStopSign(0, true);
			doStopSign(0);
        case 2512:
			doStopSign(2);
			doStopSign(0, true);
			doStopSign(0);
        case 2575:
			doStopSign(2);
			doStopSign(0, true);
			doStopSign(0);
        case 2608:
			doStopSign(0, true);
			doStopSign(0);
        case 2655:
			//doGremlin(20,13,true);
    }
}