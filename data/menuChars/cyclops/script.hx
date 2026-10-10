var char:Character;
function onCharsLoaded() {
    bg.visible = false;
    logo.visible = false;
    danceOnBeat = false;
    char = charactersMenu.members[0];
    char.playAnim('stare', true, 'LOCK');
    char.animation.onFinish.add((Anim) -> if (Anim == 'turn') {
        danceOnBeat = true;
        char.dance();
    });
}

function update() if ((CoolUtil.mouseOverlaps(char) && FlxG.mouse.justPressed) && char.animation.curAnim.name != 'idle') {
    char.playAnim('turn', true);
    playSound('Lights_Turn_On', 0.6);
}