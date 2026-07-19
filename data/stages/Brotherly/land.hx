introLength = 0;

function preStageLoad()
    useStageData = false;

if (getSaveData('customHud') == 'none')
    importScript('data/scripts/pixelate');

function postCreate() if (getSaveData('customHud') == 'none') {
    loadHud('PsychEngine');

    hudItems.members[0]?.font = Paths.font('brotherly/Super Mario Bros. 2.ttf');
    hudItems.members[0]?.scale.set(.9, .8);
    hudItems.members[0]?.borderSize = 1;

    hudItems.members[3]?.font = Paths.font('brotherly/Super Mario Bros. 2.ttf');
    hudItems.members[3]?.scale.set(.8, .6);
    hudItems.members[3]?.y -= 4;
}

function onRatingsShown(_) if (getSaveData('customHud') == 'none') {
    _.ratingPrefix = 'modCombos/Brotherly/';
    _.ratingScale = PlayState.daPixelZoom * .7;
    _.ratingAntialiasing = false;

    _.numScale = PlayState.daPixelZoom * .7;
	_.numAntialiasing = false;
}

var canBop:Bool = true;
var numBop:Int = 4;

var clothes:FunkinSprite;
function create() {
    defaultCamZoom = .4;

    boyfriend.setPosition(4450, 960);
    dad.setPosition(3000, 1000);
    

    var bland:FlxSprite = new FlxSprite(200, 200, getModImage('Brotherly/backgroundland'));
    bland.scale.set(15, 15);
    bland.updateHitbox();

    bland.antialiasing = false;
    addSprite(bland);

    var land:FlxSprite = new FlxSprite(200, 200, getModImage('Brotherly/land'));
    land.scale.set(15, 15);
    land.updateHitbox();

    land.antialiasing = false;
    addSprite(land);

    clothes = new FunkinSprite(200, 200, getModImage('Brotherly/clothes'));
    clothes.addAnim('idle', 'clothes', 12, true);
    clothes.playAnim('idle');
    clothes.scale.set(15, 15);
    clothes.updateHitbox();

    clothes.antialiasing = false;
    addSprite(clothes);
}

function beatHit() {
    switch(curBeat) {
        case 20: numBop = 1;
        case 34: canBop = false;
        case 36: canBop = true; numBop = 4;
        
        case 128 | 112: defaultCamZoom = .5;
        case 116: defaultCamZoom = .6;

        case 99: defaultCamZoom = .6; numBop = 1;
            FlxTween.tween(boyfriend, {x: boyfriend.x - 250}, .4);
            FlxTween.tween(dad,       {x: dad.x + 250},       .4);
        case 132: defaultCamZoom = .4; numBop = 4;
            FlxTween.tween(boyfriend, {x: boyfriend.x + 250}, .4);
            FlxTween.tween(dad,       {x: dad.x - 250},       .4);

        case 180: defaultCamZoom = 1;
            boyfriend.cameraOffset.x += 25;
            boyfriend.cameraOffset.y += 150;

        case 196: defaultCamZoom = .4;
    }

    if (curBeat % numBop == 0 && canBop) {
        camGame.zoom += .05 * camZoomingMult;
        camHUD.zoom  += .05 * camZoomingMult;
    }
}