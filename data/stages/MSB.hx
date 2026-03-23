function create() {
    defaultCamZoom = 0.8;
    dad.x -= 350;
    gf.x -= 350; gf.y -= 300;
    boyfriend.x -= 300; boyfriend.y -= 300;
    boyfriend.cameraOffset.x -= 100; boyfriend.cameraOffset.y -= 20;

    var bg:FlxSprite = new FlxSprite(-600, -300, getModImage('Megalo Strike Back/chara-bg'));
    bg.antialiasing = Options.antialiasing;
    insert(1, bg);
}