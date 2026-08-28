import funkin.editors.ui.UIText;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UITextBox;
import funkin.editors.ui.UIWarningSubstate;

var modName:String = GetCurSelectedName();

function new() if (findFile('Mods/$modName/images/menu/data.json')) {
    trace('Ya existe el archivo.');
    close();
}

function create() {
    winTitle = '- Menu Creator [$modName]';
    winWidth = 900;
	winHeight = 520;
}

function postCreate() {
    var saveButton:UIButton = new UIButton(0, 475, 'Save', _Save, 125);
    saveButton.x = ((windowSpr.x + windowSpr.bWidth) - saveButton.bWidth) - 10;
    saveButton.shouldPress = false;
	add(saveButton);

    var closeButton:UIButton = new UIButton(saveButton.x - 20 - saveButton.bWidth, saveButton.y, 'Close', close, 125);
	closeButton.color = 0xFFFF0000;
	add(closeButton);
}

function _Save() {

}

class MenuTab extends UIButton
{
    var closed:Bool = true;
    var foldableIcons:Array<Dynamic> = [];
}