var bg:FunkinSprite;
var floor:FunkinSprite;
var animToPlay:String = FlxG.save.data.AOM_flashingLights ? 'bop' : 'idle';

function create() {
    defaultCamZoom = 0.9;

    bg = new FunkinSprite(-388.05, -232);
    if (curSong == 'wife forever') {
        bg.loadSprite(getModImage('normal/bg_normal'));
        bg.addAnim("idle", "bg", 24, false, false, [5]);
        bg.addAnim("bop", "bg", 24, false);
        bg.scrollFactor.set(0, 1);
    }
    else if (curSong == 'sky') {
        bg.loadSprite(getModImage('normal/bg_annoyed'));
        bg.addAnim("idle", "bg2", 24, false, false, [5]);
        bg.addAnim("bop", "bg2", 24, false);
        bg.addAnim("manifest", "bgBOOM", 24, false);
        bg.scrollFactor.set(0, 1);
    }
    else {
        bg.loadSprite(getModImage('mad/bg_manifest'));
        bg.addAnim("idle", "bg_manifest", 24, false, false, [5]);
        bg.addAnim("bop", "bg_manifest", 24, false);
        bg.scrollFactor.set(0.4, 0.4);
    }
    bg.playAnim(animToPlay);
    bg.antialiasing = Options.antialiasing;
    addSprite(bg);

    if (curSong == 'manifest') {
        floor = new FunkinSprite(-1053.1, -464.7);
        floor.loadSprite(getModImage("mad/floorManifest"));
        floor.addAnim("idle", "floorManifest", 24, false, false, [5]);
        floor.addAnim("bop", "floorManifest", 24, false);
        floor.playAnim(animToPlay);
        floor.antialiasing = Options.antialiasing;
        floor.scrollFactor.set(0.9, 0.9);
        addSprite(floor);
    }
}

function beatHit() if (curBeat % gfSpeed == 0) {
    bg.playAnim(animToPlay);
    if (curSong == 'manifest') floor.playAnim(animToPlay);
}