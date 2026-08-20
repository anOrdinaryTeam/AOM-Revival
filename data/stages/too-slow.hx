importScript('data/scripts/PsychHold');
defaultCamZoom = 0.65;
doIconBop = false;

var zoomBoost:Bool = false;
var gainHealth:Bool = false;

function bgPath(str:String):String
    return getModImage('TSE/$str');

function addBG(spr:Dynamic) if (spr != null) {
    spr.antialiasing = Options.antialiasing;
    addSprite(spr);
}

function onNoteCreation(_)
    _.note.splash = 'EXE/blood';

function onPlayerHit(e) if (!gainHealth)
    e.healthGain = 0;

function onDadHit(e) if (gainHealth && health >= 0.4)
    e.healthGain = 0.015;

function create() {
    useCamMov = true;
    dad.animation.onFrameChange.add((Anim) -> if (Anim == 'Getcha') dad.scale.set(0.9, 0.9));

    var sky:FlxSprite = new FlxSprite(-600, -200, bgPath('BGSky'));
	sky.setGraphicSize(Std.int(sky.width * 1.4));
	addBG(sky);

    var midTrees:FunkinSprite = new FunkinSprite(-600, -200, bgPath('TreesMidBack'));
    midTrees.addAnim('i', 'sprite', 0, false);
    midTrees.playAnim('i', true);
    midTrees.scrollFactor.set(0.7, 0.7);
	midTrees.setGraphicSize(Std.int(midTrees.width * 1.4));
	addBG(midTrees);

    var treesmid:FunkinSprite = new FunkinSprite(-600, -200, bgPath('TreesMid'));
    treesmid.addAnim('i', 'sprite', 0, false);
    treesmid.playAnim('i', true);
    treesmid.scrollFactor.set(0.7, 0.7);
    addBG(treesmid);

    for (i in ['1', '2']) {
        var trees1:FunkinSprite = new FunkinSprite(-600, -200, bgPath('TreesOuterMid1'));
        trees1.addAnim(i, 'tree$i', 0, false);
        trees1.playAnim(i, true);
        trees1.scrollFactor.set(0.7, 0.7);
		trees1.setGraphicSize(Std.int(trees1.width * 1.4));
		addBG(trees1);
    }

    for (i in ['1', '2']) {
        var trees2:FunkinSprite = new FunkinSprite(-600, -200, bgPath('TreesOuterMid2'));
        trees2.addAnim(i, 'tree$i', 0, false);
        trees2.playAnim(i, true);
        trees2.scrollFactor.set(0.7, 0.7);
		trees2.setGraphicSize(Std.int(trees2.width * 1.4));
		addBG(trees2);
    }

    for (i in ['1', '2']) {
        var sideTree:FunkinSprite = new FunkinSprite(-600, -200, bgPath('trees'));
        sideTree.addAnim(i, 'Trees$i', 0, false);
        sideTree.playAnim(i, true);
        sideTree.scrollFactor.set(0.7, 0.7);
		sideTree.setGraphicSize(Std.int(sideTree.width * 1.4));
		addBG(sideTree);
    }

    var outerbush:FlxSprite = new FlxSprite(-600, -150, bgPath('OuterBush'));
    outerbush.setGraphicSize(Std.int(outerbush.width * 1.4));
	addBG(outerbush);

    var outerbush2:FlxSprite = new FlxSprite(-600, -200, bgPath('OuterBushUp'));
	outerbush2.setGraphicSize(Std.int(outerbush2.width * 1.4));
	addBG(outerbush2);

    var grass:FlxSprite = new FlxSprite(-600, -150, bgPath('Grass'));
	grass.setGraphicSize(Std.int(grass.width * 1.4));
	addBG(grass);
}

function postCreate()
    loadHud('PsychEngine');

function postHudLoad() if (hudItems != null)
    hudItems.members[2].createFilledBar(FlxColor.BLACK, FlxColor.RED);

function stepHit() switch(curStep) {
    case 415, 687, 751, 1055: zoomBoost = true;
    case 675, 736: zoomBoost = false;

    case 384: camGame.alpha = 0;
    case 400:
        camGame.alpha = 1;
        defaultCamZoom = 0.9;
    case 416:
        defaultCamZoom = 0.65;
        doIconBop = true;
        gainHealth = true;
    case 928:
        defaultCamZoom = 1.0;
        zoomBoost = false;

        dad.playAnim('Getcha', true);
        FlxTween.tween(camHUD, {alpha: 0}, 0.7);
        FlxTween.tween(FlxG.camera, {zoom: 1.0}, 0.7);
    case 1039:
        defaultCamZoom = 0.65;

        FlxTween.tween(camHUD, {alpha: 1}, 1.4);
        FlxTween.tween(FlxG.camera, {zoom: 0.65}, 1.4);
    case 1056: dad.scale.set(1, 1);
    case 1504: FlxTween.tween(this, {scrollSpeed: scrollSpeed + 0.2}, 0.4, {ease: FlxEase.quadInOut});
    case 1888:
        zoomBoost = false;
        doIconBop = false;
}

function beatHit() if (zoomBoost && curBeat % 1 == 0) {
    // too hard
	FlxG.camera.zoom += (0.06 / 2);
	camHUD.zoom += (0.08 / 2);
}