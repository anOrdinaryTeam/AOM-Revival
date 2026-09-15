function postCreate() {
    loadHud("KadeEngine", 'nose');
    doIconBop = false;

    var newBar:FlxSprite = new FlxSprite(healthBarBG.x, healthBarBG.y, getModImage('newBarBGw'));
    newBar.antialiasing = Options.antialiasing;
    newBar.camera = camHUD;
    newBar.x -= 40; newBar.y -= 20;
    insert(members.indexOf(healthBar) + 1, newBar);
    healthBarBG.visible = false;
}