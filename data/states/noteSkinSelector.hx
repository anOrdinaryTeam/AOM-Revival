import flixel.addons.display.FlxBackdrop;
import funkin.editors.ui.UIColorwheel;
import funkin.editors.ui.UICheckbox;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UISubstateWindow;
import openfl.system.Capabilities;

public static var pathList:String = 'images/noteSkinsDatas';

var curSkinTxt:FunkinText = new FunkinText(0, 10, 0, '< Current Skin: ??? >', 30);
var skinsList:Array<NoteSkin> = [];

var skinsTexts:FlxTypedGroup<Alphabet> = new FlxTypedGroup();
var skinIcons:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();

var strumPreview:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var notesPreview:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();

var optionsBoxes:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var optionsIcons:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var optionsTexts:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();

var currentColors:Array<Array<FlxColor>>;
var lastColors:Array<Array<FlxColor>>;
var defaultColors:Array<Array<FlxColor>> = [
    [0xFFC24B99, 0xFFFFFFFF, 0xFF3C1F56],
    [0xFF00FFFF, 0xFFFFFFFF, 0xFF1542B7],
    [0xFF12FA05, 0xFFFFFFFF, 0xFF0A4447],
    [0xFFF9393F, 0xFFFFFFFF, 0xFF651038]
];

var colorWheel:UIColorwheel;
var useThisSkin:UIButton;

var inColorEditor:Bool = false;
var selectedStrum:Int = 0;
var buttons:FlxTypedGroup<UIButton> = new FlxTypedGroup();
var otherButtons:FlxTypedGroup<UIButton> = new FlxTypedGroup();
var editingPart:Int = 0;

var allowInput:Bool = true;
var curSelected:Int = 0;
var skinSelected:Int = 0;
var lastSelected:Int = 0;

// Auto icon switching while selecting
var _ChangeToVariants:Bool = true;
var _TimeToChange:Float = 2;

var backToPlayState:Bool = BACK_TO_PLAYSTATE;
var lastSong:String = LAST_SONG;

function create() {
    CoolUtil.playMenuSong();
    // thxs karim uwu
    // cdn.discordapp.com/attachments/1328061474509291632/1500094568870314164/image.png?ex=69f72f6f&is=69f5ddef&hm=971547086514ed1ff843c9fb54082dd2012b3ff536713a97c2602a802997d34e&animated=true
    currentColors = [for (i in FlxG.save.data.AOM_RGB) [for (j in i) j]];
    lastColors = [for (i in FlxG.save.data.AOM_RGB) [for (j in i) j]];

    var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuEditors'));
    bg.antialiasing = Options.antialiasing;
    add(bg);

    var backdrop:FlxBackdrop = new FlxBackdrop(getImage('Menu/skinmenu'), FlxAxes.XY, -1);
    backdrop.antialiasing = Options.antialiasing;
    backdrop.velocity.set(40, 40);
    backdrop.alpha = 0.07;
    add(backdrop);

    var listBG:FlxSprite = new FlxSprite().makeSolid(500, FlxG.height, -1);
    listBG.alpha = 0.1;
    add(listBG);

    add(skinsTexts);
    add(skinIcons);

    add(strumPreview);
    add(notesPreview);

    add(optionsBoxes);
    add(optionsIcons);
    add(optionsTexts);

    var skinList:Dynamic = Paths.getFolderDirectories(pathList);
    var textScale:Float = 0.65;
    var textX:Float = 100;

    for (skin in skinList) {
        var pathJson:String = Paths.file('$pathList/$skin/data.json');
        if (!Assets.exists(pathJson)) return;

        var jsonRaw:Dynamic = CoolUtil.parseJson(pathJson);

        var display:String = jsonRaw.displayName;
        var pathSkin:String = jsonRaw.path ?? null;
        var variants:Array<Array<String>> = jsonRaw.variants != null ? jsonRaw.variants.copy() : null;

        var SkinVar:NoteSkin = new NoteSkin();
        SkinVar.displayName = display;
        if (pathSkin != null) {
            SkinVar.path = pathSkin;
            SkinVar.splash = jsonRaw.splash;
        }
        else
            SkinVar.variations = variants.copy();
        skinsList.push(SkinVar);

        var skinIconPath:String = SkinVar.variations != null ? 'icons/${SkinVar.variations[0][0]}' : 'icon';
        var iconSkin:FlxSprite = new FlxSprite().loadGraphic(Paths.image('noteSkinsDatas/$skin/$skinIconPath'));
        iconSkin.scale.set(0.5, 0.5);
        iconSkin.updateHitbox();
        iconSkin.antialiasing = Options.antialiasing;
        iconSkin.alpha = 0.6;
        skinIcons.add(iconSkin);

        if (_ChangeToVariants && SkinVar.variations != null) new FlxTimer().start(_TimeToChange, () -> {
            SkinVar.onChange = FlxMath.wrap(SkinVar.onChange + 1, 0, SkinVar.variations.length - 1);

            var newGraphic:String = 'noteSkinsDatas/$skin/icons/${SkinVar.variations[SkinVar.onChange][0]}';
            iconSkin.loadGraphic(Paths.image(newGraphic));
        }, 0);

        var txt:String = SkinVar.variations != null ? '$display (+1)' : display;
        var skinText:Alphabet = new Alphabet(textX, 0, txt, 'bold');
        skinText.scale.set(textScale, textScale);
        skinText.updateHitbox();
        skinText.alpha = 0.6;
        skinsTexts.add(skinText);
    }

    add(buttons);
    add(otherButtons);

    var saveColors:UIButton = new UIButton(1150, 80, 'Save Colors', _SaveColors);
    saveColors.antialiasing = true;
    saveColors.visible = false;
    otherButtons.add(saveColors);

    var resetColors:UIButton = new UIButton(saveColors.x - 135, 80, 'Reset Colors', _ResetColors);
    resetColors.antialiasing = true;
    resetColors.visible = false;
    otherButtons.add(resetColors);

    var defColors:UIButton = new UIButton(resetColors.x - 135, 80, 'Set Default Colors', _SetDefaultColors);
    defColors.antialiasing = true;
    defColors.visible = false;
    otherButtons.add(defColors);

    useThisSkin = new UIButton(1150, saveColors.y + 50, 'Use This Skin', _SetSkin);
    useThisSkin.antialiasing = true;
    useThisSkin.visible = false;
    add(useThisSkin);

    var str:String = FlxG.save.data.AOM_curSkinNote_Display == '' ? 'NONE' : FlxG.save.data.AOM_curSkinNote_Display;
    curSkinTxt.text = '< Current Skin: $str >';
    curSkinTxt.alignment = 'left';
    curSkinTxt.x = (FlxG.width - curSkinTxt.width) - 10;
    add(curSkinTxt);

    var useSkins:UICheckbox = new UICheckbox((listBG.x + listBG.width) + 15, 30, 'Use Custom Skins', FlxG.save.data.AOM_usingSkin);
    useSkins.antialiasing = true;
    useSkins.onChecked = () -> FlxG.save.data.AOM_usingSkin = !FlxG.save.data.AOM_usingSkin;
    useSkins.scale.set(1.4, 1.4);
    add(useSkins);

    var addSkin:UIButton = new UIButton(useSkins.x, useSkins.y + 50, 'Add Skin', _AddSkinSubstate);
    addSkin.antialiasing = true;
    add(addSkin);

	#if ARKOSE_PORT
	addMobilePad("UP_DOWN", "A_B");
	#end
    scroll();
}

function update(e) {
    if (FlxG.sound.music.volume > 0.4)
		FlxG.sound.music.volume -= 0.5 * e;

    for (k => option in skinsTexts.members) {
        var spaceBetween:Float = 100;
        var y:Float = ((FlxG.height - spaceBetween) / 2) + ((k - curSelected) * spaceBetween);
        option.y = CoolUtil.fpsLerp(option.y, y, 0.25);
    }

    for (i => icon in skinIcons.members) {
        var Xoffset:Float = -85;
        var Yoffset:Float = -12;
        var skinTxt:Alphabet = skinsTexts.members[i];

        icon.x = skinTxt.x + Xoffset;
        icon.y = skinTxt.y + Yoffset;
    }

    if (allowInput && !inColorEditor) {
        scroll((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);

        if (controls.ACCEPT)
            checkout();

        if (controls.BACK) {
            allowInput = false;

            if (backToPlayState) {
                if (lastSong == 'Fatality') {
                    #if !ARKOSE_PORT
                    var determineScale:Float = switch(Capabilities.screenResolutionY) {
                        default: 0.9;
                        case 768 | 1080: 0.75;
                        case 720: 0.6;
                    }
                    windowShit(960, 720, determineScale);
                    window.resizable = false;
                    #end
                }

                BACK_TO_PLAYSTATE = false;
                FlxG.switchState(new PlayState());
            }
            else
                FlxG.switchState(new ModState('NewMenu'));
        }

        if (optionsBoxes.members.length > 0) {
            for (box in optionsBoxes) if (CoolUtil.mouseOverlaps(box) && FlxG.mouse.justPressed)
                selectSkinOption(box.ID);
        
            if (skinsList[curSelected].displayName == 'Custom')
                for (note in notesPreview) if (CoolUtil.mouseOverlaps(note) && FlxG.mouse.justPressed)
                    openRGBPanel(note.ID);
        }
    }
    else if (!allowInput && inColorEditor) {
        updateNoteRGB(selectedStrum);

        if (controls.BACK || FlxG.mouse.justPressedRight)
            closeRGBPanel();
    }
}

function openRGBPanel(id:Int) {
    playSound('editors/windowAppear', 3);

    inColorEditor = true;
    allowInput = false;

    selectedStrum = id;
    colorWheel = new UIColorwheel(510, 10, currentColors[selectedStrum][editingPart]);
    add(colorWheel);

    for (i => str in ['R', 'G', 'B']) {
        var button:UIButton = new UIButton(colorWheel.x + 55 * i, 150, str, () -> {
            editingPart = i;

            remove(colorWheel);
            colorWheel = new UIColorwheel(510, 10, currentColors[selectedStrum][editingPart]);
            add(colorWheel);
        }, 50);
        button.antialiasing = true;
        buttons.add(button);
    }
}

function closeRGBPanel() {
    allowInput = true;
    inColorEditor = false;
    
    buttons.clear();
    remove(colorWheel);
}

function updateNoteRGB(id:Int) {
    var note:FunkinSprite = notesPreview.members[id];

    switch(editingPart) {
        default: note.shader.red = getColorArray(colorWheel.curColor);
        case 1: note.shader.green = getColorArray(colorWheel.curColor);
        case 2: note.shader.blue = getColorArray(colorWheel.curColor);
    }

    currentColors[selectedStrum][editingPart] = colorWheel.curColor;
}

function _SetSkin() {
    playSound('editors/save');

    var selectedSkin:NoteSkin = skinsList[lastSelected];
    var name:String = selectedSkin.displayName;
    var str:String = '';

    if (selectedSkin.variations != null) {
        var skinName:String = selectedSkin.variations[skinSelected][0];
        var skinPath:String = selectedSkin.variations[skinSelected][1];
        var splash:String = selectedSkin.variations[skinSelected][2];

        FlxG.save.data.AOM_curSkinNote = skinPath;
        FlxG.save.data.AOM_curSplash = splash;
        str = '$name ($skinName)';
    }
    else {
        var skinPath:String = selectedSkin.path;
        var splash:String = selectedSkin.splash;

        FlxG.save.data.AOM_curSkinNote = skinPath;
        FlxG.save.data.AOM_curSplash = splash;
        str = '$name';
    }

    curSkinTxt.text = '< Current Skin: $str>';
    curSkinTxt.x = (FlxG.width - curSkinTxt.width) - 10;
    FlxG.save.data.AOM_curSkinNote_Display = str;
    trace('Name $str | Path: ${FlxG.save.data.AOM_curSkinNote}');
}

function _SaveColors() {
    playSound('editors/save');
    FlxG.save.data.AOM_RGB = currentColors;
}

function _ResetColors() {
    playSound('editors/character/ghostDisable');

    for (i => note in notesPreview.members) {
        var red:FlxColor = lastColors[i][0];
        var green:FlxColor = lastColors[i][1];
        var blue:FlxColor = lastColors[i][2];

        note.shader.red = getColorArray(red);
        note.shader.green = getColorArray(green);
        note.shader.blue = getColorArray(blue);

        currentColors[i][0] = red;
        currentColors[i][1] = green;
        currentColors[i][2] = blue;
    }
}

function _SetDefaultColors() {
    playSound('editors/redo', 0.5);

    for (i => note in notesPreview.members) {
        var red:FlxColor = defaultColors[i][0];
        var green:FlxColor = defaultColors[i][1];
        var blue:FlxColor = defaultColors[i][2];

        note.shader.red = getColorArray(red);
        note.shader.green = getColorArray(green);
        note.shader.blue = getColorArray(blue);

        currentColors[i][0] = red;
        currentColors[i][1] = green;
        currentColors[i][2] = blue;
    }
}

function _AddSkinSubstate()
    openSubState(new UISubstateWindow(true, 'AddSkinSubstate'));

// public static function _AddSkin(data:Dynamic) {
//     if (data == null) {
//         trace('Skin failed to import.');
//         return;
//     }
    
//     var skinName:String = data.
// }

function scroll(i:Int = 0, f:Bool = false) {
    if (i == 0 && !f) return;
    CoolUtil.playMenuSFX(0, 0.5);
    
    var alphaUnselected:Float = 0.6;
    skinsTexts.members[curSelected].alpha = alphaUnselected;
    skinIcons.members[curSelected].alpha = alphaUnselected;

    curSelected = FlxMath.wrap(curSelected + i, 0, skinsList.length - 1);

    skinsTexts.members[curSelected].alpha = 1;
    skinIcons.members[curSelected].alpha = 1;
}

function checkout() {
    var selectedSkin:NoteSkin = skinsList[curSelected];

    for (groups in [strumPreview, notesPreview, optionsBoxes, optionsIcons, optionsTexts])
        groups.clear();

    if (selectedSkin.variations != null)
        generateSkinOptions(selectedSkin);
    else
        generateStrumAndNotes(selectedSkin.path);
}

function selectSkinOption(id:Int) {
    var SkinVar:NoteSkin = skinsList[curSelected];
    var skin:String = SkinVar.variations[id][1];
    skinSelected = id;

    for (groups in [strumPreview, notesPreview])
        groups.clear();
    generateStrumAndNotes(skin);
}

function generateSkinOptions(variable:NoteSkin) {
    playSound('editors/dropdownAppear', 2);
    useThisSkin.visible = false;

    var list:Array<Array<String>> = variable.variations.copy();
    var name:String = variable.displayName;

    // Box
    var startX:Float = 530;
    var addX:Float = 150;
    var Yoffset:Float = 570;
    var boxScale:Float = 0.2;

    // Icon
    var iconScale:Float = 0.45;
    var iconAddX:Float = 35;

    for (i in 0...list.length) {
        var prefix:String = list[i][0];

        var box:FlxSprite = new FlxSprite(startX + addX * i, Yoffset, Paths.image('Menu/iconbox'));
        box.antialiasing = true;
        box.scale.set(boxScale, boxScale);
        box.updateHitbox();
        box.ID = i;
        optionsBoxes.add(box);

        var midPoint:Float = (box.x + box.width / 2) - iconAddX;
        var icon:FlxSprite = new FlxSprite(midPoint, box.y + 15, Paths.image('noteSkinsDatas/$name/icons/$prefix'));
        icon.antialiasing = Options.antialiasing;
        icon.scale.set(iconScale, iconScale);
        icon.updateHitbox();
        optionsIcons.add(icon);

        var midPoint:Float = (icon.x + icon.width / 2) - 40;
        var skinTitle:FunkinText = new FunkinText(0, box.y + 90, 0, prefix, 20);
        skinTitle.antialiasing = true;
        skinTitle.alignment = 'center';
        skinTitle.x = (icon.x + (icon.width - skinTitle.width) / 2);
        optionsTexts.add(skinTitle);
    }
}

function generateStrumAndNotes(path:String) {
    var pathSkin:String = path;
    var prefixs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
    var color:Array<String> = ['purple', 'blue', 'green', 'red'];
    var scaleObj:Float = 0.8;

    var startX:Float = 620;
    var addX:Float = 140;
    var yOffset:Float = 370;

    // [ STRUMS ]
    for (i in 0...4) {
        var strum:FunkinSprite = new FunkinSprite(startX + addX * i, yOffset, Paths.image(pathSkin));
        strum.addAnim('static', 'arrow${prefixs[i]}', 24, true);
        strum.addAnim('pressed', '${prefixs[i].toLowerCase()} press', 24, false);
        strum.addAnim('confirm', '${prefixs[i].toLowerCase()} confirm', 24, false);
        strum.antialiasing = Options.antialiasing;
        strum.scale.set(scaleObj, scaleObj);
        strum.updateHitbox();
        strum.playAnim('static', true);
        strum.ID = i;
        strumPreview.add(strum);
    }
    // [ END ]

    // [ NOTES ]
    var downSizer:Float = 0.15;
    var exSX:Float = 25;
    var exAdd:Float = -10;

    for (i in 0...4) {
        var note:FunkinSprite = new FunkinSprite((startX + exSX) + (addX + exAdd) * i, yOffset - 150, Paths.image(pathSkin));
        note.antialiasing = Options.antialiasing;
        note.addAnim('scroll', '${color[i]}0');
        note.scale.set(scaleObj - downSizer, scaleObj - downSizer);
        note.updateHitbox();
        note.playAnim('scroll', true);
        note.ID = i;
        notesPreview.add(note);
    }
    // [ END ]

    lastSelected = curSelected;
    useThisSkin.visible = true;
    for (btts in otherButtons) btts.visible = false;

    if (skinsList[curSelected].displayName == 'Custom') {
        for (btts in otherButtons) btts.visible = true;

        for (i => note in notesPreview.members) {
            var red:FlxColor = currentColors[i][0];
            var green:FlxColor = currentColors[i][1];
            var blue:FlxColor = currentColors[i][2];
            note.shader = new CustomShader('RGB');

            note.shader.red = getColorArray(red);
            note.shader.green = getColorArray(green);
            note.shader.blue = getColorArray(blue);
            note.shader.enabled = true;
        }
    }
}

class NoteSkin
{
    public var displayName:String = 'NULL';
    public var path:String = '';
    public var splash:String = '';

    public var variations:Array<Array<String>> = null;
    public var onChange:Int = 0;
}