importScript('data/scripts/Kapi/countdown.hx');

function preStageLoad()
    useStageData = false;
function postCreate()
    loadHud('PsychEngine', '');

var skin:String = 'modNotes/Kapi/gw notes';
function onNoteCreation(_) {
    if (_.strumLineID == 1 && usingSkins) return;
    _.noteSprite = skin;
    if (_.strumLineID == 1) _.note.splash = 'Kapi/gw';
}

function onStrumCreation(_) {
    if (_.player == 1 && usingSkins) return;
    _.sprite = skin;
}

function create() {
    defaultCamZoom = 0.9;

    boyfriend.setPosition(775, 100);
    dad.setPosition(100, 100);
    gf.setPosition(450, 160);

    useCamMov = true;
    camMoveAmt = 20;

    var flat:FlxSprite = new FlxSprite(-250, -150, getModImage('stage/v1/halloween_bggame'));
    flat.scrollFactor.set(0.9, 0.9);
    addSprite(flat);
} // holy shit