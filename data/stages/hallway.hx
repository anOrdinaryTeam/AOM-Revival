importScript('data/scripts/EteledGlitch');

function create() {
    defaultCamZoom = 0.63;
    useGlitchedNotes = true;
    var bg:FlxSprite = new FlxSprite(-360, -210, getModImage('glitchhallway'));
    addSprite(bg);
}

function preStageLoad() if (songName == 'Plaything')
    stageName += '-alt';

function postCreate()
    gf.color = 0x0F6C6B6B;

var dadNotes:String = songName == 'Post Mortal' ? 'modNotes/Eteled/austin' : 'modNotes/Eteled/eteled';
var bfNotes:String = songName == 'Post Mortal' ? 'modNotes/Eteled/bf' : 'modNotes/Eteled/austin';

function onNoteCreation(_) {
    if (_.strumLineID == 1 && usingSkins) return;
    _.noteSprite = _.strumLineID == 1 ? bfNotes : dadNotes;
}

function onStrumCreation(_) {
    if (_.player == 1 && usingSkins) return;
    _.sprite = _.player == 1 ? bfNotes : dadNotes;
}