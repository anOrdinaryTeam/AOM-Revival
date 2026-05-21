public function SprPath(str:String)
    return getModImage('NP/$str');

function pushSprite(spr:Dynamic) if (spr != null) {
    spr.antialiasing = Options.antialiasing;
    setObjectOrder(spr, getObjectOrder(dad));
}

public var camOther:FlxCamera = new FlxCamera();

var forest:FlxSprite;
var text:FlxSprite;
var effect:FlxSprite;
var custard:FlxSprite;

function create() {
    camOther.bgColor = 0;
    FlxG.cameras.add(camOther, false);

    defaultCamZoom = 0.47;
    usePsychSplashes = true;

    forest = new FlxSprite(44, 280, SprPath('dayforest/forest'));
    forest.scale.set(2.0, 2.0);
    forest.updateHitbox();
    pushSprite(forest);

    custard = new FlxSprite(990, 1200, SprPath('dayforest/custard'));
    custard.scale.set(0.3, 0.3);
    custard.updateHitbox();
    custard.alpha = 0.001;
    pushSprite(custard);
}

function postCreate() {
    for (i in 2...6)
        graphicCache.cache(SprPath('dayforest/forest$i'));

    for (i in 0...2) {
        var border:FlxSprite = new FlxSprite().makeSolid(160, 720, FlxColor.BLACK);
        border.camera = camOther;
        if (i == 1) border.x = (FlxG.width - border.width);
        add(border);
    }

    effect = new FlxSprite(135, -20, SprPath('screeneffect'));
    effect.scale.set(0.67, 0.5);
    effect.updateHitbox();
    effect.camera = camOther;
    effect.alpha = 0.001;
    add(effect);

    boyfriend.scale.set(1, 1);
    boyfriend.alpha = 0.001;

    camGame.followLerp *= 1.7;
    player.forEachAlive(n -> n.x -= 80);
    scoreTxt.visible = accuracyTxt.visible = missesTxt.visible = false;
}

function onSongStart() {
    text = new FlxSprite(610, 10, SprPath('dayforest/text'));
    text.antialiasing = Options.antialiasing;
    text.scale.set(0.6, 0.6);
    text.updateHitbox();
    text.camera = camOther;
    add(text);
}

var appeared:Bool = false;
var growing:Bool = false;

var maxScale:Float = 6;
var growTime:Float = 60;

var chaseFirst:Bool = false;
var tinkyScale:Float = 1;

var chaseTwo:Bool = false;
var tinkyScale2:Float = 1;

var tinkyStartScale:Float = 1.2;

var custardGrowing:Bool = false;
var custardGrowTime:Float = 18;
var custardMaxScale:Float = 2.3;

function update(dt) {
    var songTime:Float = Conductor.songPosition / 1000;

    if (songTime >= 10 && !appeared) {
        appeared = true;
        growing = true;

        FlxTween.tween(boyfriend, {alpha: 1}, 4);
    }

    if (growing && boyfriend != null) {
        var curScale:Float = boyfriend.scale.x;

        if (curScale < maxScale) {
            var step:Float = (maxScale - 2) / growTime;
            var newScale:Float = curScale + step * dt;
            if (newScale > maxScale) newScale = maxScale;

            boyfriend.scale.set(newScale, newScale);
        }
    }

    if (chaseFirst && dad != null) {
        var minScale:Float = 0.6;
        var maxScaleValue:Float = 2.4;
        var healthPercent:Float = health / 2;
        var targetScale:Float = maxScaleValue - ((maxScaleValue - minScale) * healthPercent);

        tinkyScale = tinkyScale + (targetScale - tinkyScale) * (dt * 5);

        var centerX:Float = (dad.x + dad.width) / 2;
        var centerY:Float = (dad.y + dad.height) / 2;

        dad.scale.set(tinkyStartScale * tinkyScale, tinkyStartScale * tinkyScale);
        dad.x = centerX - (dad.width / 2);
        dad.y = centerY + (dad.height / 2);
    }

    if (custardGrowing && custard != null) {
        var curScale:Float = custard.scale.x;

        if (curScale < custardMaxScale) {
            var step:Float = (custardMaxScale - 0.1) / custardGrowTime;
            var newScale:Float = curScale + step * dt;
            if (newScale > custardMaxScale) newScale = custardMaxScale;

            custard.scale.set(newScale, newScale);
        }
        else {
            custardGrowing = false;
            FlxTween.tween(custard, {y: FlxG.height + 2000}, 1.3, {ease: FlxEase.cubeIn});
        }
    }
}

function stepHit() switch(curStep) {
    case 32: remove(text, true);
    case 318:
        growing = false;
        forest.alpha = 0.001;
        boyfriend.scale.set(1, 1);
    case 335:
        changeBg(2);
        forest.x = 95;
        forest.alpha = 1;
    case 608:
        forest.alpha = 0.001;
        effect.alpha = 1;
        chaseFirst = true;
    case 736:
        chaseFirst = false;
        changeBg(3);
        forest.alpha = 0.2;
        effect.alpha = 0.01;
    case 864:
        changeBg(4);
        forest.alpha = 0.1;
        boyfriend.alpha = 0;
    case 896, 960:
        boyfriend.alpha = 1;
        dad.alpha = 0;
    case 928:
        boyfriend.alpha = 0;
        dad.alpha = 1;
    case 992:
        changeBg(5);
        forest.alpha = 0.2;
        iconP2.alpha = 0;
        boyfriend.alpha = 0;
        custard.alpha = 1;
        custardGrowing = true;
    case 1120:
        custard.alpha = 0;
        iconP2.alpha = 1;
        boyfriend.alpha = 1;
        dad.alpha = 1;
        forest.alpha = 0;
        effect.alpha = 1;
    case 1248:
        dad.alpha = 0;
        boyfriend.alpha = 0;
        effect.alpha = 0;
}

function onDadHit(e) if (!e.note.isSustainNote && health > 0.25)
    health -= 0.019;

function changeBg(to:Int)
    forest.loadGraphic(SprPath('dayforest/forest$to'));