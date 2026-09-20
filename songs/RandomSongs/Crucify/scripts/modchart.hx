// i hate this

var defPlayer = {x:[], y:[]};
var defOpp = {x:[], y:[]};

var PI:Float = Math.PI;

function postCreate() for (i in 0...player.members.length) {
    defPlayer.x.push(player.members[i].x);
    defPlayer.y.push(player.members[i].y);

    defOpp.x.push(cpu.members[i].x);
    defOpp.y.push(cpu.members[i].y);
}

function update(e) {
    var currentBeat:Int = (Conductor.songPosition / 1000) * (Conductor.bpm / 60);

    if ((curStep >= 0 && curStep < 12) || (curStep >= 16 && curStep < 28) || (curStep >= 32 && curStep < 44) || (curStep >= 48 && curStep < 60) || (curStep >= 64 && curStep < 76) || (curStep >= 80 && curStep < 92) || (curStep >= 96 && curStep < 108) || (curStep >= 112 && curStep < 124)) for (i in 0...4) {
        var xVal:Float = 25 * sin((currentBeat + i * 50) * PI);
        var yVal:Float = 5 * cos((currentBeat + i * 0.25) * PI);
        setBothX(xVal, i);
        setBothY(yVal, i);
    }

    if ((curStep >= 12 && curStep < 16) || (curStep >= 44 && curStep < 48) || (curStep >= 76 && curStep < 80) || (curStep >= 108 && curStep < 112)) for (i in 0...4) {
        var yVal:Float = -120 * cos((currentBeat + i * 10) * PI);
        setBothY(yVal, i);
    }

    if ((curStep >= 28 && curStep < 32) || (curStep >= 60 && curStep < 64) || (curStep >= 92 && curStep < 96)) for (i in 0...4) {
        var yVal:Float = 120 * cos((currentBeat + i * 10) * PI);
        setBothY(yVal, i);
    }

    if (curStep >= 124 && curStep < 126) for (i in 0...4) {
        var yVal:Float = 118 * cos(((currentBeat) + i * 10) * PI);
        setBothY(yVal, i);
    }

    if ((curStep >= 128 && curStep < 624) || (curStep >= 1152 && curStep < 1648)) for (i in 0...4) {
        var altCurBeat:Float = (Conductor.songPosition / 1000) * (Conductor.bpm / 120);
        var xVal:Float = 25 * sin((altCurBeat + i * 50) * PI);
        var yVal:Float = 5 * cos((altCurBeat + i * 0.25) * PI);
        setOppX(xVal, i);
        setOppY(yVal, i);
    }

    if ((curStep >= 640 && curStep < 896) || (curStep >= 1664 && curStep < 2176)) for (i in 0...4) {
        var val:Float = 5 * cos((currentBeat + i * 0.25) * PI);
        setBothY(val, i);
    }
}

function stepHit(step) {
    
}

function setOppX(value:Float, i:Int) cpu.members[i].x = defOpp.x[i] + value;
function setOppY(value:Float, i:Int) cpu.members[i].y = defOpp.y[i] + value;

function setPlayerX(value:Float, i:Int) player.members[i].x = defPlayer.x[i] + value;
function setPlayerY(value:Float, i:Int) player.members[i].y = defPlayer.y[i] + value;

function setBothX(value:Float, i:Int) {
    setOppX(value, i);
    setPlayerX(value, i);
}

function setBothY(value:Float, i:Int) {
    setOppY(value, i);
    setPlayerY(value, i);
}

function sin(val:Float) return FlxMath.fastSin(val);
function cos(val:Float) return FlxMath.fastCos(val);