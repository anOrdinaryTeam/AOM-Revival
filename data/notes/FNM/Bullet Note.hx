var redSplash:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.RED);

function create() {
    redSplash.alpha = 0.001;
    redSplash.camera = camHUD;
    add(redSplash);
}

function DontRepeatCode(dir:Int, isMiss:Bool) {
    var jebusTrail:Character = strumLines.members[0].characters[1];
    jebusTrail.playSingAnim(dir, '-shoot');
    dad.playSingAnim(dir, '-shoot');

    if (!isMiss) {
        var playerTrail:Character = strumLines.members[1].characters[1];
        playerTrail.playAnim('dodge', true);
        boyfriend.playAnim('dodge', true);
    }

    camGame.shake(0.01, 0.2);
}

function onNoteCreation(e) {
    if (e.noteType != 'FNM/Bullet Note') return;
    e.noteSprite = 'modNotes/FNM/Bullet';
}

function onPlayerHit(e) {
    if (e.noteType != 'FNM/Bullet Note') return;
    e.animCancelled = true;
    DontRepeatCode(e.direction, false);
}

function onPlayerMiss(e) {
    if (e.noteType != 'FNM/Bullet Note') return;
    DontRepeatCode(e.direction, true);
    e.healthGain -= 0.2;
    e.animCancelled = true;
    boyfriend.playAnim('hit', true);

    redSplash.alpha = 0.2;
    FlxTween.tween(redSplash, {alpha: 0}, 0.4, {startDelay: 0.125, ease: FlxEase.quadInOut});
}