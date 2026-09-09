var gremlin:FunkinSprite;

function postCreate() {
    gremlin = new FunkinSprite().loadSprite(getModImage('stages/fourth/mech/HP GREMLIN'));
    gremlin.antialiasing = Options.antialiasing;
    gremlin.camera = camHUD;
    gremlin.animation.addByIndices('come','HP Gremlin ANIMATION',[0,1], "", 24, false);
	gremlin.animation.addByIndices('grab','HP Gremlin ANIMATION',[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24], "", 24, false);
	gremlin.animation.addByIndices('hold','HP Gremlin ANIMATION',[25,26,27,28],"",24);
	gremlin.animation.addByIndices('release','HP Gremlin ANIMATION',[29,30,31,32,33],"",24,false);
    gremlin.animation.onFinish.add((Anim) -> {
        if (Anim == 'release') gremlin.alpha = 0;
    });
    gremlin.setGraphicSize(Std.int(gremlin.width * 0.6));
    gremlin.updateHitbox();
    gremlin.setPosition(iconP1.x, iconP1.y + (downscroll ? 100 : -100));
    gremlin.alpha = 0.001;
    setObjectOrder(gremlin, getObjectOrder(iconP2) + 1);

    health += 1;
}

var grabbed:Bool = false;
var draining:Bool = false;

var gremlinSpaceX:Float = 50;
var startHealth:Float = 0;
var toHealth:Float = 0;
var tmrDrain:FlxTimer = new FlxTimer();

public function grabHealth(amount:Float, _time:Float) {
    var time:Float = _time;
    startHealth = health;
    toHealth = (amount / 100) * startHealth;
    grabbed = true;

    gremlin.alpha = 1;
    gremlin.setPosition((iconP1.x + gremlinSpaceX), iconP1.y + (downscroll ? -100 : -120));
    gremlin.playAnim('come');
    
    playModSound('GremlinWoosh');
    new FlxTimer().start(0.13, () -> gremlin.playAnim('grab'));
    new FlxTimer().start(1.13, () -> {
        tmrDrain?.cancel();
        tmrDrain.start(time, endGrab);

        draining = true;
    });
}

function endGrab() {
    grabbed = false;
    draining = false;
    gremlin.playAnim('release');
}

function postUpdate() if (grabbed && draining) {
    var lerp:Float = lerp(startHealth, toHealth, tmrDrain?.progress);
    health = lerp <= 0 ? 0.1 : lerp;
    gremlin.x = (iconP1.x + gremlinSpaceX);
}

function onPlayerHit(e) if (grabbed)
    e.healthGain = 0;

function onStartCountdown() new FlxTimer().start(25, (tmr) -> {
    if (curStep < 2400) {
        if (health >= 1.5 && !grabbed)
            grabHealth(40, 3);
        tmr.reset(25);
    }
});