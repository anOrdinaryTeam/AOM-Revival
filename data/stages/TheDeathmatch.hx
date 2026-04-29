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

public var backpast:FlxSprite;
public var rlightpast:FlxSprite;
public var llightpast:FlxSprite;
public var curtainspast:FlxSprite;
public var stagepast:FlxSprite;

var bfpast:FunkinSprite;
var gfpast:FunkinSprite;
var dadpast:FunkinSprite;

function create() {
    // settings shit
    importScript('songs/The Deathmatch/$curDiff.hx');

    defaultCamZoom = 0.9;
    gf.alpha = 0;
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

    if (curDiff != 'canon')
    {
        // stage memories n shit
        camHUD.alpha = 0;

        backpast = new FlxSprite(-600, -200, getModImage('TheDeathmatch/stagebackpast'));
        backpast.scale.set(1.2, 1.2);
        add(backpast);

        stagepast = new FlxSprite(-600, 650, getModImage('TheDeathmatch/stagefrontpast'));
        stagepast.scale.set(1.2, 1.2);
        add(stagepast);

        rlightpast = new FlxSprite(-200, -125, getModImage('TheDeathmatch/stage_lightpast'));
        rlightpast.scale.set(1.2, 1.2);
        add(rlightpast);

        llightpast = new FlxSprite(1325, -125, getModImage('TheDeathmatch/stage_lightpast'));
        llightpast.scale.set(1.2, 1.2);
        llightpast.flipX = true;
        add(llightpast);

        curtainspast = new FlxSprite(-600, -200, getModImage('TheDeathmatch/stagecurtainspast'));
        curtainspast.scale.set(1.2, 1.2);
        add(curtainspast);

        gfpast = new FunkinSprite(425, 125).loadSprite(getModImage('TheDeathmatch/past_GF'));
        gfpast.addAnim('idle', 'GF Dancing Beat0', 24, true);
        gfpast.playAnim('idle');
        add(gfpast);

        bfpast = new FunkinSprite(825, 475).loadSprite(getModImage('TheDeathmatch/past_BF'));
        bfpast.addAnim('idle', 'BF idle dance', 24, true);
        bfpast.playAnim('idle');
        add(bfpast);

        dadpast = new FunkinSprite(75, 75).loadSprite(getModImage('TheDeathmatch/past_dad'));
        dadpast.addAnim('idle', 'Dad idle dance', 24, true);
        dadpast.playAnim('idle');
        add(dadpast);
        // stage memories n shit
        for (a in [backpast, stagepast, rlightpast, llightpast, curtainspast, gfpast, bfpast, dadpast])
                { a.antialiasing = true; }
    }
    for (a in [kworld, world, wall, stage, mics, bpeople, lights, curtains, fpeople])
        { a.antialiasing = true; }
}

// events go brr
function stepHit() {
    if (curDiff != 'canon') {
        switch(curStep) {
            case 112:
                defaultCamZoom = 0.45;
                camHUD.alpha = 1;
                for (i in [backpast, stagepast, rlightpast, llightpast, curtainspast, gfpast, bfpast, dadpast])
                    { remove(i); }
        }
    }
}