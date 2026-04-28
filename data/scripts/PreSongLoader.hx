import openfl.system.Capabilities;

function preEnterSong(song) switch(song) {
    case 'Fatality':
        var determineScale:Float = switch(Capabilities.screenResolutionY) {
            default: 0.9;
            case 768: 0.75;
            case 720: 0.6;
        }
        windowShit(960, 720, determineScale);
        window.resizable = false;
}