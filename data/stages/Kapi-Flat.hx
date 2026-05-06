importScript('data/scripts/Kapi/countdown.hx');

function preStageLoad()
    useStageData = false;
function postCreate()
    loadHud('PsychEngine', '');

function onStrumCreation(_)
    _.sprite = 'modNotes/Kapi/gw notes';
function onNoteCreation(_) {
    _.noteSprite = 'modNotes/Kapi/gw notes';
    _.note.splash = 'Kapi/gw';
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
    insert(0, flat);
} // holy shit