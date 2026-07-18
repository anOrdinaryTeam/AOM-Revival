var sarv:Character;
var rub:Character;

function onCharsLoaded() {
    var path:String = 'Mods/Mid-Fight Masses/images/church3';
    sarv = charactersMenu.members[0];
    rub = charactersMenu.members[1];

    if (FlxG.random.bool(20)) {
        var sorry:FunkinText = new FunkinText(780, 160, 0, 'This in my mind looked way better\nsorry :p\n- Zanxt', 20);
        sorry.alignment = 'center';
        sorry.antialiasing = true;
        sorry.alpha = 0.001;
        add(sorry);

        FlxTween.tween(sorry, {alpha: 1, y: sorry.y + 50}, 0.7, {ease: FlxEase.sineInOut}).then(FlxTween.tween(sorry, {alpha: 0}, 1, {startDelay: 3, onComplete: () -> remove(sorry)}));
    }
}

function postUpdate() if (CoolUtil.mouseOverlaps(sarv) && FlxG.mouse.justPressed)
    playSound('menusounds/huh-sarv');
