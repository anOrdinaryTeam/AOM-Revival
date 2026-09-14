var shader:FunkinShader;

function postCreate() if (Options.gameplayShaders) {
    shader = FunkinShader.fromFile(Paths.fragShader('camEffects'));
    camGame.addShader(shader);
}

public function setChroma(newZoom:Float, timestep:Float) {
    if (shader == null || !Options.gameplayShaders)
        return;

    var realTime:Float = (timestep * Conductor.stepCrochet) / 1000;
    FlxTween.tween(shader, {distort: newZoom}, realTime, {ease: FlxEase.cubeOut});
}