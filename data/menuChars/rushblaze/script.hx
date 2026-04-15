function onCharsLoaded() {

    var rushblaze:Character = charactersMenu.members[0];

    for (char in [rushblaze]) {
        char.animation.callback = (Anim) -> {
            if (Anim == 'Blaze yeah') char.danceOnBeat = false;
        }
        char.animation.finishCallback = (Anim) -> {
            if (Anim == 'Blaze yeah') char.danceOnBeat = true;
        }
    }

}

function postUpdate() {

    var rushblaze:Character = charactersMenu.members[0];

    if (CoolUtil.mouseOverlaps(rushblaze) && FlxG.mouse.justPressed) {

        rushblaze.playAnim("Blaze yeah", true);
        FlxG.sound.play(Paths.sound('menusounds/blazeyeah'));

    }
}