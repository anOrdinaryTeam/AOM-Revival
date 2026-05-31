function sprite(str:String)
    return getModImage('Heathers/$str');

var spotlight:FlxSprite;
var spotlightFront:FlxSprite;

var shadows:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
public var heatherd:Character = new Character(-66, 74, 'Heathers/heatherd');

var boomspeed:Float = 4;
var bam:Float = 4;
camZooming = true;
introLength = 0;

function create() {
    defaultCamZoom = 1.1;
    camGame.followLerp = 0.04 * 2;

    insert(getObjectOrder(dad), heatherd);

    bg = new FlxSprite(-589, -170, sprite('BG'));
    bg.antialiasing = Options.antialiasing;
    bg.shader = new CustomShader('colorSwap');
    bg.shader.uHsv = [40, 0, 0];
    addSprite(bg);

    reflec = new FlxSprite(-239,662-43, sprite('reflection'));
    reflec.antialiasing = Options.antialiasing;
    addSprite(reflec);

    var pos:Array<Array<Float>> = [
        [484, 726],
        [877, 720],
        [-44, 726],
        [877, 720]
    ];
    for (i in 0...4) {
        var shadow:FlxSprite = new FlxSprite(pos[i][0], pos[i][1], sprite('shadow'));
        shadow.antialiasing = Options.antialiasing;
        shadows.add(shadow);
    }
    addSprite(shadows);

    spotlight = new FlxSprite(-502,-327, sprite('spotlight2'));
    spotlight.antialiasing = Options.antialiasing;
    addSprite(spotlight);

    spotlightFront = new FlxSprite(-502,-327, sprite('spotlight'));
    spotlightFront.antialiasing = Options.antialiasing;
    spotlightFront.blend = 9;
    add(spotlightFront);

    gf.alpha = 0.001;
    boyfriend.alpha = 0.001;
    heatherd.alpha = 0.001;
    camHUD.alpha = 0.001;
}

var c:Int = 2;
var offY:Float = 0;
var d:Float = 210;

function postCreate() {
    for (bye in [scoreTxt, missesTxt, accuracyTxt, healthBar, healthBarBG, iconP1, iconP2])
        bye.visible = false;

    for (bye in cpuStrums)
        bye.visible = false;

    offY = player.members[0].y;
    player.forEachAlive(strum -> {
        FlxTween.tween(strum, {y: offY - (d * c)}, 0.01);
    });
}

function postUpdate() {
    spotlight.flipX = curCameraTarget == 1;
    spotlightFront.flipX = curCameraTarget == 1;

    shadows.members[2].setPosition(heatherd.x - 16, heatherd.y + 605);
    shadows.members[3].setPosition(gf.x, gf.y + 560);
}

var skin:String = "modNotes/heathers";
function onNoteCreation(_) {
    if (_.strumLineID == 1 && usingSkins) return;
    _.noteSprite = skin;
    if (_.strumLineID == 1) _.note.splash = 'heathers';
}

function onStrumCreation(_) {
    if (_.player == 1 && usingSkins) return;
    _.sprite = skin;
}

function TweenZoom(z:Float, t:Float) {
    FlxTween.cancelTweensOf(camGame);
    FlxTween.tween(camGame, {zoom: z}, t, {ease: FlxEase.sineInOut, onComplete: () -> defaultCamZoom = z});
}

function setBoom(spd:Float, boom:Float) {
    boomspeed = spd;
    bam = boom;
}

function addCamZoom(val1:Float, val2:Float) {
    FlxG.camera.zoom += val1;
    camHUD.zoom += val2;
}

function beatHit() {
    switch(curBeat) {
        case 31:
            camGame.flash(-1, 0.4, true);

            gf.alpha = 1;
            boyfriend.alpha = 1;
            heatherd.alpha = 1;
            camHUD.alpha = 1;

            spotlight.visible = false;
            spotlightFront.visible = false;

            opponentCam.x += 100;
            opponentCam.y += 20;
        case 75: player.forEachAlive(strum -> {
            FlxTween.tween(strum, {y: offY}, 2 * Conductor.crochet / 1000, {ease: FlxEase.elasticOut});
        });
        case 196:
            camHUD.flash(-1, 0.5, true);
            spotlightFront.visible = true;
        case 212: camGame.visible = false;
        case 213:
            camHUD.flash(-1, 0.5, true);
            camGame.visible = true;
        case 235: FlxTween.tween(spotlightFront, {alpha: 0}, 0.3);
        case 236:
            gf.danceOnBeat = false;
            gf.playAnim('walk');
            FlxTween.tween(gf, {x: 625, y: 148}, Conductor.crochet * 0.005);

            heatherd.danceOnBeat = false;
            heatherd.playAnim('walk');
            FlxTween.tween(heatherd, {x: 261, y: 117}, Conductor.crochet * 0.006);
        case 241:
            gf.danceOnBeat = true;
            gf.dance();
        case 242:
            heatherd.danceOnBeat = true;
            heatherd.dance();
        case 292, 293, 392, 395:
            camGame.flash(-1, 0.5, true);
        case 396:
            camHUD.visible = false;
            camGame.visible = false;
    }

    if (curBeat % boomspeed == 0) {
        FlxG.camera.zoom += 0.015 * bam;
        camHUD.zoom += 0.03 * bam;

        if (camGame.zoom >= 1.35) {
            camGame.zoom += 0.025 * bam;
            camHUD.zoom += 0.03 * bam;
        }
    }
}

function stepHit() {
    if (curStep < 128)
        dad.playAnim('intro', true, 'NONE', false, 24 * (Conductor.songPosition / 1000));

    switch(curStep) {
        case 0, 97: TweenZoom(1.4, 0.2);
        case 1: TweenZoom(1.3, 0.2);
        case 2: setBoom(4, 0.001);
        case 16: TweenZoom(1.6, 0.1);
        case 17, 96, 783: TweenZoom(1.5, 0.1);
        case 17: TweenZoom(1.5, 0.1);
        case 17, 53, 57, 61, 113, 117, 121, 125: TweenZoom(1.7, 0.1);
        case 50, 98: opponentCam.x += 100;
        case 52, 56, 112, 116, 120: TweenZoom(1.75, 0.1);
        case 60: TweenZoom(1.82, 0.1);
        case 64, 81: TweenZoom(1.1, 0.1);
        case 65: TweenZoom(1.2, 0.1);
        case 66, 83: opponentCam.x -= 100;
        case 80: TweenZoom(1, 0.1);
        case 124: TweenZoom(1.8, 0.1);
        case 127: TweenZoom(0.9, 0.2);
        case 240: TweenZoom(1.3, 3);
        case 308: TweenZoom(1.2, 0.2);
        case 312: TweenZoom(1.65, 0.2);
        case 316: TweenZoom(1.7, 0.2);
        case 320, 484, 756: TweenZoom(1.1, 0.2);
        case 321: TweenZoom(1.2, 0.2);
        case 480: TweenZoom(1.15, 0.2);
        case 488: TweenZoom(1.05, 0.2);
        case 492, 640, 1296: TweenZoom(0.9, 0.2);
        case 495, 752, 1168, 1200, 1232, 1264, 1551: TweenZoom(1, 0.2);
        case 499, 512, 544, 760, 1176, 1208, 1552: TweenZoom(1.2, 0.2);
        case 503, 520, 552, 584, 616, 769, 1154: TweenZoom(1.4, 0.2);
        case 507: TweenZoom(1.5, 0.2);
        case 513, 1166: setBoom(1, 1.4);
        case 576, 608, 784: TweenZoom(1.1, 0.2);
        case 621, 749: setBoom(1, 2);
        case 643: setBoom(1, 1.3);
        case 688, 1345: boyfriend.idleSuffix = '-alt';
        case 768: TweenZoom(1.6, 2);
        case 643: setBoom(4, 1.4);
        case 764, 1240, 1272, 1564: TweenZoom(1.3, 0.2);
        case 775: dad.idleSuffix = '-alt';
        case 786: setBoom(4, 0.1);
        case 792: defaultCamZoom = 1.3;
        case 912: TweenZoom(1.5, 2);
        case 941, 1136: TweenZoom(0.9, 0.3);
        case 976: TweenZoom(1.1, 0.3);
        case 1104: defaultCamZoom = 1;
        case 1120: defaultCamZoom = 1.1;
        case 1128: defaultCamZoom = 1.2;
        case 1150, 1174: setBoom(1, 1.2);
        case 1536: TweenZoom(1.7, 0.04);
        case 1537: TweenZoom(1.55, 0.04);
        case 1566: TweenZoom(1.25, 0.2);
        case 1568: TweenZoom(0.9, 0.1);

        case 1580: TweenZoom(1.1, 0.01);
        case 1581: TweenZoom(1.3, 0.01);
        case 1582: TweenZoom(1.5, 0.01);

        case 496, 500, 504, 508:
            addCamZoom(0.015, 0.03);
    }
}