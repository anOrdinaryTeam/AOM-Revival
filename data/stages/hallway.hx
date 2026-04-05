importScript('data/scripts/EteledGlitchedNotes');

function create() {
    defaultCamZoom = 0.63;
    var bg:FlxSprite = new FlxSprite(-360, -210, getModImage('glitchhallway'));
    addSprite(bg);
}

function preStageLoad() if (songName == 'Plaything')
    stageName += '-alt';

function postCreate()
    gf.color = 0x0F6C6B6B;

function onNoteCreation(_) {
    var dadNotes:String = songName == 'Post Mortal' ? 'austin' : 'eteled';
    var bfNotes:String = songName == 'Post Mortal' ? 'bf' : 'austin';

    if (_.strumLineID == 0) _.noteSprite = 'modNotes/Eteled/$dadNotes';
    else _.noteSprite = 'modNotes/Eteled/$bfNotes';
}

function onStrumCreation(_) {
    var dadNotes:String = songName == 'Post Mortal' ? 'austin' : 'eteled';
    var bfNotes:String = songName == 'Post Mortal' ? 'bf' : 'austin';

    if (_.player == 0) _.sprite = 'modNotes/Eteled/$dadNotes';
    else _.sprite = 'modNotes/Eteled/$bfNotes';
}