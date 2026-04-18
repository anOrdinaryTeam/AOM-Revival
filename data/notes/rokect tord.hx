var tordAnim:Bool = false;

function onNoteHit(_) {
    if (_.noteType == "rokect tord") {
        tordAnim = true;
        dad.playAnim('TordRaiseThumbs', true);
        new FlxTimer().start(0.3, () -> tordAnim = false );
    }
}

function update() {
    dad.animation.finishCallback = function(name:String) {
        if (name == 'TordRaiseThumbs') {
            dad.playAnim('TordButtonPress', true);
        }
    }
}

function onDadHit(_)
    _.animCancelled = tordAnim;