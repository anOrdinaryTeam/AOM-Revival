function onCharsLoaded() {

    var ghost:Character = charactersMenu.members[0];
    var sink:Character = charactersMenu.members[1];

    FlxTween.tween(ghost, {alpha: 0.2}, 1.5, {type: 4, ease: FlxEase.quadInOut});
}

function postUpdate() {

    var ghost:Character = charactersMenu.members[0];
    var sink:Character = charactersMenu.members[1];

    
    if (CoolUtil.mouseOverlaps(sink) && FlxG.mouse.justPressed) {
        
        danceOnBeat = false;

        FlxG.sound.play(Paths.sound('menusounds/sink'));

        for (char in [ghost, sink]) {
            char.animation.callback = (Anim) -> {
            if (Anim == 'singUP') char.danceOnBeat = true;
        }
            char.animation.finishCallback = (Anim) -> {
            if (Anim == 'singUP') char.danceOnBeat = true;
        }

    }

        ghost.playAnim('singUP', true);
        sink.playAnim('singUP', true);

    }

}