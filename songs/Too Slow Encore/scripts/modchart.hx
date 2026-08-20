// copied and pasted from my W.I current Recreation

var defaultNotePos:Array<Float> = [];
var defaultNotePosDad:Array<Float> = [];
var setting:FlxPoint = FlxPoint.get(0, 0);

function postCreate() for (i in 0...4) {
    defaultNotePos[i] = [player.members[i].x, player.members[i].y];
    defaultNotePosDad[i] = [cpu.members[i].x, cpu.members[i].y];
}

function update(dt) if (setting.x != 0 || setting.y != 0) {
    var currentBeat = (Conductor.songPosition / 1000) * (Conductor.bpm / 60);

    for (i => bfStrum in player.members) {
        var dadStrum = cpu.members[i];

        var xOffset:Float = defaultNotePosDad[i][0] + setting.x * FlxMath.fastSin((currentBeat + i * 0.25) * Math.PI);
        var yOffset:Float = defaultNotePosDad[i][1] + setting.y * FlxMath.fastCos((currentBeat + i * 0.25) * Math.PI);
        setStrum(dadStrum, xOffset, yOffset);

        var xOffset:Float = defaultNotePos[i][0] + setting.x * FlxMath.fastSin((currentBeat + i * 0.25) * Math.PI);
        var yOffset:Float = defaultNotePos[i][1] + setting.y * FlxMath.fastCos((currentBeat + i * 0.25) * Math.PI);
        setStrum(bfStrum, xOffset, yOffset);
    }
}

function setStrum(str:Dynamic, x:Float, y:Float) {
    if (str == null) return;
    str.x = x; str.y = y;
}

function stepHit() switch(curStep) {
    case 544: setting.y = -2;
    case 672: setting.set(-2, 0);
    case 800: setting.set(-4, -3);
    case 928, 1312: setting.set(0, 0);
    case 1184: setting.x = -3;
    case 1504: FlxTween.tween(setting, {y: -4}, 3);
    case 1760: FlxTween.tween(setting, {x: -4}, 3);
    case 1888: FlxTween.tween(setting, {x: 0, y: 0}, 5);
}