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

        for (i in [ghost, sink]) 
            i.playAnim('singUP', true);
    }
}