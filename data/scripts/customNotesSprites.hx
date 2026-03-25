var JsonData:Dynamic = CoolUtil.parseJson(Paths.json('customNotes/$noteSkin'));
var strumScale:Float = JsonData.scale;
var antialiasing:Bool = JsonData.antialiasing;

var called:Bool = true;

function onNoteCreation(e) {
    if (noteSkin == '') return;
    e.cancel();

    var note = e.note;
    var id = e.strumID;

    if (e.noteType == null) {
        if (note.isSustainNote) {
            note.frames = Paths.getFrames(JsonData.pathSprite);
            note.animation.addByPrefix('hold', JsonData.strum[id].holdPiece, 24, false);
            note.animation.addByPrefix('holdend', JsonData.strum[id].holdEndPiece, 24, false);
        }
        else {
            note.frames = Paths.getFrames(JsonData.pathSprite);
            note.animation.addByPrefix('scroll', JsonData.strum[id].noteArrow, 24, false);
        }

        note.antialiasing = Options.antialiasing;
        note.scale.set(strumScale, strumScale);
        note.updateHitbox();
    }
}

function onStrumCreation(e) {
    if (!called) {
        called = true;
        JsonData = 
        strumScale = JsonData.scale;
        antialiasing = JsonData.antialiasing;
    }

    if (noteSkin == '') return;
    e.cancel();

    var strum = e.strum;
    var id = e.strumID;

    strum.frames = Paths.getFrames(JsonData.pathSprite);

    // Notes
    strum.animation.addByPrefix('purple', JsonData.strum[id].noteArrow);
    strum.animation.addByPrefix('down', JsonData.strum[id].noteArrow);
    strum.animation.addByPrefix('green', JsonData.strum[id].noteArrow);
    strum.animation.addByPrefix('red', JsonData.strum[id].noteArrow);

    // Strum
    strum.animation.addByPrefix('static', JsonData.strum[id].strumArrow);
    strum.animation.addByPrefix('pressed', JsonData.strum[id].pressArrow, 24, false);
    strum.animation.addByPrefix('confirm', JsonData.strum[id].confirmArrow, 24, false);

    strum.scale.set(strumScale, strumScale);
    strum.antialiasing = Options.antialiasing;
}