using StringTools;

var redSplash:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.RED);

function create() {
    redSplash.alpha = 0.001;
    redSplash.camera = camHUD;
    add(redSplash);
}

function DontRepeatCode(dir:Int, isMiss:Bool, char:Character) {
    var jebusTrail:Character = strumLines.members[0].characters[1];
    jebusTrail.playSingAnim(dir, '-shoot');
    dad.playSingAnim(dir, '-shoot');

    if (!isMiss) dodgeChecker(char, char.curCharacter);
    camGame.shake(0.01, 0.2);
}

function dodgeChecker(char:Character, name:String) {
    if (name.contains('hank')) {
        FlxTween.cancelTweensOf(char);
        FlxTween.color(char, 0.2, FlxColor.CYAN, -1, {ease: FlxEase.quadInOut});
    }
    else {
        var playerTrail:Character = strumLines.members[1].characters[1];
        playerTrail.playAnim('dodge', true);
        char.playAnim('dodge', true);
    }
}

function onNoteCreation(e) {
    if (e.noteType != 'FNM/Bullet Note') return;
    e.noteSprite = 'modNotes/FNM/Bullet';
}

function onPlayerHit(e) {
    if (e.noteType != 'FNM/Bullet Note') return;
    e.animCancelled = true;
    DontRepeatCode(e.direction, false, e.character);
}

function onPlayerMiss(e) {
    if (e.noteType != 'FNM/Bullet Note') return;
    DontRepeatCode(e.direction, true, e.character);
    e.healthGain -= 0.2;
    e.animCancelled = true;

    var isBf:Bool = e.character.curCharacter.contains('bf');
    if (isBf)
        boyfriend.playAnim('hit', true);
    else {
        FlxTween.cancelTweensOf(e.character);
        FlxTween.color(e.character, 0.2, FlxColor.RED, -1, {ease: FlxEase.quadInOut});
    }

    redSplash.alpha = 0.2;
    FlxTween.tween(redSplash, {alpha: 0}, 0.4, {startDelay: 0.125, ease: FlxEase.quadInOut});
}