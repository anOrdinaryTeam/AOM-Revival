var t:String = 'Bullet Note';
var cancelHankAnim:Bool = false;
var timer:FlxTimer = new FlxTimer();

function onNoteCreation(e) if (e.noteType == t)
    e.noteSprite = 'modNotes/Accelerant/BulletNotes';

function onPlayerHit(e) if (e.noteType == t) {
    cancelHankAnim = true;
    dad.playSingAnim(e.direction, '-shoot');

    e.animCancelled = true;
    boyfriend.playAnim('dodge', true);

    timer.cancel();
    timer.start(0.2, () -> cancelHankAnim = false);

    playModSound('bullet');
    camGame.shake(0.01, 0.1);
}

function onPlayerMiss(e) if (e.noteType == t) {
    cancelHankAnim = true;
    dad.playSingAnim(e.direction, '-shoot');

    timer.cancel();
    timer.start(0.3, () -> cancelHankAnim = false);

    playModSound('bullet');
    camGame.shake(0.01, 0.1);
}

function onDadHit(e)
    e.animCancelled = cancelHankAnim;