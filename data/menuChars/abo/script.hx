function postUpdate() {
    var abo:Character = charactersMenu.members[0];
    if (CoolUtil.mouseOverlaps(abo) && FlxG.mouse.justPressed) {
        FlxG.sound.stop;
        FlxG.sound.play(Paths.sound('menusounds/gyaru2'), volume = 4);
    }
}

