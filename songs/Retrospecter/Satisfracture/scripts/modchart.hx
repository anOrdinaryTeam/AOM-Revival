var sway = false;
var quickdraw = false;
var quickdraw2 = false;
var quickdraw3 = false;
var quickdraw4 = false;
var crisscross = false;
var crisscross2 = false;
var speedy = false;
var fadingCrissCross = false;

function onUpdateModchart(currentBeat)
{
    if (sway)
		camHudAngle = 5 * Math.sin(currentBeat * 0.504);

    if (quickdraw) for (i in 0...4) {
        setActorX(32 * Math.sin((currentBeat + i*2) * Math.PI), i);
		setActorY(0, i);
    }

    if (quickdraw2) for (i in 0...4) {
        setActorX(0, i);
		setActorY(16 * Math.sin((currentBeat + i*2) * Math.PI), i);
    }

    if (quickdraw3) for (i in 0...4) {
        setActorX(32 * Math.sin((currentBeat + i*2) * Math.PI), i);
		setActorY(0, i);
    }

    if (quickdraw4) for (i in 0...4) {
        setActorX(0, i);
        setCpuY(0, i);
        setPlayerY(16 * Math.sin((currentBeat + i) * Math.PI), i);
    }

    if (crisscross) {
        var calcForPlayer:Float = !Options.centeredFields ? Math.sin((currentBeat+2.38848706) * 0.503) : Math.sin(currentBeat * 0.503) - 275 - 42;
        setPlayerX(-300 * calcForPlayer, i);
        if (!Options.centeredFields) setCpuX(300 * Math.sin(currentBeat * 0.503) + 350 - 42, i);
    }
}