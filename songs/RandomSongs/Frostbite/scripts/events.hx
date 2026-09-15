camZooming = true;

function stepHit(e) switch(e) {
    // chromas
    case 47, 495: setChroma(0.5, 16);
    case 439, 566, 823, 1079: setChroma(0.5, 8);
    case 447, 511, 576, 832, 1088: setChroma(0, 1);

    case 1:
        addSnowAmount(SnowMethod == 0 ? 100 : 75, 0.125);
        setIntensity(SnowMethod == 0 ? 0.6 : 0.25, 0.125);
    case 8: FlxTween.tween(fogIntro, {alpha: 0}, 5, {ease: FlxEase.quadIn});
    case 35: typhlosion?.playAnim('fire', true);
    case 61: coldnessRate = 0.01;
    case 63:
        setChroma(0, 16);
        FlxTween.tween(camHUD, {alpha: 1}, 1 * (Conductor.stepCrochet / 1000));
    case 319: setIntensity(SnowMethod == 0 ? 2 : 0.3, 96);
    case 560: setIntensity(SnowMethod == 0 ? 2.7 : 0.4, 128);
    case 686: FlxTween.tween(camHUD, {alpha: 0}, 1 * (Conductor.stepCrochet / 1000));
    case 687:
        dad.scale.set(0.76, 0.76);
        dad.playAnim('Freakachu Entrance', true);
        dad.animation.onFinish.add((Anim) -> if (Anim == 'Freakachu Entrance') {
            defaultCamZoom = 0.8;
            forceCamPos = false;
            coldnessZoom = true;
            disableMechs = false;

            changeCharacter(0, 'Frostbite/red-dead');
            freakachu?.alpha = 1;
        });

        coldnessZoom = false;
        forceCamPos = true;
        disableMechs = true;
        TweenZoom(1.15, 0.6);
        camFollow.setPosition(650, 570);

        new FlxTimer().start(0.86, () -> {
            camFollow.x -= 30;
            TweenZoom(0.8, 0.03);
            camGame.shake(0.001,0.8);
        });
    case 696: addSnowAmount(SnowMethod == 0 ? 100 : 150, 1);
    case 697: setIntensity(SnowMethod == 0 ? 4.5 : 0.45, 1);
    case 704: FlxTween.tween(camHUD, {alpha: 1}, 1 * (Conductor.stepCrochet / 1000));
    case 1374: setIntensity(0, 1);
    case 1375:
        disableMechs = true;
        FlxTween.tween(fogIntro, {alpha: 1}, 5, {ease: FlxEase.quadIn});
        FlxTween.tween(camHUD, {alpha: 0}, 3 * (Conductor.stepCrochet / 1000));
}

function create() {
    translateStep(179478.260869565);
    // translateStepList([6260.86956521739, 8347.82608695652, 57260.8695652174, 58434.7826086956, 64695.652173913, 66782.6086956521, 73956.5217391304, 75130.4347826087, 107347.826086957, 108521.739130435, 140739.130434783, 141913.043478261]);
}

function TweenZoom(amt:Float, time:Float) {
    var totalZoom:Float = defaultCamZoom + amt;
    FlxTween.tween(this, {defaultCamZoom: totalZoom}, time, {ease: FlxEase.quadOut});
}

function translateStep(time:Float) {
    var step:Int = Std.int(Conductor.getTimeInSteps(time));
    trace(step);
}

// function translateStepList(list:Array<Int>) {
//     var fullList:Array<Int> = [];
//     for (time in list) {
//         var step:Int = Std.int(Conductor.getTimeInSteps(time));
//         fullList.push(step);
//     }
//     trace(fullList);
// }