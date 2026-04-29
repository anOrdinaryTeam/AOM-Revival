function postUpdate() {
    var rushsonic:Character = charactersMenu.members[0];
    if (CoolUtil.mouseOverlaps(rushsonic) && FlxG.mouse.justPressed) {

        danceOnBeat = false;

        FlxG.sound.play(Paths.sound('menusounds/sonicyeah'));

        rushsonic.playAnim("Sonic Yeah", true);
        rushsonic.animation.finishCallback = function(name:String) {
            if (name == 'Sonic Yeah') danceOnBeat = true;
        }

    }
}