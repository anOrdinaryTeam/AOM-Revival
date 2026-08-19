import flixel.text.FlxBitmapText;

var fuckingcomboCamera:FlxCamera = new FlxCamera();
public var vsScore:FlxBitmapText;
public var vsMisses:FlxBitmapText;
doIconBop = false;

function onHudLoad(hud) if (hud == 'VS-Online') {
    var offY:Float = downscroll ? healthBar.y - 65 : healthBar.y + 25;
    var size:Int = 0.3;

    for (items in [healthBar, healthBarBG])
        items.y -= downscroll ? 10 : 15;

    if (downscroll) for (icons in [iconP1, iconP2])
        icons.y -= 5;

    fuckingcomboCamera.bgColor = 0;
    FlxG.cameras.insert(fuckingcomboCamera, 1, false);
    PlayState.instance.comboGroup.x -= 130;
    // camGame.followLerp = 0.025;

    vsScore = new FlxBitmapText(iconP2.x - 70, offY, 'Score: 0', getBitmapFont('VCR'));
    setBmdFormat(vsScore, FlxColor.WHITE, 'none', 'OUTLINE', 6, FlxColor.BLACK);
    setBmdSize(vsScore, size);
    vsScore.antialiasing = true;
    vsScore.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, vsScore);

    vsMisses = new FlxBitmapText(iconP1.x + 90, offY, 'Misses: 0', getBitmapFont('VCR'));
    setBmdFormat(vsMisses, FlxColor.WHITE, 'none', 'OUTLINE', 6, FlxColor.BLACK);
    setBmdSize(vsMisses, size);
    vsMisses.antialiasing = true;
    vsMisses.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, vsMisses);
}

var normalSize:Float = 0.85;
var onBeatSize:Float = 0.95;
var lerpAmont:Float = 0.3;

function update() for (icon in [iconP1, iconP2]) {
    var lerp:Float = lerp(icon.scale.x, normalSize, lerpAmont);
    icon.scale.set(lerp, lerp);
    icon.updateHitbox();
}

function postUpdate()
    PlayState.instance.comboGroup.cameras = [fuckingcomboCamera];

function beatHit() for (icon in [iconP1, iconP2]) {
    if (curBeat % 1 == 0)
        icon.scale.set(onBeatSize + .05, onBeatSize);

    if (curBeat % 2 == 0)
        icon.scale.set(onBeatSize, onBeatSize);
}

function onRatingUpdate(_) {
    vsScore.text = 'Score: $songScore';
    vsMisses.text = 'Misses: $misses';
}

function onPlayerHit(e) {
    e.ratingScale = 0.5;
    e.numScale = 0.4;
}