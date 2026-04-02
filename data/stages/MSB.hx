function create() {
    defaultCamZoom = 0.8;
    boyfriend.cameraOffset.x -= 100; boyfriend.cameraOffset.y -= 20;

    var bg:FlxSprite = new FlxSprite(-600, -300, getModImage('Megalo Strike Back/chara-bg'));
    bg.antialiasing = Options.antialiasing;
    insert(1, bg);
}

function postCreate()
    loadHud('KadeEngine', '1.4.1');