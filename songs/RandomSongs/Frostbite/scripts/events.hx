camZooming = true;

function stepHit(e) switch(e) {
    case 1:
        addSnowAmount(SnowMethod == 0 ? 100 : 75, 0.125);
        setIntensity(SnowMethod == 0 ? 1 : 0.25, 0.125);
    case 8: FlxTween.tween(fogIntro, {alpha: 0}, 5, {ease: FlxEase.quadIn});
    case 35: if (typhlosion != null) typhlosion.playAnim('fire', true);
    case 61: coldnessRate = 0.01;
    case 63, 704: FlxTween.tween(camHUD, {alpha: 1}, 1 * (Conductor.stepCrochet / 1000));
    case 319: setIntensity(SnowMethod == 0 ? 2 : 0.3, 96);
    case 560: setIntensity(SnowMethod == 0 ? 2.7 : 0.4, 128);
    case 686: FlxTween.tween(camHUD, {alpha: 0}, 1 * (Conductor.stepCrochet / 1000));
    case 687:
        dad.animation.onFinish.add((Anim) -> if (Anim == 'Freakachu Entrance') {
            defaultCamZoom = 0.8;
            forceCamPos = false;
            coldnessZoom = true;

            changeCharacter(0, 'Frostbite/red-dead');
            freakachu.alpha = 1;
        });
        dad.playAnim('Freakachu Entrance', true);
        dad.scale.set(0.76, 0.76);

        coldnessZoom = false;
        forceCamPos = true;
        TweenZoom(1.15, 0.6);
        camFollow.setPosition(650, 570);

        new FlxTimer().start(0.86, () -> {
            camFollow.x -= 30;
            TweenZoom(0.8, 0.03);
            camGame.shake(0.001,0.8);
        });
    case 696: addSnowAmount(SnowMethod == 0 ? 100 : 150, 1);
    case 697: setIntensity(SnowMethod == 0 ? 4.5 : 0.45, 1);
    case 1374: setIntensity(0, 1);
}

function create() {
    translateStep(91826.0869565218);
}

function TweenZoom(amt:Float, time:Float) {
    var totalZoom:Float = defaultCamZoom + amt;
    FlxTween.tween(this, {defaultCamZoom: totalZoom}, time, {ease: FlxEase.quadOut});
}

function translateStep(time:Float) {
    var step:Int = Std.int(Conductor.getTimeInSteps(time));
    trace(step);
}