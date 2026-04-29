function create() {
    defaultCamZoom = 0.8;
    var bg:FlxSprite = new FlxSprite(-600, -300, getModImage('MegaloStrikeB/chara-bg'));
    bg.antialiasing = Options.antialiasing;
    addSprite(bg);
}

function postCreate()
    loadHud('KadeEngine', '1.4.1');