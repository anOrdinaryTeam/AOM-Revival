function onCharsLoaded() {

    var rushsonic:Character = charactersMenu.members[0];

    for (char in [rushsonic]) {
        char.animation.callback = (Anim) -> {
            if (Anim == 'Sonic Yeah') char.danceOnBeat = false;
        }
        char.animation.finishCallback = (Anim) -> {
            if (Anim == 'Sonic Yeah') char.danceOnBeat = true;
        }
    }

}

function postUpdate() {

    var rushsonic:Character = charactersMenu.members[0];

    if (CoolUtil.mouseOverlaps(rushsonic) && FlxG.mouse.justPressed) {

        rushsonic.playAnim("Sonic Yeah", true);
        // FlxG.sound.play(Paths.sound('menusounds/sonicyeah'), volume:Int = 1);

    }
}