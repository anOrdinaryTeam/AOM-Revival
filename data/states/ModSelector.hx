var input:Bool = true;
var curSelected:Int = 0;

var MODS_LIST:FlxTypedGroup<Alphabet> = new FlxTypedGroup();

function create() {
    var temp:FlxSprite = new FlxSprite().loadGraphic(getImage('menus/menuBG'));
    add(temp);

    add(MODS_LIST);
    for (i in 0...currentModsList.length) {
        var mod:Alphabet = new Alphabet(0, 0, currentModsList[i], 'bold');
        mod.isMenuItem = true;
        MODS_LIST.add(mod);
    }

    scroll(lastModSelected, true);
    currentMod = 'NONE';
}

function update() {
    if (input) {
        scroll((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);

        if (controls.BACK) {
            input = false;
            CoolUtil.playMenuSFX(2, 0.7);
            FlxG.switchState(new ModState('Menu'));
        }

        if (controls.ACCEPT) onSelect();
    }
}

function onSelect() {
    currentMod = currentModsList[curSelected];
    trace(currentMod);
    FlxG.switchState(new FreeplayState());
}

function scroll(i:Int = 0, f:Bool = false) {
    if (i == 0 && !f) return;

    curSelected = FlxMath.wrap(curSelected + i, 0, MODS_LIST.members.length-1);
    lastModSelected = curSelected;
    CoolUtil.playMenuSFX(0, 0.7);

    for (k => item in MODS_LIST.members) {
		item.targetY = k - curSelected;
		// item.alpha = lerp(item.alpha, 0.5, 0.3);

		// if (item.targetY == 0)
		// 	item.alpha = 1;
	}
}