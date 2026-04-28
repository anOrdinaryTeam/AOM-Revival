var vecindad:FlxSprite;
var quicoBG:FunkinSprite;
var gfBG:FunkinSprite;
var vecindadPOV:FlxSprite;

var barTop:FlxSprite;
var barBottom:FlxSprite;

public var quico:Character;

function preStageLoad()
    useStageData = false;
function postCreate()
    // changeNoteSkin('modNotes/SuVecindad/chavo', player, 'both', false);

    loadHud('PsychEngine', '');

function create() {
    // settings shit
    defaultCamZoom = 0.7;

    boyfriend.setPosition(1100, 500);
    gf.setPosition(540, 410);
    dad.setPosition(-130, 400);

    useCamMov = true;
    camMoveAmt = 60;

    precacheCharacter(0, 'SuVecindad/chavo2');
    precacheCharacter(1, 'SuVecindad/chavobf2');
    // settings shit

    // stage shit
    vecindad = new FlxSprite(-600, 200, getModImage('SuVecindad/Vecindad'));
    vecindad.antialiasing = true;
    insert(1, vecindad);

    quicoBG = new FunkinSprite(-700, 200).loadSprite(getModImage('SuVecindad/Quico_Background'));
    quicoBG.antialiasing = true;
    quicoBG.addAnim('idle', 'Quico_Background Idle', 15, true);
    quicoBG.playAnim('idle');
    insert(2, quicoBG);

    vecindadPOV = new FlxSprite(-600, 200, getModImage('SuVecindad/VecindadPOV'));
    vecindadPOV.antialiasing = true;
    vecindadPOV.alpha = 0.001;
    insert(3, vecindadPOV);

    quico = new Character(-300, 400, 'SuVecindad/quico');
    quico.alpha = 0.001;
    add(quico);
    // stage shit

    // bars shit
    barTop = new FlxSprite(0, -100).makeSolid(FlxG.width * 2, 100, 0xFF000000);
    barTop.camera = camHUD;
    insert(4, barTop);

    barBottom = new FlxSprite(0, 900).makeSolid(FlxG.width * 2, 100, 0xFF000000);
    barBottom.camera = camHUD;
    insert(4, barBottom);
    // bars shit
}

// events go brr
function stepHit() {
    switch(curStep) {
        case 640:
            change(false);
        case 896:
            change(true);

        case 895:
            FlxTween.tween(barTop, {y: -30}, 2);
            FlxTween.tween(barBottom, {y: 650}, 2);
        case 1439:
            FlxTween.tween(barTop, {y: -100}, 2);
            FlxTween.tween(barBottom, {y: 900}, 2);
        case 1854:
            FlxTween.tween(camHUD, {alpha: 0}, 1.1);

        case 1440:
            changeCharacter(0, 'SuVecindad/chavo');

        case 1954:
            camGame.alpha = 0;
    }
}

function change(already:Bool) {
    if (!already) {
        vecindadPOV.alpha = 1;
        changeCharacter(0, 'SuVecindad/chavo2');
    } else {
        remove(vecindadPOV);

        changeCharacter(0, 'SuVecindad/chavo');
        changeCharacter(1, 'SuVecindad/chavobf2');

        quico.alpha = 1;
    }
    remove(quicoBG);
    for (i in [vecindad, boyfriend, gf])
        i.alpha = (!already ? 0.001 : 1);
}