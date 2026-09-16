var isBf:Bool = boyfriend.curCharacter == 'bf';

function postCreate() if (isBf) {
    gf.alpha = 0.001;
    precacheCharacter(2, 'gf');
}

function stepHit(e) switch(e) {
    case 40: if (isBf) {
        gf.alpha = 1;
        gf.playAnim('fall', true);
        gf.animation.onFinish.add((Anim) -> if (Anim == 'fall') {
            changeCharacter(2, 'gf');
            gf.dance();
        });
    }
    case 47: if (isBf) {
        playModSound('slam');
        camGame.shake(0.02, 0.1);
    }
    case 836, 960:
        gf.visible = !gf.visible;
        for (stage in stageParts)
            stage.visible = !stage.visible;
    case 842: defaultCamZoom = 1;
    case 966: defaultCamZoom = 0.8;
    case 985:
        zombieBack.alpha = 1;
        zombieBack.playAnim('show', true);
    case 1045: zombieBack.playAnim('idle', true);
    case 1101:
        punchZom.alpha = 1;
        punchZom.playAnim('idle', true);
    case 1102: playModSound('mikeTyson');
}