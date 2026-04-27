function onDadHit(e) if (e.noteType == 'Backers') {
    e.animCancelled = true;
    gf.playSingAnim(e.direction, true);
    heatherd.playSingAnim(e.direction, true);

    camHUD.zoom += 0.015;
    FlxG.camera.zoom += 0.015;
    FlxG.camera.shake(0.002, 0.1);
}