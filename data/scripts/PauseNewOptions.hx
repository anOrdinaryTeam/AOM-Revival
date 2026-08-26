import funkin.editors.ui.UIState;
import openfl.system.Capabilities;

var newOptions:Array<String> = [
    'Resume',
    'Restart Song',
    'Change Mod Options',
    'Change Note Skin',
    'Change Controls',
    'Change Options',
    'Exit to menu',
    "Exit to charter"
];

function create(e) {
    var nameSong:String = PlayState.SONG.meta.displayName;
    var pathShi:String = currentMod == 'RandomSongs' ? 'RandomSongs/settings/$nameSong' : '$currentMod/settings';
    var exists:Bool = Assets.exists(Paths.file('Mods/$pathShi.json'));

    if (!exists && newOptions.contains('Change Mod Options'))
        newOptions.remove('Change Mod Options');
    if (newOptions.contains('Exit to charter') && !PlayState.chartingMode)
        newOptions.remove('Exit to charter');

    e.options = newOptions;
}

function onSelectOption(e) {
    if (e.name == 'Change Note Skin') {
        BACK_TO_PLAYSTATE = true;
        LAST_SONG = PlayState.SONG.meta.name;

        if (PlayState.SONG.meta.name == 'Fatality')
            restoreWindowSize();
        FlxG.switchState(new UIState(true, 'noteSkinSelector'));
    }
    else if (e.name == 'Change Mod Options') {
        var data:Dynamic = {Mod: currentMod, Song: PlayState.SONG.meta.displayName, PauseState: true};
        openSubState(new ModSubState('ModSettingsSubstate', data));
        persistentUpdate = false;
		persistentDraw = true;
    }
    else if (e.name == 'Exit to menu' && PlayState.SONG.meta.name == 'Fatality') {
        restoreWindowSize();
        FlxG.switchState(new ModState('NewFreeplay'));
    }
}

function restoreWindowSize() {
    #if !ARKOSE_PORT
    var determineScale:Float = switch(Capabilities.screenResolutionY) {
        default: 0.9;
        case 1080: 0.75;
        case 768: 0.7;
        case 720: 0.6;
    }
    matense(1280, 720, determineScale);
    window.resizable = true;
    #end
}