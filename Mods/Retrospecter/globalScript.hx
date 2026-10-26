// For Modcharts
public var defaultNotePos:Array<Float> = [];
public var defaultNotePosDad:Array<Float> = [];
public var camHudAngle:Float = 0;

function onNoteCreation(e) {
    e.note.strumRelativePos = false;
    e.note.noteAngle = 0.001;
}

function onStrumCreation(e)
    e.strum.extraCopyFields.push('alpha');

function postCreate() for (i in 0...4) {
    defaultNotePos[i] = [player.members[i].x, player.members[i].y];
    defaultNotePosDad[i] = [cpu.members[i].x, cpu.members[i].y];
}

function update(elapsed:Float)
{
    var currentBeat = (Conductor.songPosition / 1000) * (Conductor.bpm / 60);
    camHUD.angle = camHudAngle;

    scripts.callOne('onUpdateModchart', currentBeat);
}

// For Both Strums
public function setActorX(val:Float, i:Int)
{
    cpu.members[i].x = defaultNotePosDad[i][0] + val;
    player.members[i].x = defaultNotePos[i][0] + val;
}

public function setActorY(val:Float, i:Int)
{
    cpu.members[i].y = defaultNotePosDad[i][1] + val;
    player.members[i].y = defaultNotePos[i][1] + val;
}

public function setAngle(val:Float, i:Int)
{
    cpu.members[i].angle = val;
    player.members[i].angle = val;
}

public function tweenFadeIn(id:Int, val:Float, time:Float)
{
    var playerStrum = player.members[id];
    var cpuStrum = cpu.members[id];

    FlxTween.cancelTweensOf(playerStrum);
    FlxTween.tween(playerStrum, {angle: val}, time);

    FlxTween.cancelTweensOf(cpuStrum);
    FlxTween.tween(cpuStrum, {angle: val}, time);
}

public function tweenAngle(id:Int, time:Float)
{
    var playerStrum = player.members[id];
    var cpuStrum = cpu.members[id];

    var toAngle:Float = (playerStrum.angle + 360);
    FlxTween.cancelTweensOf(playerStrum);
    FlxTween.tween(playerStrum, {angle: toAngle}, time);

    var toAngle:Float = (cpuStrum.angle + 360);
    FlxTween.cancelTweensOf(cpuStrum);
    FlxTween.tween(cpuStrum, {angle: toAngle}, time);
}

public function tweenPosXAngle(id:Int, time:Float)
{
    player_tweenPosX(id, defaultNotePos[id][0], time);
    cpu_tweenPosX(id, defaultNotePosDad[id][0], time);
    tweenAngle(id, time);
}

// For a Single Strum

// Player
public function setPlayerX(val:Float, i:Int)
    player.members[i].x = defaultNotePos[i][0] + val;

public function setPlayerY(val:Float, i:Int)
    player.members[i].y = defaultNotePos[i][1] + val;

public function player_tweenPosX(id:Int, val:Float, time:Float)
{
    var strum = player.members[id];
    FlxTween.cancelTweensOf(strum);
    FlxTween.tween(strum, {x: val}, time);
}

public function player_tweenFadeOut(id:Int, val:Float, time:Float)
{
    var strum = player.members[id];
    FlxTween.cancelTweensOf(strum);
    FlxTween.tween(strum, {alpha: val}, time);
}

// Opponent
public function setCpuX(val:Float, i:Int)
    cpu.members[i].x = defaultNotePosDad[i][0] + val;

public function setCpuY(val:Float, i:Int)
    cpu.members[i].y = defaultNotePosDad[i][1] + val;

public function cpu_tweenPosX(id:Int, val:Float, time:Float)
{
    var strum = cpu.members[id];
    FlxTween.cancelTweensOf(strum);
    FlxTween.tween(strum, {x: val}, time);
}

public function cpu_tweenFadeOut(id:Int, val:Float, time:Float)
{
    var strum = cpu.members[id];
    FlxTween.cancelTweensOf(strum);
    FlxTween.tween(strum, {alpha: val}, time);
}