importScript('data/scripts/Kapi/countdown.hx');

function preStageLoad()
    useStageData = false;
function postCreate()
    loadHud('PsychEngine', '');
function onStrumCreation(_)
    _.sprite = 'modNotes/Kapi/kapi notes 2';
function onNoteCreation(_) {
    _.noteSprite = 'modNotes/Kapi/kapi notes 2';
    _.note.splash = 'Kapi/v2';
}

var back2:FlxSprite;
var newGFlmao:FunkinSprite;
function create() {
    // settings shit
    defaultCamZoom = 0.9;

    boyfriend.setPosition(705, 65);
    dad.setPosition(50, 50);
    gf.alpha = 0;

    useCamMov = true;
    camMoveAmt = 20;
    // settings shit

    // stage shit
    var back:FlxSprite = new FlxSprite(-715, -230, getModImage('stage/v2/stageback'));
    back.scrollFactor.set(.9, .9);
    insert(0, back);

    if (curSong == 'scratch post') {
        back2 = new FlxSprite(-715, -230, getModImage('stage/v2/stage_light'));
        back2.scrollFactor.set(.9, .9);
        back2.alpha = 0.001;
        insert(1, back2);
    }

    var lights:FunkinSprite = new FunkinSprite(-715, -230).loadSprite(getModImage('stage/v2/lights'));
    lights.scrollFactor.set(.9, .9);
    lights.addAnim('idle', 'idle', 1, true);
    lights.playAnim('idle');
    insert(2, lights);

    var front:FlxSprite = new FlxSprite(-650, -250, getModImage('stage/v2/stagefront'));
    insert(3, front);

    var dvd:FunkinSprite = new FunkinSprite(-715, -230).loadSprite(getModImage('stage/v2/kapidvd'));
    dvd.scrollFactor.set(.9, .9);
    dvd.addAnim('idle', 'dvdmove', 8, true);
    dvd.playAnim('idle');
    insert(4, dvd);

    newGFlmao = new FunkinSprite(395, 490).loadSprite(getModImage('stage/v2/nogf_LOL'));
    newGFlmao.scale.set(.9, .9);
    newGFlmao.addAnim('idle', 'GF Dancing Beat Hair blowing CAR0', 24, false, false, [30,0,1,2,3,4,5,6,7,8,9,10,12,13,14]);
    insert(4, newGFlmao);
    // stage shit
}

function beatHit() {
    if (curBeat % 2 == 0) {
        newGFlmao.playAnim('idle');
    }
    if (curSong == 'scratch post') {
        switch(curBeat) {
            case 144:
                back2.alpha = 1;
            case 360:
                remove(back2, true);
        }
    }
}