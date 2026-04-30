import hxvlc.flixel.FlxVideoSprite;
var video:FlxVideoSprite;
introLength = 0;

function postCreate(){

    health += 1;

    loadHud('VS-Online', '');

    for (ic in [iconP1, iconP2,healthBarBG]){
        ic.visible = false;
    }

    for (hb in [healthBar]){
        hb.angle = 90;
        hb.x -= -236;
        hb.y -= 210;
    }

    var strumBG:FlxSprite = new FlxSprite().makeSolid(230*2,360*2, 0xFF000000);
    strumBG.setPosition(410,0);
    strumBG.camera = camHUD;
    strumBG.alpha = 0.5;
    insert(1, strumBG);

    video = new FlxVideoSprite(-320, -178);
    video.load(Paths.video('LPR/loopingtherooms'));
    video.bitmap.onEndReached.add(video.destroy);
    video.camera = camHUD;
    video.antialiasing = true;
    video.scale.set(0.67,0.67);
    video.updateHitbox();
    insert(0, video);
    
}

function onSongStart() video.play();

function onFocus() if (paused) {
    if (video != null) video.pause();
}
else {
    if (video != null) video.resume();
}

function onGamePause() {
    paused = true;
    persistentUpdate = false;
    persistentDraw = true;
    if (video != null) video.pause();
}

function update() {
    if (!paused) {
        if (video != null) video.resume();
    }
}

function onPlayerHit(e) e.healthGain = 0.025;
function onPlayerMiss(e) e.healthGain = -0.15;