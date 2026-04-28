var staticSpr:FunkinSprite = new FunkinSprite();
var staticTimer:FlxTimer = new FlxTimer();

function postCreate() {
    staticSpr.loadSprite(getModImage('hitStatic'));
    staticSpr.addAnim('hit', 'staticANIMATION', 24, false);
    staticSpr.camera = camHUD;
    staticSpr.alpha = 0.0001;
    add(staticSpr);
}

function onNoteCreation(_) if (_.noteType == 'Static Note') {
    _.noteSprite = 'modNotes/EXE/STATICNOTE_assets';
    _.note.forceIsOnScreen = true;
}

function onPlayerMiss(_) if (_.noteType == 'Static Note') {
    FlxG.camera.shake(0.005, 0.005);
    playModSound('hitStatic1');

    staticSpr.playAnim('hit', true);
    staticSpr.alpha = 1;
    health -= 0.0030;

    staticTimer?.cancel();
    staticTimer.start(0.38, () -> staticSpr.alpha = 0);
}