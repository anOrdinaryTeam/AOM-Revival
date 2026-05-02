import flixel.addons.display.FlxBackdrop;
import funkin.editors.ui.UIColorwheel;
import funkin.editors.ui.UIButton;

var curSkinTxt:FunkinText = new FunkinText(0, 10, 0, '< Current Skin: RGB >', 30);
var skinsList:Array<NoteSkin> = [];

var skinsTexts:FlxTypedGroup<Alphabet> = new FlxTypedGroup();
var skinIcons:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();

var strumPreview:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var notesPreview:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();

var optionsBoxes:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var optionsIcons:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var optionsTexts:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();

var currentColors:Array<Array<FlxColor>> = getSaveData('RGB');
var defaultColors:Array<Array<FlxColor>> = [
    [0xFFC24B99, 0xFFFFFFFF, 0xFF3C1F56],
    [0xFF00FFFF, 0xFFFFFFFF, 0xFF1542B7],
    [0xFF12FA05, 0xFFFFFFFF, 0xFF0A4447],
    [0xFFF9393F, 0xFFFFFFFF, 0xFF651038]
];

var colorWheel:UIColorwheel;
var inColorEditor:Bool = false;
var selectedStrum:Int = 0;
var buttons:FlxTypedGroup<UIButton> = new FlxTypedGroup();
var editingPart:Int = 0;

var allowInput:Bool = true;
var curSelected:Int = 0;

// Auto icon switching while selecting
var _ChangeToVariants:Bool = true;
var _TimeToChange:Float = 2;

function create() {
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

    var getList:Dynamic = CoolUtil.parseJson(Paths.json('noteSkins'));
    var textScale:Float = 0.65;
    var textX:Float = 100;

    for (jsonRaw in getList.skins) {
        var display:String = jsonRaw.displayName;
        var pathSkin:String = jsonRaw.path ?? null;
        var variants:Array<Array<String>> = jsonRaw.variants != null ? jsonRaw.variants.copy() : null;

        var SkinVar:NoteSkin = new NoteSkin();
        SkinVar.displayName = display;
        if (pathSkin != null) SkinVar.path = pathSkin;
        else SkinVar.variations = variants.copy();
        skinsList.push(SkinVar);

        var designedIcon:String = SkinVar.variations != null ? '${SkinVar.displayName}/${SkinVar.variations[0][0]}' : SkinVar.displayName;
        var iconSkin:FlxSprite = new FlxSprite().loadGraphic(Paths.image('Menu/skinsIcons/$designedIcon'));
        iconSkin.scale.set(0.5, 0.5);
        iconSkin.updateHitbox();
        iconSkin.antialiasing = Options.antialiasing;
        iconSkin.alpha = 0.6;
        skinIcons.add(iconSkin);

        if (_ChangeToVariants && SkinVar.variations != null) new FlxTimer().start(_TimeToChange, () -> {
            SkinVar.onChange = FlxMath.wrap(SkinVar.onChange + 1, 0, SkinVar.variations.length - 1);

            var newGraphic:String = '${SkinVar.displayName}/${SkinVar.variations[SkinVar.onChange][0]}';
            iconSkin.loadGraphic(Paths.image('Menu/skinsIcons/$newGraphic'));
        }, 0);

        var txt:String = SkinVar.variations != null ? '$display (+1)' : display;
        var skinText:Alphabet = new Alphabet(textX, 0, txt, 'bold');
        skinText.scale.set(textScale, textScale);
        skinText.updateHitbox();
        skinText.alpha = 0.6;
        skinsTexts.add(skinText);
    }

    add(buttons);

    curSkinTxt.x = (FlxG.width - curSkinTxt.width) - 10;
    add(curSkinTxt);

    scroll();
    // generateStrumAndNotes();
}

function update(e) {
    if (FlxG.sound.music.volume < 0.8)
		FlxG.sound.music.volume += 0.5 * dt;

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

        if (controls.BACK)
            closeRGBPanel();
    }
}

function openRGBPanel(id:Int) {
    inColorEditor = true;
    allowInput = false;

    selectedStrum = id;
    colorWheel = new UIColorwheel(510, 10, -1, currentColors[id][editingPart]);
    add(colorWheel);

    for (i => str in ['R', 'G', 'B']) {
        var button:UIButton = new UIButton(colorWheel.x + 55 * i, 150, str, () -> {
            editingPart = i;
            colorWheel.curColor = currentColors[id][editingPart];
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
}

function refreshNoteColors() for (i in 0...4) {
    var note:FunkinSprite = notesPreview.members[i];
    note.shader.red = currentColors[i];
    note.shader.green = currentColors[i];
    note.shader.blue = currentColors[i];
}

function getColorValue(color:Int, rgb:String):Int
    return switch (rgb)
    {
        default: (Std.int(color) >> 16) & 0xFF;
        case "g": (Std.int(color) >> 8) & 0xFF;
        case "b": Std.int(color) & 0xFF;
    }

function getColorArray(color:Int):Array<Float>
    return [
        getColorValue(color, "r") / 255,
        getColorValue(color, "g") / 255,
        getColorValue(color, "b") / 255
    ];

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

    for (groups in [strumPreview, notesPreview])
        groups.clear();
    generateStrumAndNotes(skin);
}

function generateSkinOptions(variable:NoteSkin) {
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

        var box:FlxSprite = new FlxSprite(startX + addX * i, Yoffset, Paths.image('Menu/skinsIcons/iconbox'));
        box.antialiasing = true;
        box.scale.set(boxScale, boxScale);
        box.updateHitbox();
        box.ID = i;
        optionsBoxes.add(box);

        var midPoint:Float = box.getMidpoint().x - iconAddX;
        var icon:FlxSprite = new FlxSprite(midPoint, box.y + 15, Paths.image('Menu/skinsIcons/$name/$prefix'));
        icon.antialiasing = Options.antialiasing;
        icon.scale.set(iconScale, iconScale);
        icon.updateHitbox();
        optionsIcons.add(icon);

        var midPoint:Float = icon.getGraphicMidpoint().x - 85;
        var skinTitle:FunkinText = new FunkinText(0, box.y + 90, 0, prefix, 20);
        skinTitle.antialiasing = true;
        skinTitle.alignment = 'center';
        skinTitle.x = midPoint;
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
        strum.addAnim('static', 'arrow${prefixs[i]}');
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

    if (skinsList[curSelected].displayName == 'Custom') {
        for (note in notesPreview) {
            note.shader = new CustomShader('RGB');
            note.shader.red = [0, 0, 0];
            note.shader.green = [0, 0, 0];
            note.shader.blue = [0, 0, 0];
        }
    }
}

class NoteSkin
{
    public var displayName:String = 'NULL';
    public var path:String = '';

    public var variations:Array<Array<String>> = null;
    public var onChange:Int = 0;
}