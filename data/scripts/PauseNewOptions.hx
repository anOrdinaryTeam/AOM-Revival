import funkin.editors.ui.UIState;

var newOptions:Array<String> = [
    'Resume',
    'Restart Song',
    'Change Note Skin',
    'Change Controls',
    'Change Options',
    'Exit to menu',
    "Exit to charter"
];

function create(e)
    e.options = newOptions;

function onSelectOption(e) if (e.name == 'Change Note Skin') {
    BACK_TO_PLAYSTATE = true;
    FlxG.switchState(new UIState(true, 'noteSkinSelector'));
}