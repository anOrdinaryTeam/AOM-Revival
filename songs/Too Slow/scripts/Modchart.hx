// I didn't made it to recreate well the original modchart.
// The base is the same as the mod, I dunno what's making look different, I suck at math.

var defaultCpuStrum = {
    X: [], Y: []
}
var defaultPlayerStrum = {
    X: [], Y: []
}

function postCreate() if (!getSaveData('allowCustomHud'))
    getShit();

function postHudLoad() if (getSaveData('allowCustomHud'))
    getShit();

function getShit() for (i in 0...cpu.members.length) {
    defaultCpuStrum.X.push(cpu.members[i].x);
    defaultPlayerStrum.X.push(player.members[i].x);

    defaultCpuStrum.Y.push(cpu.members[0].y);
    defaultPlayerStrum.Y.push(player.members[0].y);
}

function update(dt) {
    var currentBeat:Float = (Conductor.songPosition / 1000) * (Conductor.bpm / 84);

    for (i in 0...4) {
        // X Modchart
        if (curStep >= 1049 && curStep < 1176) {
            var offset = 2 * Math.sin((currentBeat + i * 0.25) * Math.PI);

            setActorX(defaultPlayerStrum.X[i] + offset, i, 'player');
            setActorX(defaultCpuStrum.X[i] + offset, i, 'cpu');
        }
        if (curStep >= 1177 && curStep < 1959) {
            var offset = 6 * Math.sin((currentBeat + i * 0.25) * Math.PI);

            setActorX(defaultPlayerStrum.X[i] - offset, i, 'player');
            setActorX(defaultCpuStrum.X[i] - offset, i, 'cpu');
        }

        // Y Modchart
        if (curStep >= 789 && curStep < 923) {
            var offset = 5 * Math.sin((currentBeat + i * 0.25) * Math.PI);

            setActorY(defaultPlayerStrum.Y[i] + offset, i, 'player');
            setActorY(defaultCpuStrum.Y[i] + offset, i, 'cpu');
        }
        if (curStep >= 924 && curStep < 1048) {
            var offset = 5 * Math.sin((currentBeat + i * 0.25) * Math.PI);

            setActorY(defaultPlayerStrum.Y[i] - offset, i, 'player');
            setActorY(defaultCpuStrum.Y[i] - offset, i, 'cpu');
        }
    }
}

function setActorX(newX:Float, i:Int, focusStrum:String) {
    var strum = focusStrum == 'player' ? player : cpu;
    strum.members[i].x = newX;
}

function setActorY(newY:Float, i:Int, focusStrum:String) {
    var strum = focusStrum == 'player' ? player : cpu;
    strum.members[i].y = newY;
}