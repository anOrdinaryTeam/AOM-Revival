var in:Int = 0;

var ballsGrp:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var ballScales:Array<Float> = [];
var ballPos:Array<Float> = [];
var fall:Array<Int> = [5];

var speed:Float = 0;
var gravity:Float = 9.8;
var exclusion:String = '5';

static function addSprite(spr:Dynamic) if (spr != null) {
    spr.antialiasing = Options.antialiasing;
    insert(in++, spr);
}

function create() {
    usePsychSplashes = true;
    useCamMov = true;
    camMoveAmt = 14;
    defaultCamZoom = 0.63 + 0.36;
    comboGroup.visible = false;

    for (i in 0...3) {
        var spr:String = ['sinkdepths', 'sinkfloor', 'sinkceiling'][i];
        var sprites:FlxSprite = new FlxSprite([-50, -50, -70][i], [-80, 0, -50][i], getModImage('Sink/$spr'));
        sprites.scale.set(1.11, 1.1);
        sprites.updateHitbox();
        addSprite(sprites);

        if (i == 3) sprites.scrollFactor.set(0.9, 0.9);
    }

    insert(2, ballsGrp);


    for (i in 0...9) {
        var scale:Float = FlxG.random.float(0.1, 1);
        ballScales.push(scale);
        ballPos.push(0);

        var ball:FlxSprite = new FlxSprite(-80 + 200 * i, -380, getModImage('Sink/ball'));
        ball.antialiasing = Options.antialiasing;
        ball.scale.set(scale, scale);
        ball.updateHitbox();
        ballsGrp.add(ball);
    }

    speed = 240 / Options.framerate;
}

var waves:FunkinSprite;

function postCreate() {
    loadHud('PsychEngine');
    dad.alpha = .001;
    iconP2.visible = false;

    waves = new FunkinSprite().loadSprite(getModImage('Sink/waves'));
    waves.addAnim('idle', 'idle', 13, true);
    waves.playAnim('idle');
    waves.scale.set(1280/512, 820/512);
    waves.updateHitbox();
    waves.alpha = 0.06;
    waves.blend = "subtract";
    waves.camera = camHUD;
    insert(1, waves);
    FlxTween.tween(waves, {alpha: 0.12}, 0.8, {type: 4});

    var vignette:FlxSprite = new FlxSprite(0,0, getModImage('Sink/vignette'));
    vignette.camera = camHUD;
    insert(2, vignette);
}

var dead:Bool = false;

function beatHit() {
    if (!dead && curBeat % 4 == 0 && curStep > 526 && curStep < 641) {
        FlxTween.tween(camGame, {zoom: camGame.zoom - (camGame.zoom - 0.63) / 8}, 8.8, {onComplete: function() {
            defaultCamZoom = camGame.zoom -= 0.36 / 8;
        }});
    }

    if (curBeat % 16 == 0 && fall.length < 10) {
        var rng:Int = FlxG.random.int(0, 9, exclusion);
        fall.insert(fall.length + 1, rng);
        exclusion = '$exclusion,$rng';
    }
}

function update() for (i in 0...fall.length)
    moveBall(fall[i]);

function moveBall(i:Int) {
    var songPos:Float = Conductor.songPosition / 1000;
    var ball:FlxSprite = ballsGrp.members[i];
    ballPos[i] += 0.003 * speed * ballScales[i];

    var yPos:Float = getHeight(-380, ballPos[i]);
    var xPos:Float = FlxMath.fastSin(songPos + i * 0.45) * 50 * ballScales[i] + -80 + 200 * i;
    if (yPos >= 1700) ballPos[i] = 0;

    ball.y = yPos;
    ball.x = xPos;
}

function getHeight(baseH:Float, time:Float) {
    var height:Float = 0;
    height = baseH + ((gravity) * time * time) / 2;
    return height;
}

var first:Bool = true;
var dos:Bool = true;

function onDadHit(_) {
    if (first) {
        first = !first;
        dad.alpha = 0.45;
        FlxTween.tween(dad, {alpha: 0}, 0.6);
    }
    else if (!first && dos) {
        dos = !dos;
        FlxTween.tween(dad, {alpha: 0.1}, 0.6, {type: 4});
    }
}

function onPlayerHit(e) e.healthGain = 0;
function onPlayerMiss(e) e.healthGain = 0;