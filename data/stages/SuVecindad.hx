var vecindad:FlxSprite;
var quicoBG:FunkinSprite;
var gfBG:FunkinSprite;
var vecindadPOV:FlxSprite;

var chavoAnim:FunkinSprite;
var quicoAnim:FunkinSprite;

var barTop:FlxSprite;
var barBottom:FlxSprite;

public var quico:Character;

var skin:String = 'modNotes/SuVecindad/chavo';
function onNoteCreation(_) {
    if (_.strumLineID == 1 && usingSkins) return;
    _.noteSprite = skin;
}

function onStrumCreation(_) {
    if (_.player == 1 && usingSkins) return;
    _.sprite = skin;
}

function preStageLoad()
    useStageData = false;
function onPlayerHit(_)
    _.ratingPrefix = 'modCombos/SuVecindad/';
function onGameOver(_) 
    _.deathCharID = 'SuVecindad/chavobf-death';
function postCreate()
    loadHud('PsychEngine', '');


var _startCam:Bool = false;
function onCameraMove(_) {
    if (_startCam != (_startCam = true)) {
        camFollow.setPosition(_.position.x, _.position.y);
        camGame.snapToTarget();
    }
}

function create() {
    defaultCamZoom = 0.7;

    boyfriend.setPosition(1100, 500);
    gf.setPosition(540, 410);
    dad.setPosition(-130, 400);

    useCamMov = true;
    camMoveAmt = 60;

    precacheCharacter(0, 'SuVecindad/chavo2');
    precacheCharacter(1, 'SuVecindad/chavobf2');

    vecindad = new FlxSprite(-600, 200, getModImage('SuVecindad/Vecindad'));
    vecindad.antialiasing = Options.antialiasing;
    addSprite(vecindad);

    quicoBG = new FunkinSprite(-700, 200).loadSprite(getModImage('SuVecindad/Quico_Background'));
    quicoBG.antialiasing = Options.antialiasing;
    quicoBG.addAnim('idle', 'Quico_Background Idle', 15, true);
    quicoBG.playAnim('idle');
    addSprite(quicoBG);

    vecindadPOV = new FlxSprite(-600, 200, getModImage('SuVecindad/VecindadPOV'));
    vecindadPOV.antialiasing = Options.antialiasing;
    vecindadPOV.alpha = 0.001;
    addSprite(vecindadPOV);

    quico = new Character(-300, 400, 'SuVecindad/quico');
    quico.antialiasing = Options.antialiasing;
    quico.alpha = 0.001;
    addSprite(quico);

    quicoAnim = new FunkinSprite(-525, 660).loadSprite(getModImage('SuVecindad/QuicoMami'));
    quicoAnim.antialiasing = Options.antialiasing;
    quicoAnim.alpha = 0.001;
    addSprite(quicoAnim);

    quicoAnim.addAnim('idle', 'QuicoMami mami0', 24, false);

    chavoAnim = new FunkinSprite(-190, 750).loadSprite(getModImage('SuVecindad/ChavoToma'));
    chavoAnim.antialiasing = Options.antialiasing;
    addSprite(chavoAnim);

    chavoAnim.flipX = true;
    chavoAnim.alpha = 0.001;

    chavoAnim.addAnim('idle', 'ChavoToma toma0', 24, false);

    barTop = new FlxSprite(0, -280).makeSolid(FlxG.width * 2, 100, 0xFF000000);
    barTop.camera = camHUD;
    addSprite(barTop);

    barBottom = new FlxSprite(0, 900).makeSolid(FlxG.width * 2, 100, 0xFF000000);
    barBottom.camera = camHUD;
    addSprite(barBottom);
}

function stepHit() {
    switch(curStep) {
        case 640:
            change(false);
        case 896:
            change(true);

        case 895:
            FlxTween.tween(barTop, {y: -30}, 4, {ease: FlxEase.quadOut});
            FlxTween.tween(barBottom, {y: 650}, 4, {ease: FlxEase.quadOut});
        case 1439:
            FlxTween.tween(barTop, {y: -280}, 4, {ease: FlxEase.quadIn});
            FlxTween.tween(barBottom, {y: 900}, 4, {ease: FlxEase.quadIn});
        case 1854:
            FlxTween.tween(camHUD, {alpha: 0}, 1.1);

        case 1758:
            dad.alpha = 0.001;
            chavoAnim.alpha = 1;

            chavoAnim.playAnim('idle');
            chavoAnim.animation.finishCallback = () -> {
                new FlxTimer().start(1, () -> {
                    remove(chavoAnim);
                    dad.alpha = 1;
                });
            };
            
        case 1764:
            remove(quico);
            quicoAnim.alpha = 1;
            quicoAnim.playAnim('idle');

        case 1440:
            changeCharacter(1, 'SuVecindad/chavobf');

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