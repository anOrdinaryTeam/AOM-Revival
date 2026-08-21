import AomText;

var fuckingcomboCamera:FlxCamera = new FlxCamera();
public var vsScore:AomText;
public var vsMisses:AomText;
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

    vsScore = new AomText(iconP2.x - 70, offY, 'Score: 0', size);
    vsScore.setFormat(-1, 'none', 'OUTLINE', 6, FlxColor.BLACK);
    vsScore.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, vsScore);

    vsMisses = new AomText(iconP1.x + 90, offY, 'Misses: 0', size);
    vsMisses.setFormat(-1, 'none', 'OUTLINE', 6, FlxColor.BLACK);
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