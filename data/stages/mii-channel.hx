public var mainBG:FlxSprite = new FlxSprite(-550, -230);
public var hallway:FlxSprite = new FlxSprite(-550, -230);
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
        var miibuttons:FunkinSprite = new FunkinSprite(-449, -299, getModImage('buttons/$spr'));
        miibuttons.addAnim('idle', 'stagecurtains', 24, true);
        miibuttons.playAnim('idle');
        miibuttons.antialiasing = Options.antialiasing;
        miibuttons.scrollFactor.set(1.17, 1.17);
        add(miibuttons);
    }

    if (songName == 'Diagraphephobia') {
        overlay.loadGraphic(getModImage('overlayphase2'));
        overlay.antialiasing = Options.antialiasing;
        add(overlay);
    }
}

function onNoteCreation(_) 
    if (_.strumLineID == 0) _.noteSprite = "modNotes/Eteled/eteled";
    else _.noteSprite = "modNotes/Eteled/bf";

function onStrumCreation(_)
    if (_.player == 0) _.sprite = "modNotes/Eteled/eteled";
    else _.sprite = "modNotes/Eteled/bf";