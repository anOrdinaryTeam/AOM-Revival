introLength = 0;
defaultCamZoom = 0.92;

function postCreate() {
    camMoveAmt = 50;
    camHUD.alpha = 0.001;
    dad.playAnim('stare', true, 'LOCK');

    iconP1.setIcon('bf');
    loadHud('PsychEngine');
    PlayState.instance.comboGroup.x += 500;
}

function stepHit(e) if (e == 126)
    dad.playAnim('turn', true);

function beatHit(e) {
    switch(e) {
        case 1:
            FlxTween.tween(camHUD, {zoom: 4}, 0.2);
            FlxTween.tween(camGame, {zoom: 1.15}, 13.2);
        case 31:
            camHUD.alpha = 1;
            FlxTween.cancelTweensOf(camHUD);
            FlxTween.tween(camHUD, {zoom: 1}, 0.5);
        case 32:
            FlxTween.cancelTweensOf(camGame);
            FlxTween.tween(camGame, {zoom: defaultCamZoom}, 0.1);
    }
}

function postUpdate() if (!forceCamPos) switch(strumLines.members[0].characters[0].animation.curAnim.name) {
    case "singLEFT", "singLEFT-alt": follow([-camMoveAmt, 0]);
    case "singDOWN", "singDOWN-alt": follow([0, camMoveAmt]);
    case "singUP", "singUP-alt": follow([0, -camMoveAmt]);
    case "singRIGHT", "singRIGHT-alt": follow([camMoveAmt, 0]);
}

function follow(offsets:Array<Float>) {
    camFollow.x += offsets[0];
    camFollow.y += offsets[1];
}