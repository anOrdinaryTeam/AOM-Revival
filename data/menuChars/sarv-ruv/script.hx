var sarv:Character;
public var pillar:FlxSprite;
public var ruv:FlxSprite;

function onCharsLoaded() {
    var path:String = 'Mods/Mid-Fight Masses/images/church3';
    sarv = charactersMenu.members[0];

    pillar = new FlxSprite(155, -160, Paths.file('$path/pillarbroke.png'));
    insert(members.indexOf(charactersMenu), pillar);

    ruv = new FlxSprite(980, 310, Paths.file('$path/he likes to be alone.png'));
    insert(members.indexOf(charactersMenu), ruv);

    for (tr in [pillar, ruv]) {
        tr.antialiasing = Options.antialiasing;
        tr.scale.set(0.6, 0.6);
        tr.updateHitbox();
    }

    if (FlxG.random.bool(20)) {
        var sorry:FunkinText = new FunkinText(ruv.x - 200, ruv.y - 150, 0, 'This in my mind looked way better\nsorry :p\n- Zanxt', 20);
        sorry.alignment = 'center';
        sorry.antialiasing = true;
        sorry.alpha = 0.001;
        add(sorry);

        FlxTween.tween(sorry, {alpha: 1, y: sorry.y + 50}, 0.7, {ease: FlxEase.sineInOut}).then(FlxTween.tween(sorry, {alpha: 0}, 1, {startDelay: 3, onComplete: () -> remove(sorry)}));
    }
}

function postUpdate() if (CoolUtil.mouseOverlaps(sarv) && FlxG.mouse.justPressed)
    playSound('menusounds/huh-sarv');
