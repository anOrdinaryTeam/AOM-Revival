var hitTime_player:Float = 0;
var hitTime_cpu:Float = 0;

function onPlayerHit(e) if (!e.note.isSustainNote && e.note.prevNote?.strumTime == e.note.strumTime)
    trace('Double - [PLAYER]');

function onDadHit(e) if (!e.note.isSustainNote && e.note.prevNote?.strumTime == e.note.strumTime)
    trace('Double - [OPPONENT]');