var t:String = 'Bullet Note';
var cancelHankAnim:Bool = false;
var timer:FlxTimer = new FlxTimer();

function onNoteCreation(e) if (e.noteType == t)
    e.noteSprite = 'modNotes/Accelerant/BulletNotes';

function onPlayerHit(e) if (e.noteType == t) {
    cancelHankAnim = true;
    e.animCancelled = true;

    timer.cancel();
    timer.start(0.3, () -> cancelHankAnim = false);

    playModSound('bullet');
    boyfriend.playAnim('dodge', true);
    dad.playSingAnim(e.direction, '-shoot');
}

function onDadHit(e)
    e.animCancelled = cancelHankAnim;