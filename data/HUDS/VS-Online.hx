public var vsScore:FunkinText;
public var vsMisses:FunkinText;
var fuckingcomboCamera:FlxCamera = new FlxCamera();
doIconBop = false;

function onHudLoad(hud) if (hud == 'VS-Online') {
    var offY:Float = downscroll ? healthBar.y - 65 : healthBar.y + 25;
    var size:Int = 22;

    for (items in [healthBar, healthBarBG])
        items.y -= downscroll ? 10 : 15;

    if (downscroll) for (icons in [iconP1, iconP2])
        icons.y -= 5;

    fuckingcomboCamera.bgColor = 0;
    FlxG.cameras.insert(fuckingcomboCamera, 1, false);
    PlayState.instance.comboGroup.x -= 130;

    vsScore = new FunkinText(iconP2.x - 70, offY, 0, 'Score: 0', size);
    vsScore.antialiasing = true;
    vsScore.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, vsScore);

    vsMisses = new FunkinText(iconP1.x + 90, offY, 0, 'Misses: 0', size);
    vsMisses.antialiasing = true;
    vsMisses.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, vsMisses);
}

var normalSize:Float = 0.9;
var onBeatSize:Float = 1;
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