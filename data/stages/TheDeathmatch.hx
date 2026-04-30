function onNoteCreation(_)
    _.noteSprite = 'modNotes/TheDeathmatch/death notes';
function onStrumCreation(_)
    _.sprite = 'modNotes/TheDeathmatch/death notes';
function preStageLoad()
    useStageData = false;

function postCreate() {
    loadHud('PsychEngine', '');
    setRatingPrefix('TheDeathmatch');
    healthBarBG.loadGraphic(getModImage('TheDeathmatch/healthBar'));
}

public var kworld:FunkinSprite;
public var world:FunkinSprite;
public var bpeople:FunkinSprite;
public var fpeople:FunkinSprite;

function create() {
    // settings shit
    importScript('songs/The Deathmatch/$curDiff.hx');

    defaultCamZoom = 0.9;
    gf.alpha = 0;

    for (d in ['dearest2', 'dearest3', 'dearest4'])
        { precacheCharacter(0, 'TheDeathmatch/$d'); }
    for (b in ['pico-death', 'bf-deathmatch', 'kids-death', 'mom-death'])
        { precacheCharacter(1, 'TheDeathmatch/$b'); }
    // settings shit

    // stage shit
    kworld = new FunkinSprite(-50, -50).loadSprite(getModImage('TheDeathmatch/TheWorldKids'));
    kworld.scale.set(1.8, 1.8);
    kworld.alpha = 0.001;
    
    kworld.addAnim('idle', 'Eyes', 24, true);
    kworld.playAnim('idle');
    insert(0, kworld);

    world = new FunkinSprite(-50, -50).loadSprite(getModImage('TheDeathmatch/TheWorld'));
    world.scale.set(1.8, 1.8);
    world.alpha = 0.001;
    
    world.addAnim('idle', 'nokids', 24, true);
    world.playAnim('idle');
    insert(0, world);

    var wall:FlxSprite = new FlxSprite(-1100, -575, getModImage('TheDeathmatch/stagewall'));
    insert(2, wall);

    var stage:FlxSprite = new FlxSprite(-1100, 725, getModImage('TheDeathmatch/stage'));
    stage.scale.set(1.2, 1.2);
    insert(3, stage);

    var mics:FlxSprite = new FlxSprite(125, 625, getModImage('TheDeathmatch/mics'));
    insert(4, mics);

    bpeople = new FunkinSprite(-100, 300).loadSprite(getModImage('TheDeathmatch/stagepeople'));
    bpeople.scale.set(1.8, 1.8);
    bpeople.alpha = 0.001;
    
    bpeople.addAnim('idle', 'people stage', 24, true);
    bpeople.addAnim('mom', 'Dancers', 24, true);
    bpeople.addOffset('mom', 0, 50);
    bpeople.playAnim('idle');
    insert(5, bpeople);
    
    var lights:FlxSprite = new FlxSprite(-1100, -900, getModImage('TheDeathmatch/stagelights'));
    lights.scrollFactor.set(0.9, 0.9);
    insert(6, lights);

    var curtains:FlxSprite = new FlxSprite(-1100, -550, getModImage('TheDeathmatch/curtains'));
    curtains.scrollFactor.set(0.8, 0.8);
    curtains.scale.set(1.1, 1.1);
    insert(7, curtains);

    fpeople = new FunkinSprite(-400, 810).loadSprite(getModImage('TheDeathmatch/frontpeople'));
    fpeople.scale.set(1.8, 1.8);
    fpeople.alpha = 0.001;
    
    fpeople.addAnim('idle', 'people front', 24, true);
    fpeople.playAnim('idle');
    add(fpeople);
    // stage shit

    for (a in [kworld, world, wall, stage, mics, bpeople, lights, curtains, fpeople])
        { a.antialiasing = true; }
}