/*
    I'm making this to really warn people to DO NOT
    play the modpack in a Release CNE Build and making
    a safe State compatible for allow you to switch to another mod or
    download the Latest Nightly CNE Build.

    - Zanxt.
*/

import funkin.menus.ModSwitchMenu;

var cnePage:FlxSprite = new FlxSprite(30, 370).makeSolid(390, 130, FlxColor.GRAY);
var download:FlxSprite = new FlxSprite(30, 530).makeSolid(390, 130, FlxColor.GRAY);

function create() {
    FlxG.mouse.visible = true;

    var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuEditors'));
    bg.antialiasing = true;
    bg.screenCenter();
    add(bg);

    var warningTitle:FunkinText = new FunkinText(20, 50, 0, 'WARNING', 80);
    warningTitle.antialiasing = true;
    warningTitle.color = FlxColor.RED;
    add(warningTitle);

    var str:String = 'The Modpack is incompatible with\nthis CNE Build (Release), please\ndownlaod the Latest Nightly Build.\n\nYou can also switch to any other\nof your Mods pressing TAB';
    var warning:FunkinText = new FunkinText(20, 150, 0, str, 30);
    warning.antialiasing = true;
    add(warning);

    cnePage.alpha = download.alpha = 0.7;
    add(cnePage);
    add(download);

    var downloadTxt:FunkinText = new FunkinText(80, 400, 0, 'CNE Page', 60);
    downloadTxt.antialiasing = true;
    downloadTxt.x = (cnePage.x + (cnePage.width - downloadTxt.width) / 2);
    add(downloadTxt);

    var system:String = getSystem();
    var downloadTxt:FunkinText = new FunkinText(90, 560, 0, system, 60);
    downloadTxt.antialiasing = true;
    downloadTxt.x = (download.x + (download.width - downloadTxt.width) / 2);
    add(downloadTxt);

    var gfsad:Character = new Character(0, 0, 'gf');
    gfsad.playAnim('sad');
    gfsad.scale.set(0.8, 0.8);
    gfsad.updateHitbox();
    gfsad.setPosition(750, 400);
    add(gfsad);

    FlxG.sound.play(Paths.sound('missnote' + FlxG.random.int(1, 3)), 0.2);
}

function update() {
    if (FlxG.mouse.overlaps(cnePage) && FlxG.mouse.justPressed)
        CoolUtil.openURL("https://codename-engine.com/");

    if (FlxG.mouse.overlaps(download) && FlxG.mouse.justPressed)
        CoolUtil.openURL(getSystemLink());

    if (controls.SWITCHMOD) {
		openSubState(new ModSwitchMenu());
		persistentUpdate = false;
		persistentDraw = true;
	}
}

static function getSystem():String
{
    return #if linux 'Linux'; #elseif (mac || macos) 'MacOS'; #elseif windows 'Windows'; #end
}

static function getSystemLink():String
{
    var sys:String = getSystem();
    return 'https://nightly.link/CodenameCrew/CodenameEngine/workflows/${sys.toLowerCase()}/main/Codename%20Engine.zip';
}