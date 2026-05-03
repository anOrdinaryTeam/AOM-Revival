function preStageLoad()
    useStageData = false;
function postCreate()
    loadHud('PsychEngine', '');
function onGameOver(_) 
    _.deathCharID = 'Kapi/bf-gm';
function onStrumCreation(_)
    _.sprite = 'modNotes/Kapi/kapi notes';
function onNoteCreation(_) {
    _.noteSprite = 'modNotes/Kapi/kapi notes';
    _.note.splash = 'Kapi/v1';
}

var back:FlxSprite;
var lights:FunkinSprite;
var front:FlxSprite;

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
    back = new FlxSprite(-715, -230);
    if (curSong == 'wocky' || 'beathoven') {
        back.loadGraphic(getModImage('stage/old'));
    }
    else if (curSong == 'hairball') {
        back.getModImage('stage/sunset');
    }
    else if (curSong == 'nyaw') {
        back.getModImage('stage/closed');
    }
    back.scrollFactor.set(0.9, 0.9);
    insert(0, back);

    lights = new FunkinSprite(-715, -230).loadSprite(getModImage('stage/lights'));
    lights.scrollFactor.set(0.9, 0.9);
    lights.addAnim('idle', 'lightblink', 1, true);
    lights.playAnim('idle');
    insert(1, lights);

    front = new FlxSprite(-650, 600, getModImage('stage/front'));
    // front.scrollFactor.set(0.9, 0.9);
    front.scale.set(1.1, 1.1);
    insert(2, front);
}