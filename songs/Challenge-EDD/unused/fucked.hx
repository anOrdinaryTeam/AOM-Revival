var tordMecha:FunkinSprite;
var mattTord:FunkinSprite;
var eddTord:FunkinSprite;
var bfTord:FunkinSprite;
var tomRush:FunkinSprite;
var tomHarpoon:FunkinSprite;

var bfDude:FlxSprite;
var glass:FlxSprite;
var tordBG:FlxSprite;

var should:String = '';

var camOTHER:FlxCamera = new FlxCamera();
function postCreate() {
    camOTHER.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(camOTHER, false);
    FlxG.cameras.setOrder([camGame, camOTHER, camHUD]);
}

function create() {
    for (f in ['bf-tord', 'edd-tord', 'matt-tord', 'tomRunsIn', 'tordBot', 'tordGlass', 'tordBG', 'tordHelicopter', 'tordFlails', 'bf-lookup'])
        { graphicCache.cache(getModImage('Challenge-EDD/fucked/$f')); }
    precacheCharacter(0, 'tord'); precacheCharacter(1, 'bf_fucked');
}

function onCameraMove(_) {
    if (!_.cancelled) {
        if (should == 'WHATHEFUK') { _.position.set(950, 450); }
        else if (should == 'dawg_tord') { _.position.set(925, -750); }
    }
}

function stepHit() {
    switch(curStep) {
        case 917: should = 'WHATHEFUK';
        case 920: FlxG.camera.shake(0.005, 5.75);
        case 930: tordEntrance();
        case 1026: tordCabine(false);

        case 1135, 1407, 1631, 1760:
            FlxTween.tween(edd, {x: -65, y: 370}, 0.5, {ease: FlxEase.quadInOut});
        case 1200, 1472, 1660, 1856:
            FlxTween.tween(edd, {x: -565, y: 770}, 1, {ease: FlxEase.quadInOut});
        case 1263, 1535, 1695, 1919:
            FlxTween.tween(bf, {x: 835, y: 290}, 0.5, {ease: FlxEase.quadInOut});
        case 1328, 1608, 1728, 1993:
            FlxTween.tween(bf, {x: 1235, y: 790}, 1, {ease: FlxEase.quadInOut});

        case 2017: tordCabine(true);
        case 2033:
            tordMecha.playAnim('blow');
            tordMecha.animation.finishCallback = function(name:String) {
                if (name == 'blow') remove(tordMecha);
            }
    }
}
function tordEntrance() {
    remove(door);
    remove(matt);
    remove(gf); insert(6, gf);

    for (t in [boyfriend, dad])
        t.alpha = 0;

    tordMecha = new FunkinSprite(595, 50).loadSprite(getModImage('Challenge-EDD/fucked/tordBot'));
    tordMecha.antialiasing = true;
    tordMecha.scale.set(1.5, 1.5);

    tordMecha.addAnim('idle', 'TordBotIdle', 12, true);
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
    insert(10, mattTord);
    
    eddTord = new FunkinSprite(190, 195).loadSprite(getModImage('Challenge-EDD/fucked/edd-tord'));
    eddTord.antialiasing = true;

    eddTord.addAnim('shaking', 'EddGroundShaking', 12, false);
    eddTord.addAnim('tord', 'EddTurnToTord', 12, false);
    eddTord.addAnim('lookLoop', 'EddLookingUp', 12, false, false, [1]);
    eddTord.addAnim('look', 'EddLookingUp', 12, false);

    eddTord.playAnim('shaking');
    insert(11, eddTord);

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

    new FlxTimer().start(0.6, () -> {
        tomRush = new FunkinSprite(1315, 425).loadSprite(getModImage('Challenge-EDD/fucked/tomRUnsIn'));
        tomRush.antialiasing = true;
        tomRush.scale.set(1.7, 1.7);

        tomRush.addAnim('run', 'Tom Running In', 12, false);
        tomRush.playAnim('run');
        insert(10, tomRush);
    });
}

function tordCabine(already:Bool) {
    if (!already)
    {
        should = 'dawg_tord';
        for (t in [boyfriend, dad])
            t.alpha = 1;

        tordBG = new FlxSprite(-330, -360, getModImage('Challenge-EDD/fucked/tordBG'));
        tordBG.camera = camOTHER;
        insert(1, tordBG);
        
        changeCharacter(0, 'tord');
        dad.setPosition(-50, -35);
        dad.camera = camOTHER;
        
        glass = new FlxSprite(0, -100, getModImage('Challenge-EDD/fucked/tordGlass'));
        glass.camera = camHUD;
        add(glass);

        FlxTween.tween(glass.scale, {x: 20, y: 20}, 0.75, {ease: FlxEase.quadInOut});
        FlxTween.tween(glass, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut});

        changeCharacter(1, 'bf_fucked');
        bf.setPosition(1235, 790);
        bf.camera = camOTHER;

        edd = new Character(-565, 770, "edd_fucked");
        edd.camera = camOTHER;
        add(edd);
    }
    else
    {
        FlxTween.tween(glass, {alpha: 0.8}, 0.3, {ease: FlxEase.quadInOut});
        FlxTween.tween(glass.scale, {x: 10, y: 10}, 0.3, {ease: FlxEase.quadInOut});

        new FlxTimer().start(0.28, () -> {
            dad.alpha = 0; remove(glass); remove(tordBG);
        });
        
        tordFall();
    }
}

function tordFall() {
    for (t in [boyfriend, bfTord, tomRush])
        t.alpha = 0;
    
    tordMecha.x -= 250; tordMecha.y -= 550;
    tordMecha.playAnim('harp');

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