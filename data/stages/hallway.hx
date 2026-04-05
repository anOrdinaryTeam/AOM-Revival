importScript('data/scripts/EteledGlitchedNotes');

function create() {
    defaultCamZoom = 0.63;
    var bg:FlxSprite = new FlxSprite(-360, -210, getModImage('glitchhallway'));
    addSprite(bg);
}

function postCreate()
    gf.color = 0x0F6C6B6B;

function onNoteCreation(_) 
    if (_.strumLineID == 0) _.noteSprite = "modNotes/Eteled/austin";
    else _.noteSprite = "modNotes/Eteled/bf";

function onStrumCreation(_)
    if (_.player == 0) _.sprite = "modNotes/Eteled/austin";
    else _.sprite = "modNotes/Eteled/bf";