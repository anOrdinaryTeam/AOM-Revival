import funkin.editors.ui.UIText;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UITextBox;
import funkin.editors.ui.UIImageExplorer;
import funkin.editors.ui.UIWarningSubstate;

function create() {
    winTitle = 'Add Custom Skin';
    winWidth = 900;
	winHeight = 520;
}

var saveButton:UIButton;
var closeButton:UIButton;
var imageExplorer:UIImageExplorer;

function postCreate() {
    imageExplorer = new UIImageExplorer(20, 50, null, 150, 58, null, 'images/noteSkinsDatas/Test');
    imageExplorer.allowAtlases = false;
    imageExplorer.maxSize.x *= 0.4;
    imageExplorer.maxSize.y *= 0.4;
    add(imageExplorer);

    noteName = new UITextBox(0, windowSpr.y + 30 + 16 + 20, "", 250);
    noteName.x = (windowSpr.x + windowSpr.bWidth) - noteName.bWidth - 20;
	noteName.onChange = checkNoteName;
	add(noteName);
    addLabelOn(noteName, 'Note Name');

    saveButton = new UIButton(0, 475, 'Save Skin', () -> {
	    trace('done');
        // _SetSkin();
	    close();
	}, 125);
    saveButton.x = ((windowSpr.x + windowSpr.bWidth) - saveButton.bWidth) - 10;
    saveButton.shouldPress = false;
	add(saveButton);

    closeButton = new UIButton(saveButton.x - 20 - saveButton.bWidth, saveButton.y, 'Close', close, 125);
	add(closeButton);
	closeButton.color = 0xFFFF0000;
}

function checkNoteName() {
    var noteLists:Array<String> = Paths.getFolderDirectories(pathList);
    var text:String = noteName.label.text;

    if (text.length > 0 && noteLists.contains(text))
        openSubState(new UIWarningSubstate('Note Already Exists', 'This Note/Name already exists, please try another Name.', [{label: 'Close', color: 0xFFFF0000, onClick: () -> {
            noteName.label.text = '';
        }}]));
    else {
        saveButton.shouldPress = true;
        return;
    }
}

function addLabelOn(ui:UISprite, text:String):UIText {
	var text:UIText = new UIText(ui.x, ui.y - 24, 0, text);
	add(text);
	return text;
}