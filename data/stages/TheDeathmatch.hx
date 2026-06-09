var skin:String = 'modNotes/TheDeathmatch/death notes';
function onNoteCreation(_) {
    if (_.strumLineID == 1 && usingSkins) return;
    _.noteSprite = skin;
}

function onStrumCreation(_) {
    if (_.player == 1 && usingSkins) return;
    _.sprite = skin;
}

function onGameOver(_) 
    _.deathCharID = 'TheDeathmatch/bf-cdeath';

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
    importScript('songs/The Deathmatch/$curDiff');
    defaultCamZoom = 0.9;

    for (d in ['dearest', 'dearest2', 'dearest3', 'dearest4'])
        { precacheCharacter(0, 'TheDeathmatch/$d'); }
    for (b in ['pico-death', 'bf-deathmatch', 'kids-death', 'mom-death'])
        { precacheCharacter(1, 'TheDeathmatch/$b'); }

    kworld = new FunkinSprite(-50, -50).loadSprite(getModImage('TheDeathmatch/TheWorldKids'));
    kworld.antialiasing = Options.antialiasing;
    
    kworld.scale.set(1.8, 1.8);
    kworld.alpha = 0.001;
    
    kworld.addAnim('idle', 'Eyes', 24, true);
    kworld.playAnim('idle');
    addSprite(kworld);

    world = new FunkinSprite(-50, -50).loadSprite(getModImage('TheDeathmatch/TheWorld'));
    world.antialiasing = Options.antialiasing;
    
    world.scale.set(1.8, 1.8);
    world.alpha = 0.001;
    
    world.addAnim('idle', 'nokids', 24, true);
    world.playAnim('idle');
    addSprite(world);

    var wall:FlxSprite = new FlxSprite(-1100, -575, getModImage('TheDeathmatch/stagewall'));
    wall.antialiasing = Options.antialiasing;
    addSprite(wall);

    var stage:FlxSprite = new FlxSprite(-1100, 725, getModImage('TheDeathmatch/stage'));
    stage.antialiasing = Options.antialiasing;
    stage.scale.set(1.2, 1.2);
    addSprite(stage);

    if (!Options.lowMemoryMode) {
        var mics:FlxSprite = new FlxSprite(125, 625, getModImage('TheDeathmatch/mics'));
        mics.antialiasing = Options.antialiasing;
        addSprite(mics);

        bpeople = new FunkinSprite(-100, 300).loadSprite(getModImage('TheDeathmatch/stagepeople'));
        bpeople.antialiasing = Options.antialiasing;
        
        bpeople.scale.set(1.8, 1.8);
        bpeople.alpha = 0.001;
        
        bpeople.addAnim('idle', 'people stage', 24, true);
        bpeople.addAnim('mom', 'Dancers', 24, true);
        bpeople.addOffset('mom', 0, 50);
        bpeople.playAnim('idle');
        addSprite(bpeople);
    }
    
    var lights:FlxSprite = new FlxSprite(-1100, -900, getModImage('TheDeathmatch/stagelights'));
    lights.antialiasing = Options.antialiasing;
    lights.scrollFactor.set(0.9, 0.9);
    addSprite(lights);

    var curtains:FlxSprite = new FlxSprite(-1100, -550, getModImage('TheDeathmatch/curtains'));
    curtains.antialiasing = Options.antialiasing;
    
    curtains.scrollFactor.set(0.8, 0.8);
    curtains.scale.set(1.1, 1.1);
    addSprite(curtains);

    if (!Options.lowMemoryMode) {
        fpeople = new FunkinSprite(-400, 810).loadSprite(getModImage('TheDeathmatch/frontpeople'));
        fpeople.antialiasing = Options.antialiasing;
        
        fpeople.scale.set(1.8, 1.8);
        fpeople.alpha = 0.001;
        
        fpeople.addAnim('idle', 'people front', 24, true);
        fpeople.playAnim('idle');
        add(fpeople);
    }
}