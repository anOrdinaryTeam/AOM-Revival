public var lockZoom:Bool = false;
var dadZoom = 0.5;
var bfZoom = 0.625;
var turn;

function onEvent(_) if (_.event.name == 'Camera Movement') if (!lockZoom) {
    if (_.event.params[0] == 0) {
        turn = 'dad';
        defaultCamZoom = 0.625;
    }
    else if (_.event.params[0] == 1) {
        turn = 'bf';
        defaultCamZoom = 0.5;
    }
}

function addCameraZoom() {
    camGame.zoom += 0.015;
	camHUD.zoom += 0.03;
}

function setZoom(i:Float){
    if (i == 1) defaultCamZoom = turn == 'dad' ? 0.625 : 0.5;
    else defaultCamZoom *= i;
}

function zoomIn(i:Float) {
    if (i == 0) defaultCamZoom = turn == 'dad' ? 0.625 : 0.5;
    else defaultCamZoom += i;
}

function forcedZoom(i:Float, ?lock:Bool = true) {
    lockZoom = lock;

    addCameraZoom();
    defaultCamZoom = i;
    FlxG.camera.zoom = i;
}

function hurt() if (health > 0.5) health -= 0.05;
function onNoteHit(_) if (_.noteType == 'Alt Animation') _.animSuffix = "-alt";

function stepHit() {
    if (curStep >= 1680 && curStep <= 1725 || curStep >= 1744 && curStep <= 1789)
        if (curStep % 4 == 0) addCameraZoom();

    switch(curStep) {
    // - sub events
        // set zoom's
        case 640: setZoom(1.45);
        case 864, 2538, 2570: setZoom(1.15);
        case 2544, 2576: setZoom(1);

        // zoom in's
        case 2336, 2400, 2640: zoomIn(0.05);
        case 2352, 2416, 2656, 3507: zoomIn(0); // ?
        case 3376: zoomIn(0.1);
        case 3407: zoomIn(0.05);
        case 3464:
            zoomIn(0.1);
            MyWayEvents('txt');
        case 3472:
            zoomIn(0.1);
            MyWayEvents('txt');

        // forced zoom's & hurt's events
        case 1824:
            forcedZoom(0.65);
            hurt();
        case 1830:
            forcedZoom(0.675);
            hurt();
        case 1836:
            forcedZoom(0.7);
            hurt();
        case 1856:
            forcedZoom(0.725);
            hurt();
        case 1862:
            forcedZoom(0.75);
            hurt();
        case 1868:
            forcedZoom(0.775);
            hurt();
        case 1872: lockZoom = false;

        // add cameras zooms
        case 1428, 1440, 1444, 1456, 1460, 1472, 1476, 1488, 1492, 1504, 1508, 1520, 1524, 1536,
            1540, 1552, 1556, 1568, 1572, 1582, 1588, 1600, 1604, 1615, 1620, 1632, 1636, 1648, 1652,
            1664, 1668, 1728, 1792, 2052, 2056, 2060, 2464, 2466, 2467, 2469, 2470, 2496, 2498, 2499, 
            2501, 2502, 2505, 2508, 2510, 2512, 2704, 2728, 2736, 2756, 2762, 2768, 2792, 2800, 2816,
            2824: addCameraZoom();

    // - main events
        case 128:
            black.alpha = 0;
            camGame.visible = true;
        case 1408:
            changeCharacter(0, 'transLookalike');
            dad.playAnim('Smallize');
            dad.animation.callback = (Anim, Frame) -> {
                if (Anim == 'Smallize' && Frame == 18)
                    opponentCam.y += 250;
            }
        case 1424:
            changeCharacter(0, 'bf-lookalike');
            iconOpp.animation.play('2');
        case 2044:
            changeCharacter(0, 'transLookalike2');
            dad.playAnim('Bigize');
            opponentCam.y -= 250;
        case 2048:
            addCameraZoom();
            iconOpp.animation.play('0');
        case 2063: 
            changeCharacter(0, 'evilLookaLike');
            camZoomingInterval = 1;
        case 2192: camZoomingInterval = 4;
        case 2832: iconOpp.animation.play('3');
        case 3328: iconOpp.animation.play('4');
        case 3360: camGame.followLerp(0.75);
        case 3423: camGame.followLerp(1);

    // - My Way
        case 3336: MyWayEvents('pre');
        case 3362: MyWayEvents('anim');
        case 3440:
            zoomIn(0.05);
            MyWayEvents('break mirror');
        case 3481: MyWayEvents('black');
        case 3495: 
            MyWayEvents('vid');
            MyWayEvents('txt');
        case 3621: MyWayEvents('hud in');
        case 4176: MyWayEvents('die');
        case 3888:
            FlxTween.tween(black, {alpha: 0}, 2);
            lockZoom = false;
            dad.visible = true;
            IllMake.visible = false;

            var filter:CustomShader = new CustomShader('blue');
            filter.hue = 1.3;
            filter.pix = 0.00001;

            camGame.addShader(filter);
            camHUD.addShader(filter);

        case 3368, 3400, 3432, 3478, 3484, 3528, 3561, 3568, 3592, 3623, 3632,
            3696, 3752, 3872: MyWayEvents('txt');
    }
}

var numText:Float = 0;
var curText:Array<String> = [
    "I'LL MAKE", "YOU SAY", "HOW PROUD", "YOU", "YOU ARE", "YOU ARE OF", "YOU ARE OF ME",
    "SO STAY", "AWAKE", "JUST", "LONG", "ENOUGH TO SEE", "MY", "MY WAY", "", "MY WAY", ""
];

function MyWayEvents(i:String) switch(i) {
    case 'pre':
        lockZoom = true;
        defaultCamZoom = 0.5;

        for (i in [accuracyTxt, scoreTxt, missesTxt]) FlxTween.tween(i, {alpha: 0}, 2, {ease: FlxEase.quadIn});
        for (i in items) FlxTween.tween(i, {alpha: 0}, 2, {ease: FlxEase.quadIn});
        for (i in player) FlxTween.tween(i, {alpha: 0}, 2, {ease: FlxEase.quadIn});
    case 'anim':
        dad.visible = false;
        IllMake.alpha = 1;
        IllMake.playAnim('play');
    case 'txt':
        lyrics.text = curText[numText];
        lyrics.screenCenter(FlxAxes.X);
        numText++;
    case 'break mirror':
        mirror.loadGraphic(BillyPath('broken_mirror'));
        playModSound('mirror_break');

        FlxTween.num(255, 0, 1.75, {ease: FlxEase.quadOut, onUpdate: function(twn){ mirror.setColorTransform(1,1,1,1,twn.value,twn.value,twn.value,0);}});
        camGame.shake(0.01, 0.25);
    case 'black':
        remove(black);
        insert(2, black);

        FlxTween.tween(black, {alpha: 1}, 1.125, {ease: FlxEase.quadOut});
        FlxTween.tween(this, {defaultCamZoom: 1.125}, 0.75, {ease: FlxEase.backIn});
    case 'vid':
        MyWay.play();
        FlxTween.tween(MyWay, {alpha: 1}, 0.125 * 1.5, {ease: FlxEase.quadOut});
    case 'hud in': for (i in player) FlxTween.tween(i, {alpha: 1}, 1.5, {ease: FlxEase.quadIn});
    case 'die': black.alpha = 1;
}

function onChangeCharacter(_, char) switch(char) {
    case 'transLookalike' | 'bf-lookalike' | 'transLookalike2' | 'evilLookaLike':
        dad.camera = camGame;
}