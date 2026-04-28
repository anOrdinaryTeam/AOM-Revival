importScript('data/scripts/FatalErrorPopUp');

function onEvent(_) if (_.event.name == 'Camera Movement')
    if (_.event.params[0] == 0) defaultCamZoom = 0.5;
    else if (_.event.params[0] == 1) defaultCamZoom = 0.75;

var launchBase:FunkinSprite = new FunkinSprite(-200, 100);
var launchBaseCorrupted:FunkinSprite = new FunkinSprite(100, 200);
var glitchedCrowd:FunkinSprite = new FunkinSprite(100, 200);
PauseSubState.script = 'data/scripts/ReziseWindow';

function create() {
    defaultCamZoom = 0.5;

    dad.x -= 550;
	dad.y += 40;
	boyfriend.y += 140;

    launchBase.loadSprite(getModImage('Fatality/launchbase'));
    launchBase.animation.addByIndices('base', 'idle', [0, 1, 2, 3, 4, 5, 6, 8, 9], "", 12, true);
    launchBase.playAnim('base');
    launchBase.scale.x = 5;
	launchBase.scale.y = 5;
    launchBase.scrollFactor.set(1, 1);
    addSprite(launchBase);
    launchBase.antialiasing = false;

    launchBaseCorrupted.loadSprite(getModImage('Fatality/domain2'));
    launchBaseCorrupted.animation.addByIndices('theand', 'idle', [0, 1, 2, 3, 4, 5, 6, 8, 9], "", 12, true);
    launchBaseCorrupted.playAnim('theand');
    launchBaseCorrupted.scale.x = 4;
	launchBaseCorrupted.scale.y = 4;
    addSprite(launchBaseCorrupted);
    launchBaseCorrupted.antialiasing = false;
    launchBaseCorrupted.scrollFactor.set(1, 1);
    launchBaseCorrupted.visible = false;

    glitchedCrowd.loadSprite(getModImage('Fatality/domain'));
    glitchedCrowd.animation.addByIndices('begin', 'idle', [0, 1, 2, 3, 4], "", 12, true);
    glitchedCrowd.playAnim('begin');
    glitchedCrowd.scale.x = 4;
	glitchedCrowd.scale.y = 4;
    addSprite(glitchedCrowd);
    glitchedCrowd.antialiasing = false;
    glitchedCrowd.scrollFactor.set(1, 1);
    glitchedCrowd.visible = false;

    graphicCache.cache(getModImage('Fatality/statix'));
}

function stepHit() switch(curStep) {
    case 255, 1983:
		var daStatic = new FunkinSprite(0,0, getModImage('Fatality/statix'));
        daStatic.addAnim('a', 'statixx', 24, false);
        daStatic.playAnim('a', true);
        daStatic.screenCenter();
        daStatic.setGraphicSize(FlxG.width, FlxG.height);
        daStatic.camera = camHUD;
        add(daStatic);

        playModSound('staticBUZZ');
        new FlxTimer().start(0.20, () -> remove(daStatic));
        case 256:
		launchBase.visible = false;
		launchBaseCorrupted.visible = true;
		glitchedCrowd.visible = true;
}

function onSongEnd() {
    windowShit(1280, 720);
    window.resizable = true;
}