importScript('data/scripts/TrickyLines');

public var sanford:FunkinSprite;
public var deimos:FunkinSprite;
public var helicopter:FunkinSprite;
public var boombox:FunkinSprite;
public var lever:FunkinSprite;

public var floor:FlxSprite;
public var laser:FlxSprite;

public var gfHotdog:FunkinSprite = new Character(1800, 540, 'Accelerant/gfHotDog');
public var gfArmsUp:Character = new Character(335, 275, 'Accelerant/gfArmsUp');
public var tricky:Character = new Character(95, -330, 'Accelerant/tricky-acc');

public var shootAtTricky:Bool = false;
public var canGruntsSpawn:Bool = false;
var drainHealth:Bool = false;

public var curLaserPoint:Float = 10;
public var laserLerp:Float = 0.1;
public var laserBop:Float = 20;
var trickyOffScreen:Float = 1500;

var redFilter:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.RED);
var hellclownLayer:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var gruntsLayer:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();

function BG(str:String) return getModImage('Accelerant/$str');
using StringTools;

function create() {
    defaultCamZoom = 0.7;

    var bg:FlxSprite = new FlxSprite().loadGraphic(BG('bg'));
    bg.antialiasing = Options.antialiasing;
    bg.scale.set(1.3, 1.1);
    bg.updateHitbox();
    bg.scrollFactor.set(0.1, 0.1);
    bg.screenCenter();
    bg.x += 200;
    bg.y -= 190;
    addSprite(bg);

    helicopter = new FunkinSprite(-1500, -160).loadSprite(BG('helicopter'));
    helicopter.scale.set(1.1, 1.1);
    helicopter.updateHitbox();
    helicopter.addAnim('play', 'Helicopter', 24, true);
    helicopter.playAnim('play');
    helicopter.color = 0x847F7F;
    addSprite(helicopter);

    var cliffs:FlxSprite = new FlxSprite().loadGraphic(BG('cliffs'));
    cliffs.antialiasing = Options.antialiasing;
    cliffs.scrollFactor.set(0.8, 0.8);
    cliffs.scale.set(1.5, 1.4);
    cliffs.updateHitbox();
    cliffs.screenCenter();
    cliffs.x -= 120;
    cliffs.y += 80;
    addSprite(cliffs);

    if (curDiff == 'fucked') {
        addSprite(hellclownLayer);

        var head:FunkinSprite = new FunkinSprite(10, -600).loadSprite(BG('hellClown/head'));
        head.addAnim('idle', 'HellClownIdle', 24, true);
        head.playAnim('idle');
        head.antialiasing = Options.antialiasing;
        head.scale.set(0.9, 0.9);
        head.updateHitbox();
        hellclownLayer.add(head);

        var scale:Float = 0.9;
        var handL:FunkinSprite = new FunkinSprite(-400, 0).loadSprite(BG('hellClown/hand'));
        handL.addAnim('idle', 'HellClownHandsIdle', 24, true);
        handL.playAnim('idle');
        handL.antialiasing = Options.antialiasing;
        handL.scale.set(scale, scale);
        handL.updateHitbox();
        hellclownLayer.add(handL);

        var handR:FunkinSprite = new FunkinSprite(700, 0).loadSprite(BG('hellClown/hand'));
        handR.addAnim('idle', 'HellClownHandsIdle', 24, true);
        handR.playAnim('idle');
        handR.antialiasing = Options.antialiasing;
        handR.flipX = true;
        handR.scale.set(scale, scale);
        handR.updateHitbox();
        hellclownLayer.add(handR);

        for (hide in hellclownLayer)
            hide.y += trickyOffScreen;

        redFilter.alpha = 0.01;
        redFilter.camera = camHUD;
        insert(1, redFilter);
    }

    sanford = new FunkinSprite(1100, -230).loadSprite(BG('sanford'));
    sanford.antialiasing = Options.antialiasing;
    sanford.scrollFactor.set(0.8, 0.8);
    sanford.scale.set(1.1, 1.1);
    sanford.updateHitbox();
    sanford.addAnim('entering', 'EnteringAnimSanford', 24, false);
    sanford.addAnim('idle', 'SanfordIdle', 24, false);
    sanford.addAnim('shoot', 'SanfordShoot', 24, false);
    sanford.addOffset('entering', 10, 365);
    sanford.animation.callback = (Anim) -> {
        if (Anim == 'entering') sanford.flipX = true;
    }
    sanford.animation.finishCallback = (Anim) -> {
        if (Anim == 'entering') {
            sanford.flipX = false;
            sanford.playAnim('idle');
        }
        else if (Anim == 'shoot')
            sanford.playAnim('idle');
    }
    sanford.playAnim('idle');
    sanford.color = 0x847F7F;
    addSprite(sanford);

    deimos = new FunkinSprite(-580, -200).loadSprite(BG('deimos'));
    deimos.antialiasing = Options.antialiasing;
    deimos.scrollFactor.set(0.8, 0.8);
    deimos.scale.set(1.1, 1.1);
    deimos.updateHitbox();
    deimos.addAnim('entering', 'EnteringAnimDeimos', 24, false);
    deimos.addAnim('idle', 'DeimosIdle', 24, false);
    deimos.addAnim('shoot', 'DeimosShoot', 24, false);
    deimos.addOffset('entering', 70, 335);
    deimos.animation.finishCallback = (Anim) -> {
        if (Anim == 'entering') {
            deimos.playAnim('idle');

            gf.alpha = 0;
            new FlxTimer().start(0.1, () -> {
                laser.alpha = laser.alpha == 0.001 ? 1 : 0.001;
            }, 3);

            gfArmsUp.alpha = boombox.alpha = 1;
            gfArmsUp.playAnim('upArms', true);
            gfArmsUp.animation.finishCallback = (Anim) -> {
                if (Anim == 'upArms') {
                    gfArmsUp.dance();
                    gfArmsUp.danceOnBeat = true;
                }
            }
        }
        else if (Anim == 'shoot')
            deimos.playAnim('idle');
    }
    deimos.playAnim('idle');
    deimos.color = 0x847F7F;
    addSprite(deimos);

    floor = new FlxSprite().loadGraphic(BG('floor'));
    floor.antialiasing = Options.antialiasing;
    floor.scale.set(1.5, 1.4);
    floor.updateHitbox();
    floor.screenCenter();
    floor.y += 370;
    addSprite(floor);

    boombox = new FunkinSprite(185, 265).loadSprite(BG('stereo'));
    boombox.antialiasing = Options.antialiasing;
    boombox.addAnim('boom', 'stereo boom', 24, false);
    boombox.alpha = 0.001;
    addSprite(boombox);

    if (curDiff == 'hard') {
        addSprite(gruntsLayer);
        graphicCache.cache(BG('grunts/grunt'));
        graphicCache.cache(BG('grunts/agent'));
        graphicCache.cache(BG('grunts/eng'));
    }

    gfHotdog.antialiasing = Options.antialiasing;
    addSprite(gfHotdog);

    gfArmsUp.danceOnBeat = false;
    gfArmsUp.alpha = 0.001;
    gfArmsUp.antialiasing = Options.antialiasing;
    addSprite(gfArmsUp);

    tricky.alpha = 0.001;
    tricky.antialiasing = Options.antialiasing;
    addSprite(tricky);

    var foreground:FlxSprite = new FlxSprite().loadGraphic(BG('foreground'));
    foreground.antialiasing = Options.antialiasing;
    foreground.scrollFactor.set(1.2, 1.2);
    foreground.scale.set(1.15, 1.2);
    foreground.color = 0x847F7F;
    foreground.updateHitbox();
    foreground.screenCenter();
    foreground.x -= 100;
    foreground.y += 350;
    add(foreground);

    sanford.alpha = deimos.alpha = 0.001;
}

function postCreate() {
    loadHud('VS-Online');

    laser = new FlxSprite(500, curLaserPoint, BG('laser'));
    laser.antialiasing = Options.antialiasing;
    laser.scale.set(1.2, 1.2);
    laser.updateHitbox();
    laser.alpha = 0.001;
    add(laser);

    if (curDiff == 'fucked') {
        lever = new FunkinSprite().loadSprite(BG('LeverAssets'));
        lever.antialiasing = Options.antialiasing;
        lever.addAnim('idle', 'Appear', 24, false);
        lever.addAnim('idleR', 'Appear', 24, false, false, [6, 5, 4, 3, 2, 1, 0]);
        lever.addAnim('pull', 'Pull', 24, false, false, [0, 1, 2, 3, 4, 5, 6]);
        lever.addAnim('pull-loop', 'Pull', 24, true, false, [7, 8, 9, 10, 11, 12, 13, 14, 15]);
        lever.addOffset('idle', 1, downscroll ? 29 : -24);
        lever.animation.callback = (Anim) -> {
            if (Anim == 'idle') lever.alpha = 1;
            else if (Anim == 'idleR') drainHealth = false;
        }
        lever.animation.finishCallback = (Anim) -> {
            if (Anim == 'idle') {
                lever.playAnim('pull');
                drainHealth = true;
            }
            else if (Anim == 'pull')
                lever.playAnim('pull-loop');
            else if (Anim == 'idleR')
                lever.alpha = 0.001;
        }
        lever.alpha = 0.001;
        lever.camera = camHUD;
        lever.scale.set(0.7, 0.7);
        lever.updateHitbox();
        lever.flipY = downscroll;
        lever.screenCenter();
        lever.y += downscroll ? 180 : 182;
        insert(getObjectOrder(healthBarBG) - 1, lever);
    }
}

function update() {
    var laserY:Float = lerp(laser.y, curLaserPoint, laserLerp);
    laser.y = laserY;

    if (curStep >= 662)
        laser.alpha = tricky.animation.curAnim.name == 'idle' ? 1 : 0;

    if (drainHealth)
        health -= 0.0015;
}

function beatHit() {
    laser.y += laserBop;
    boombox.playAnim('boom');

    if (sanford.animation.curAnim.name == 'idle')
        sanford.playAnim('idle', true);

    if (deimos.animation.curAnim.name == 'idle')
        deimos.playAnim('idle', true);

    if (canGruntsSpawn && curBeat % 6 == 0)
        spawnGrunts();
}

function spawnGrunts() {
    var amt:Int = FlxG.random.int(1, 2);
    var excludedOffs:Array<Int> = [];

    var offsets:Array<Array<Float>> = [
        [320, -108],
        [-400, 225],
        [980, 240]
    ];

    var grunts:Array<Array<String>> = [
        ['grunt', 'gruntclimbanddie'],
        ['agent', 'agentclimbanddie'],
        ['eng', 'engclimbanddie']
    ];

    for (i in 0...amt) {
        var gruntType:Int = FlxG.random.int(0, 2);
        var arr:Int = FlxG.random.int(0, 2, excludedOffs);
        var offset:Array<Float> = offsets[arr].copy();

        var sprite:String = grunts[gruntType][0];
        var anim:String = grunts[gruntType][1];
        var grunt:FunkinSprite = new FunkinSprite(offset[0] - 30, offset[1] - 90, BG('grunts/$sprite'));
        grunt.antialiasing = Options.antialiasing;
        grunt.addAnim('idle', anim, 24, false);
        grunt.playAnim('idle', true);
        gruntsLayer.add(grunt);

        excludedOffs.push(arr);
    }

    new FlxTimer().start(0.73, () -> {
        playModSound('argh', 0.6);
        deimos.playAnim('shoot', true);
        sanford.playAnim('shoot', true);

        new FlxTimer().start(0.6, gruntsLayer.clear);
    });
}

var executed:Bool = false;
public function hellClownShows() if (!executed) {
    executed = true;
    new FlxTimer().start(2, () -> {
        shootAtTricky = true;
        playModSound('Sound_clown_roar', 0.6);
    }); 

    FlxTween.tween(redFilter, {alpha: 0.09}, 5);
    for (clown in hellclownLayer)
        FlxTween.tween(clown, {y: clown.y - trickyOffScreen}, 5, {ease: FlxEase.quadInOut});
}