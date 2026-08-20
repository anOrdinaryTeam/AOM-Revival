defaultCamZoom = 0.8;

function create() {
    dad.animation.onFinish.add((Anim) -> {
        if (Anim == 'Getcha') dad.scale.set(1, 1);
    });
}

function stepHit() switch(curStep) {
    case 5:
        dad.playAnim('Getcha');
        dad.scale.set(0.9, 0.9);
}