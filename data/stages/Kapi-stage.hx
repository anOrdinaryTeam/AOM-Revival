function preStageLoad()
    useStageData = false;
function postCreate()
    loadHud('KadeEngine', '');
function onGameOver(_) {
    _.deathCharID = 'Kapi/bf-gm';
    _.lossSFX = 'Kapi/StoleYoBitch';
    _.retrySFX = 'Kapi/NahNvm';
}
function onStrumCreation(_)
    _.sprite = 'modNotes/Kapi/kapi notes';
function onNoteCreation(_) {
    _.noteSprite = 'modNotes/Kapi/kapi notes';
    _.note.splash = 'Kapi/v1';
}

var audience:FunkinSprite;
var freaks:FunkinSprite;

function create() {
    // settings shit
    defaultCamZoom = 0.9;

    boyfriend.setPosition(635, 50);
    dad.setPosition(-30, 55);
    gf.setPosition(275, 100);

    useCamMov = true;
    camMoveAmt = 20;
    // settings shit

    // stage shit
    var back:FlxSprite = new FlxSprite(-715, -230);
    back.scrollFactor.set(0.9, 0.9);
    addSprite(back);

    if (curSong == 'wocky' || curSong == 'beathoven') {
        back.loadGraphic(getModImage('stage/v1/old'));
    }
    if (curSong == 'hairball') {
        back.loadGraphic(getModImage('stage/v1/sunset'));
    }
    if (curSong == 'nyaw') {
        back.loadGraphic(getModImage('stage/v1/closed'));

        freaks = new FunkinSprite(-625, -200).loadSprite(getModImage('stage/v1/bgFreaks'));
        freaks.scrollFactor.set(0.9, 0.9);
        freaks.addAnim('idle', 'Bottom Level Boppers', 28, false);
        addSprite(freaks);
    }
    if (curSong == 'beathoven' || curSong == 'hairball') {
        var spookys:FunkinSprite = new FunkinSprite(-25, 150).loadSprite(getModImage('stage/v1/littleguys'));
        spookys.scrollFactor.set(0.9, 0.9);
        spookys.addAnim('idle', 'Bottom Level Boppers', 24, true);
        spookys.playAnim('idle');
        addSprite(spookys);
    }
    if (curSong == 'hairball' || curSong == 'nyaw') {
        audience = new FunkinSprite(-625, -200).loadSprite(getModImage('stage/v1/upperBop'));
        audience.scrollFactor.set(0.9, 0.9);
        audience.addAnim('idle', 'Upper Crowd Bob', 18, false);
        add(audience);
    }
    
    var lights:FunkinSprite = new FunkinSprite(-715, -230).loadSprite(getModImage('stage/v1/lights'));
    lights.scrollFactor.set(0.9, 0.9);
    lights.addAnim('idle', 'lightblink', 1, true);
    lights.playAnim('idle');
    addSprite(lights);

    var front:FlxSprite = new FlxSprite(-650, 600, getModImage('stage/v1/front'));
    front.scale.set(1.1, 1.1);
    addSprite(front);
    // stage shit
}

function beatHit() {
    if (curBeat % 2 == 0) {
        if (curSong == 'hairball') {
            audience.playAnim('idle');
        }
        if (curSong == 'nyaw') {
            audience.playAnim('idle');
            freaks.playAnim('idle');
        }
    }
    if (curSong == 'nyaw' && curBeat == 437) {
        camGame.alpha = 0;
        camHUD.alpha = 0;
    }
}