var tordMecha:FunkinSprite;
var mattTord:FunkinSprite;
var eddTord:FunkinSprite;
var bfTord:FunkinSprite;
var tomRush:FunkinSprite;
var tomHarpoon:FunkinSprite;

var bfDude:FlxSprite;
var glass:FlxSprite;
var tordBG:FlxSprite;

var should:Bool = false;

var camOTHER:FlxCamera = new FlxCamera();
function postCreate() {
    camOTHER.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(camOTHER, false);
    FlxG.cameras.setOrder([camGame, camOTHER, camHUD]);
}

function create() {
    for (f in ['bf-tord', 'edd-tord', 'matt-tord', 'tomRunsIn', 'tordBot', 'tordGlass', 'tordBG', 'tordHelicopter', 'tordFlails', 'bf-lookup'])
        { graphicCache.cache(getModImage('Challenge-EDD/fucked/$f')); }
    precacheCharacter(0, 'tord');
    // tordCabine();
}

function onCameraMove(_) {
    if (should && !_.cancelled)
        _.position.set(950, 450);
}

function stepHit() {
    switch(curStep) {
        case 917: should = true;
        case 920: FlxG.camera.shake(0.005, 5.75);
        case 930: tordEntrance();
        case 1026: tordCabine();
        case 2015: tordFall();
    }
}

function tordEntrance() {
    remove(matt);
    remove(gf); insert(6, gf);

    for (t in [boyfriend, dad])
        t.alpha = 0;

    tordMecha = new FunkinSprite(595, 50).loadSprite(getModImage('Challenge-EDD/fucked/tordBot'));
    tordMecha.antialiasing = true;
    tordMecha.scale.set(1.5, 1.5);

    tordMecha.addAnim('idle', 'mattReactionTord', 12, true);
    tordMecha.addAnim('harp', 'TordBotHarpoonIdle', 12, true);
    tordMecha.addAnim('blow', 'TordBotBlowingUp', 12, false);
    
    tordMecha.playAnim('idle');
    insert(4, tordMecha);

    FlxTween.tween(tordMecha, {y: -725}, 5);

    mattTord = new FunkinSprite(115, 240).loadSprite(getModImage('Challenge-EDD/fucked/matt-tord'));
    mattTord.antialiasing = true;
    mattTord.scale.set(1.7, 1.7);

    mattTord.addAnim('dafuk', 'mattReactionTord', 12, false);
    mattTord.addAnim('look', 'mattLookUp', 12, false);
    mattTord.addAnim('fiu', 'mattHarpoonBit', 12, false);
    
    mattTord.playAnim('dafuk');
    insert(9, mattTord);
    
    eddTord = new FunkinSprite(190, 195).loadSprite(getModImage('Challenge-EDD/fucked/edd-tord'));
    eddTord.antialiasing = true;

    eddTord.addAnim('shaking', 'EddGroundShaking', 12, false);
    eddTord.addAnim('tord', 'EddTurnToTord', 12, false);
    eddTord.addAnim('lookLoop', 'EddLookingUp', 12, false, false, [1]);
    eddTord.addAnim('look', 'EddLookingUp', 12, false);

    eddTord.playAnim('shaking');
    insert(10, eddTord);

    bfTord = new FunkinSprite(1160, 450).loadSprite(getModImage('Challenge-EDD/fucked/bf-tord'));
    bfTord.antialiasing = true;

    bfTord.addAnim('shaking', 'BF Ground Shaking', 12, false);
    bfTord.addAnim('tord', 'BF Look At Tord', 12, false);
    
    bfTord.playAnim('shaking');
    insert(9, bfTord);

    new FlxTimer().start(1.5, () -> {
        eddTord.y += 30;
        eddTord.playAnim('tord');

        bfTord.x += 10; bfTord.y -= 8;
        bfTord.playAnim('tord');
    });

    new FlxTimer().start(1, () -> {
        tomRush = new FunkinSprite(1315, 425).loadSprite(getModImage('Challenge-EDD/fucked/tomRUnsIn'));
        tomRush.antialiasing = true;
        tomRush.scale.set(1.7, 1.7);

        tomRush.addAnim('run', 'Tom Running In', 12, false);
        tomRush.playAnim('run');
        insert(10, tomRush);
    });
}

function tordCabine() {
    for (t in [boyfriend, dad])
        t.alpha = 1;

    tordBG = new FlxSprite(-330, -360, getModImage('Challenge-EDD/fucked/tordBG'));
    tordBG.camera = camOTHER;
    insert(1, tordBG);
    
    changeCharacter(0, 'tord');
    dad.setPosition(-50, -35);
    dad.camera = camOTHER;
    
    glass = new FlxSprite(0, -100, getModImage('Challenge-EDD/fucked/tordGlass'));
    glass.camera = camOTHER;
    add(glass);

    FlxTween.tween(glass.scale, {x: 20, y: 20}, 0.75, {ease: FlxEase.quadOut}, {onComplete: function() {
        remove(glass);
    }});
    FlxTween.tween(glass, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
}

function tordFall() {
    for (t in [boyfriend, dad, bfTord, tomRush])
        t.alpha = 0;
    
    eddTord.x += 135;
    eddTord.playAnim('lookLoop');

    mattTord.y += 40;
    mattTord.playAnim('look');
    new FlxTimer().start(6, () -> mattTord.playAnim('fiu'));

    bfDude = new FlxSprite(1220, 450, getModImage('Challenge-EDD/fucked/bf-lookup'));
    bfDude.antialiasing = true;
    insert(9, bfDude);

    tomHarpoon = new FunkinSprite(765, 365).loadSprite(getModImage('Challenge-EDD/fucked/tomHarpoon'));
    tomHarpoon.antialiasing = true;
    tomHarpoon.addAnim('idle', 'TomHarpoonIdle', 12, false);
    tomHarpoon.addAnim('line', 'TomHarpoonLine', 12, false);
    tomHarpoon.addAnim('harpLoop', 'TomHarpoonHarpoon', 24, true);
    tomHarpoon.addAnim('harp', 'TomHarpoonHarpoon', 24, false);
    
    tomHarpoon.playAnim('idle');
    insert(10, tomHarpoon);

    new FlxTimer().start(5, () -> {
        tomHarpoon.playAnim('line');
        eddTord.playAnim('look');
    });

    tomHarpoon.animation.finishCallback = function(name:String) {
        if (name == 'line') tomHarpoon.playAnim('harpLoop');
    }
    new FlxTimer().start(6.5, () -> tomHarpoon.playAnim('harp'));
}