// modifiers
var sway:Bool = false;
var swayfast:Bool = false;
var swaynote:Bool = false;
var swaynote2:Bool = false;
var swaynote3:Bool = false;
var swaynote4:Bool = false;
var camHudAngle:Float = 0;

function onUpdateModchart(currentBeat)
{
    if (sway)
        camHudAngle = 5 * Math.sin(currentBeat / 2);

    if (swayfast)
        camHudAngle = 6 * Math.sin(currentBeat * 2);

    if (swaynote) for (i in 0...4)
        setActorX(32 * Math.sin(currentBeat + i * 2), i);

    if (swaynote2) for (i in 0...4)
        setActorX(64 * Math.sin(currentBeat + i), i);

    if (swaynote3) for (i in 0...4)
        setActorX(64 * Math.sin((currentBeat + i*2) * Math.PI), i);

    if (swaynote4) for (i in 0...4)
        setActorY(32 * Math.cos((currentBeat + i * 5) * Math.PI), i);
}

function stepHit(step)
{
    // Positionation post angle-tween
    if ((step >= 900 && step < 1020) || (step >= 1670 && step < 1680) || (step >= 1956 && step < 2192) || (step >= 2550)) for (i in 0...4) {
        setAngle(0, i);
        setActorX(0, i);
    }

    // Camera Angle
    if (!(swayfast || sway) && ((step >= 256 && step < 512) || (step >= 1952 && step < 2208)))
		sway = true;
	else if ((swayfast || sway) && ((step >= 512 && step < 1048) || (step >= 2208))) {
		sway = false;
		camHudAngle = 0;
    }

    if (!(swayfast || sway) && ((step >= 1280 && step < 1048) || (step >= 2208 && step < 2544)))
		swayfast = true;
	else if ((swayfast || sway) && ((step >= 1048 && step < 1952) || (step >= 2544))) {
		swayfast = false;
		camHudAngle = 0;
    }

    // Note Movement
    if (!swaynote && (step >= 512 && step < 640))
		swaynote = true;
	else if (swaynote && (step >= 640))
		swaynote = false;

	if (!swaynote2 && ((step >= 640 && step < 896) || (step >= 1696 && step < 1952)))
		swaynote2 = true;
	else if (swaynote2 && (step >= 896) || (step >= 1952))
		swaynote2 = false;

	if (!swaynote3 && (step >= 1408 && step < 1664))
		swaynote3 = true;
	else if (swaynote3 && (step >= 1664))
		swaynote3 = false;

	if (!swaynote4 && (step >= 2208 && step < 2544))
		swaynote4 = true;
	else if (swaynote4 && (step >= 2544))
		swaynote4 = false;

    // Tween Angles
    if ((step == 896) || (step == 1664) || (step == 1952) || (step == 2544)) for (i in 0...4) {
        setActorY(0, i);
        tweenAngle(i, 0.2);
    }
}