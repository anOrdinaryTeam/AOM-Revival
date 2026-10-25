// For Modcharts
public var defaultNotePos:Array<Float> = [];
public var defaultNotePosDad:Array<Float> = [];

function onNoteCreation(e) {
    e.note.strumRelativePos = false;
    e.note.noteAngle = 0.001;
}

function postCreate() for (i in 0...4) {
    defaultNotePos[i] = [player.members[i].x, player.members[i].y];
    defaultNotePosDad[i] = [cpu.members[i].x, cpu.members[i].y];
}

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