import openfl.system.Capabilities;

function onSelectOption(e) if (e.name == 'Exit to menu') {
    #if !ARKOSE_PORT
    e.cancel();
    var determineScale:Float = switch(Capabilities.screenResolutionY) {
        default: 0.9;
        case 1080: 0.75;
        case 768: 0.7;
        case 720: 0.6;
    }
    matense(1280, 720, determineScale);
    window.resizable = true;

    FlxG.switchState(new ModState('NewFreeplay'));
    #end
}