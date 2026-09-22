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

    if (stepRange(0, 12) || stepRange(16, 28) || stepRange(32, 44) || stepRange(48, 60) ||
        stepRange(64, 76) || stepRange(80, 92) || stepRange(96, 108) || stepRange(112, 124) ||
        stepRange(2176, 2188) || stepRange(2192, 2204) || stepRange(2208, 2220) || stepRange(2224, 2236) ||
        stepRange(2240, 2252) || stepRange(2256, 2268) || stepRange(2272, 2284) || stepRange(2288, 2300)) {
        
        for (i in 0...4) {
            var xVal:Float = 25 * sin((currentBeat + i * 50) * PI);
            var yVal:Float = 5 * cos((currentBeat + i * 0.25) * PI);
            setBothX(xVal, i);
            setBothY(yVal, i);
        }
    }

    if (stepRange(12, 16) || stepRange(44, 48) || stepRange(76, 80) || stepRange(108, 112) ||
        stepRange(2188, 2192) || stepRange(2220, 2224) || stepRange(2252, 2256) || stepRange(2284, 2288)) {
        
        for (i in 0...4) {
            var yVal:Float = -120 * cos((currentBeat + i * 10) * PI);
            setBothY(yVal, i);
        }
    }

    if (stepRange(28, 32) || stepRange(60, 64) || stepRange(92, 96) ||
        stepRange(2204, 2208) || stepRange(2236, 2240) || stepRange(2268, 2272)) {
        
        for (i in 0...4) {
            var yVal:Float = 120 * cos((currentBeat + i * 10) * PI);
            setBothY(yVal, i);
        }
    }

    if (stepRange(124, 126) || stepRange(2300, 2302)) {
        for (i in 0...4) {
            var yVal:Float = 118 * cos((currentBeat + i * 10) * PI);
            setBothY(yVal, i);
        }
    }

    if (stepRange(128, 624) || stepRange(1152, 1648)) {
        for (i in 0...4) {
            var altCurBeat:Float = (Conductor.songPosition / 1000) * (Conductor.bpm / 120);
            var xVal:Float = 25 * sin((altCurBeat + i * 50) * PI);
            var yVal:Float = 5 * cos((altCurBeat + i * 0.25) * PI);
            setOppX(xVal, i);
            setOppY(yVal, i);
        }
    }

    if (stepRange(640, 896) || stepRange(1664, 2176)) {
        for (i in 0...4) {
            var val:Float = 5 * cos((currentBeat + i * 0.25) * PI);
            setBothY(val, i);
        }
    }

    if (stepRange(1024, 1154)) {
        for (i in 0...4) {
            var val:Float = 25 * cos((currentBeat + i * 5) * PI);
            setBothY(val, i);
        }
    }
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

public function stepRange(from:Int, to:Int) return curStep >= from && curStep < to;
function sin(val:Float) return FlxMath.fastSin(val);
function cos(val:Float) return FlxMath.fastCos(val);

// just in case if smth is wrong bc the current one I used AI to replace all the conditionals to the new function
// function update(e) {
//     var currentBeat:Int = (Conductor.songPosition / 1000) * (Conductor.bpm / 60);

//     if ((curStep >= 0 && curStep < 12) || (curStep >= 16 && curStep < 28) || (curStep >= 32 && curStep < 44) || (curStep >= 48 && curStep < 60) || (curStep >= 64 && curStep < 76) || (curStep >= 80 && curStep < 92) || (curStep >= 96 && curStep < 108) || (curStep >= 112 && curStep < 124) || (curStep >= 2176 && curStep < 2188) || (curStep >= 2192 && curStep < 2204) || (curStep >= 2208 && curStep < 2220) || (curStep >= 2224 && curStep < 2236) || (curStep >= 2240 && curStep < 2252) || (curStep >= 2256 && curStep < 2268) || (curStep >= 2272 && curStep < 2284) || (curStep >= 2288 && curStep < 2300)) for (i in 0...4) {
//         var xVal:Float = 25 * sin((currentBeat + i * 50) * PI);
//         var yVal:Float = 5 * cos((currentBeat + i * 0.25) * PI);
//         setBothX(xVal, i);
//         setBothY(yVal, i);
//     }

//     if ((curStep >= 12 && curStep < 16) || (curStep >= 44 && curStep < 48) || (curStep >= 76 && curStep < 80) || (curStep >= 108 && curStep < 112) || (curStep >= 2188 && curStep < 2192) || (curStep >= 2220 && curStep < 2224) || (curStep >= 2252 && curStep < 2256) || (curStep >= 2284 && curStep < 2288)) for (i in 0...4) {
//         var yVal:Float = -120 * cos((currentBeat + i * 10) * PI);
//         setBothY(yVal, i);
//     }

//     if ((curStep >= 28 && curStep < 32) || (curStep >= 60 && curStep < 64) || (curStep >= 92 && curStep < 96) || (curStep >= 2204 && curStep < 2208) || (curStep >= 2236 && curStep < 2240) || (curStep >= 2268 && curStep < 2272)) for (i in 0...4) {
//         var yVal:Float = 120 * cos((currentBeat + i * 10) * PI);
//         setBothY(yVal, i);
//     }

//     if ((curStep >= 124 && curStep < 126) || (curStep >= 2300 && curStep < 2302)) for (i in 0...4) {
//         var yVal:Float = 118 * cos(((currentBeat) + i * 10) * PI);
//         setBothY(yVal, i);
//     }

//     if ((curStep >= 128 && curStep < 624) || (curStep >= 1152 && curStep < 1648)) for (i in 0...4) {
//         var altCurBeat:Float = (Conductor.songPosition / 1000) * (Conductor.bpm / 120);
//         var xVal:Float = 25 * sin((altCurBeat + i * 50) * PI);
//         var yVal:Float = 5 * cos((altCurBeat + i * 0.25) * PI);
//         setOppX(xVal, i);
//         setOppY(yVal, i);
//     }

//     if ((curStep >= 640 && curStep < 896) || (curStep >= 1664 && curStep < 2176)) for (i in 0...4) {
//         var val:Float = 5 * cos((currentBeat + i * 0.25) * PI);
//         setBothY(val, i);
//     }

//     // if (stepRange(1024, 1154))
//     if (curStep >= 1024 && curStep < 1154) for (i in 0...4) {
//         var val:Float = 25 * cos((currentBeat + i * 5) * PI);
//         setBothY(val, i);
//     }
// }