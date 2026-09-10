function stepHit(e) switch(e) {
    case 1:
        addSnowAmount(SnowMethod == 0 ? 100 : 75, 0.125);
        setIntensity(SnowMethod == 0 ? 1.4 : 0.25, 0.125);
    case 278: setIntensity(SnowMethod == 0 ? 1.8 : 0.3, 96);
    case 486: setIntensity(SnowMethod == 0 ? 2.2 : 0.4, 128);
    case 605:
        addSnowAmount(SnowMethod == 0 ? 50 : 150, 1);
    case 606: setIntensity(SnowMethod == 0 ? 2.4 : 0.45, 1);
}

function create() {
    translateStep(90913.0434782609);
}

function translateStep(time:Float) {
    var step:Int = Std.int(Conductor.getTimeInSteps(time));
    trace(step);
}