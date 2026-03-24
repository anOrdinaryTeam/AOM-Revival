function stepHit() if (curStep == 2427) {
    camGame.shake(0.025, 0.2);
    for (i in [dad, iconP2]) FlxTween.tween(i, {alpha: 0.8}, 0.4);
    bg.animation.curAnim.frameRate = 20;
}
else if (curStep == 2943)
    for (i in [dad, iconP2]) FlxTween.tween(i, {alpha: 0}, 0.4);