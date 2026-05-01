import flixel.addons.display.FlxBackdrop;

var curSkinTxt:FunkinText = new FunkinText(0, 10, 0, '< Current Skin: RGB >', 30);
var skinsTexts:FlxTypedGroup<Alphabet> = new FlxTypedGroup();
var skinsList:Array<NoteSkin> = [];

var allowInput:Bool = true;
var curSelected:Int = 0;

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
    var getList:Dynamic = CoolUtil.parseJson(Paths.json('noteSkins'));
    var textScale:Float = 0.65;
    var textX:Float = 80;

    for (jsonRaw in getList.skins) {
        var display:String = jsonRaw.displayName;
        var pathSkin:String = jsonRaw.path ?? null;
        var variants:Array<Array<String>> = jsonRaw.variants != null ? jsonRaw.variants.copy() : null;

        var SkinVar:NoteSkin = new NoteSkin();
        SkinVar.displayName = display;
        if (pathSkin != null) SkinVar.path = pathSkin;
        else SkinVar.variations = variants.copy();
        skinsList.push(SkinVar);

        var skinText:Alphabet = new Alphabet(textX, 0, display, 'bold');
        skinText.scale.set(textScale, textScale);
        skinText.updateHitbox();
        skinsTexts.add(skinText);
    }

    curSkinTxt.x = (FlxG.width - curSkinTxt.width) - 10;
    add(curSkinTxt);
}

function update(e) {
    for (k => option in skinsTexts.members) {
        var spaceBetween:Float = 100;
        var y:Float = ((FlxG.height - spaceBetween) / 2) + ((k - curSelected) * spaceBetween);
        option.y = CoolUtil.fpsLerp(option.y, y, 0.25);
    }
}

class NoteSkin
{
    public var displayName:String = 'NULL';
    public var path:String = '';
    public var variations:Array<Array<String>> = [];
}