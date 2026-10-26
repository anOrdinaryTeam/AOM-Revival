var sway = false;
var quickdraw = false;
var quickdraw2 = false;
var quickdraw3 = false;
var quickdraw4 = false;
var crisscross = false;
var crisscross2 = false;
var speedy = false;
var fadingCrissCross = false;
var showOnlyStrums(default, set):Bool = false;

function set_showOnlyStrums(value:Bool)
{
    var trueValue:Bool = !value;
    healthBar.visible = trueValue;
    healthBarBG.visible = trueValue;
    iconP1.visible = trueValue;
    iconP2.visible = trueValue;
    scoreTxt.visible = trueValue;
    accuracyTxt.visible = trueValue;
    missesTxt.visible = trueValue;
    return value;
}

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
        if (Options.centeredFields)
            for (i in 0...4)
                setActorX(-300 * Math.sin((currentBeat+2.38848706) * 0.503), i);
        else
            for (i in 0...4) {
                setPlayerX(-300 * Math.sin(currentBeat * 0.503) - 275 - 42, i);
                setCpuX(300 * Math.sin(currentBeat * 0.503) + 350 - 62, i);
            }
    }

    if (crisscross2) {
        if (Options.centeredFields)
        {
            for (i in 0...4) {
                setPlayerX(-300 * Math.sin((currentBeat+3.9328377421) * 0.504), i);
                setPlayerY(16 * Math.cos((currentBeat + i*5) * Math.PI), i);
            }
        }
        else
        {
            for (i in 0...4) {
                setPlayerX(-300 * Math.sin(currentBeat * 0.504) - 275 - 42, i);
                setCpuX(300 * Math.sin(currentBeat * 0.504) + 350 - 42, i);
                setActorY(16 * Math.cos((currentBeat + i*5) * Math.PI), i);
            }
        }
    }
}

function stepHit(step)
{
    // SYNC
    if ((step >= 578 && step < 600) || (step >= 706 && step < 760) && (step >= 840 && step < 896) || (step >= 1030 && step < 1144))
        for (i in 0...4)
        {
            setActorX(0, i);
            setActorY(0, i);
            setAngle(0, i);
        }

    // Other
    if (step == 176) for (i in 0...4)
        cpu_tweenFadeOut(i, 0, .4);

    if (step == 188)
        showOnlyStrums = true;

    if (step == 192) {
        if (!Options.centeredFields) for (i in 0...4)
            cpu_tweenFadeOut(i, 1, 0.01);

        showOnlyStrums = false;
    }

    if (step == 1120) for (i in 0...4)
        cpu_tweenFadeOut(i, 0, 1);

    // if (curDiff == 'normal')
    // {
    //     if (step == 1148)

    // }

    // SWAYS CAM
    if (!sway && ((step >= 192 && step < 320) || (step >= 448 && step < 576) || (step >= 832 && step < 1024)))
		sway = true;
	else if (sway && ((step >= 320 && step < 448) || (step >= 576 && step < 832) || (step >= 1024))) {
		sway = false;
		camHudAngle = 0;
    }

    // QUICK DRAW
    if (!quickdraw && (step >= 320 && step < 448))
		quickdraw = true;
	else if (quickdraw && (step >= 448))
		quickdraw = false;

    if (!quickdraw2 && (step >= 448 && step < 576))
		quickdraw2 = true;
	else if (quickdraw2 && (step >= 576)) {
		quickdraw2 = false;
		for (i in 0...4)
			setActorY(0, i);
    }

    if (!quickdraw3 && (step >= 960 && step < 992))
		quickdraw3 = true;
	else if (quickdraw3 && (step >= 992))
		quickdraw3 = false;

    if (!quickdraw4 && (step >= 992 && step < 1024))
		quickdraw4 = true;
	else if (quickdraw4 && (step >= 1024))
		quickdraw4 = false;

    // CRISS-CROSS
    if (!fadingCrissCross && (step >= 640 && step < 704) || (step >= 832 && step < 960))
    {
        var alphaVal:Float = Options.centeredFields ? 0 : 0.3;
        for (i in 0...4)
            cpu_tweenFadeOut(i, alphaVal, 0.4);
        fadingCrissCross = true;
    }

    if (fadingCrissCross && (step >= 704 && step < 832) || (step >= 960 && step < 1024))
    {
        var alphaVal:Float = Options.centeredFields ? 0.35 : 1;
        for (i in 0...4)
            cpu_tweenFadeOut(i, alphaVal, 0.4);
        fadingCrissCross = false;
    }

    if (!crisscross && (step >= 640 && step < 704))
		crisscross = true;
	else if (crisscross && (step >= 704 && step < 832))
		crisscross = false;
	
	if (!crisscross2 && (step >= 832 && step < 960))
		crisscross2 = true;
	else if (crisscross2 && (step >= 960))
		crisscross2 = false;
	
    if ((step == 576) || (step == 704) || (step == 1024)) for (i in 0...4) {
        setActorY(0, i);
        tweenPosXAngle(i, 0.2);
    }
}