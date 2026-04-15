function postUpdate() {

    var rushblaze:Character = charactersMenu.members[0];

    if (CoolUtil.mouseOverlaps(rushblaze) && FlxG.mouse.justPressed) {

        danceOnBeat = false;
        FlxG.sound.play(Paths.sound('menusounds/blazeyeah'));

        rushblaze.playAnim("Blaze yeah", true);
        rushblaze.animation.finishCallback = function(name:String) {
            if (name == 'Blaze yeah') danceOnBeat = true;
        }

    }
}