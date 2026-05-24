public var mainBG:FlxSprite = new FlxSprite(-550, -230);
public var miibuttons:FunkinSprite = new FunkinSprite(-449, -299);
public var hallway:FlxSprite = new FlxSprite(-330, -230);
public var overlay:FlxSprite = new FlxSprite(-550, -230);

function create() {
    defaultCamZoom = 0.68;

    mainBG.loadGraphic(getModImage(switch(songName) {
        default: 'stageback';
        case 'Diagraphephobia': 'corruptback';
        case 'System Failure': 'blackback';
    }));
    mainBG.antialiasing = Options.antialiasing;
    addSprite(mainBG);

    if (songName == 'Diagraphephobia') {
        hallway.loadGraphic(getModImage('glitchhallway2ndsong'));
        hallway.antialiasing = Options.antialiasing;
        hallway.alpha = 0.001;
        addSprite(hallway);
    }

    if (songName == 'Dream Of Peace' || songName == 'Diagraphephobia') {
        var spr:String = songName == 'Diagraphephobia' ? 'Glitchmiibuttons' : 'miibuttons';
        miibuttons.loadSprite(getModImage('buttons/$spr'));
        miibuttons.addAnim('idle', 'stagecurtains', 24, true);
        miibuttons.playAnim('idle');
        miibuttons.antialiasing = Options.antialiasing;
        miibuttons.scrollFactor.set(1.17, 1.17);
        add(miibuttons);
    }

    if (songName == 'Diagraphephobia') {
        importScript('data/scripts/EteledGlitch');

        overlay.loadGraphic(getModImage('overlayphase2'));
        overlay.antialiasing = Options.antialiasing;
        add(overlay);
        addGlitchedBGs();
    }
}

var skin:String = 'modNotes/Eteled/bf';
var oppSkin:String = "modNotes/Eteled/eteled";

function onNoteCreation(_) {
    if (_.strumLineID == 1 && usingSkins) return;
    _.noteSprite = _.strumLineID == 1 ? skin : oppSkin;
}

function onStrumCreation(_) {
    if (_.player == 1 && usingSkins) return;
    _.sprite = _.player == 1 ? skin : oppSkin;
}