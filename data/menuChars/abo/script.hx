function create()
        FlxG.sound.play(Paths.sound('menusounds/gyaru1'));

function postUpdate() {
    var abo:Character = charactersMenu.members[0];
    if (CoolUtil.mouseOverlaps(abo) && FlxG.mouse.justPressed) {
        FlxG.sound.play(Paths.sound('menusounds/gyaru2'));
    }
}