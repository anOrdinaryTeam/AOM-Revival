function create()
        FlxG.sound.play(Paths.sound('menusounds/gyaru1'), volume = 4);

function postUpdate() {
    var abo:Character = charactersMenu.members[0];
    if (CoolUtil.mouseOverlaps(abo) && FlxG.mouse.justPressed) {
        FlxG.sound.play(Paths.sound('menusounds/gyaru2'), volume = 4);
    }
}