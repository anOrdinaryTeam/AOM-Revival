import flixel.addons.display.FlxBackdrop;
import funkin.backend.MusicBeatGroup;

var allowInput:Bool = true;
var curSelected:Int = 0;
var curPage:Int = 0;

var bg:FlxSprite = new FlxSprite();
var optsGrp:Array<Array<Option>> = [];
var namesGrp:Array<Array<FakeAlphabet>> = [];

var limitPage:Int = 5;
var actualPages:Int = 0;
var offScreenX:Float = -500;
var offsetY:Float = 115;
var list:Array<String> = CoolUtil.coolTextFile(Paths.txt('skins'));

function create() {
    CoolUtil.playMusic(Paths.music('pixel/breakfast'), true);
    changeToDefaultRPC('In the Skin Selector');

    bg.loadGraphic(Paths.image('menus/menuDesat'));
    bg.antialiasing = Options.antialiasing;
    bg.screenCenter();
    add(bg);

    var backdrop:FlxBackdrop = new FlxBackdrop(getImage('Menu/skinmenu'), FlxAxes.XY, -1);
    backdrop.antialiasing = Options.antialiasing;
    backdrop.velocity.set(40, 40);
    backdrop.alpha = 0.07;
    add(backdrop);

    var curLimit:Int = 0;
    var designedPage:Int = 0;
    var alphabetScale:Float = 0.6;

    for (i => data in list) {
        var split:Array<String> = data.split(':');

        if (optsGrp[designedPage] == null) optsGrp.push([]);
        if (namesGrp[designedPage] == null) namesGrp.push([]);

        var opt:Option = new Option(0, 15 + offsetY * curLimit, split[1]);
        opt.ID = curLimit;
        opt.selfPage = designedPage;
        add(opt);

        var charName:FakeAlphabet = new FakeAlphabet(0, 45 + offsetY * curLimit, split[0], 'bold');
        charName.antialiasing = Options.antialiasing;
        charName.ID = curLimit;
        charName.selfPage = designedPage;
        charName.scale.set(alphabetScale, alphabetScale);
        charName.updateHitbox();
        add(charName);

        optsGrp[designedPage].push(opt);
        namesGrp[designedPage].push(charName);

        if (curLimit == limitPage) {
            curLimit = 0;
            designedPage++;
            actualPages++;
        }
        else
            curLimit++;
    }
    
    changePage(0);
}

function update(dt) {
    if (FlxG.sound.music.volume < 0.8)
		FlxG.sound.music.volume += 0.5 * dt;

    if (allowInput) {
        scroll((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);

        if (controls.LEFT_P || controls.RIGHT_P)
            changePage((controls.LEFT_P ? -1 : 0) + (controls.RIGHT_P ? 1 : 0));

        if (controls.BACK)
            FlxG.switchState(new ModState('Menu'));
    }
}

function scroll(i:Int = 0, f:Bool = false) {
    if (i == 0 && !f) return;
    CoolUtil.playMenuSFX(0, 0.5);
    curSelected = FlxMath.wrap(curSelected + i, 0, optsGrp[curPage].length - 1);

    var alphaUnselected:Float = 0.6;
    for (item in optsGrp[curPage])
        item.icon.alpha = item.ID == curSelected ? 1 : alphaUnselected;
    for (item in namesGrp[curPage])
        item.alpha = item.ID == curSelected ? 1 : alphaUnselected;
}

function changePage(i:Int) {
    CoolUtil.playMenuSFX(0, 0.5);

    curPage = FlxMath.wrap(curPage + i, 0, actualPages);
    curSelected = 0;
    scroll(0, true);

    // Options
    for (pre in optsGrp) for (item in pre) if (item.selfPage == curPage) {
        FlxTween.cancelTweensOf(item);
        FlxTween.tween(item, {x: 0}, 0.2, {ease: FlxEase.quadInOut});
    }
    else {
        FlxTween.cancelTweensOf(item);
        FlxTween.tween(item, {x: offScreenX}, 0.2, {ease: FlxEase.quadInOut});
    }

    // Alphabet
    for (pre in namesGrp) for (item in pre) if (item.selfPage == curPage) {
        FlxTween.cancelTweensOf(item);
        FlxTween.tween(item, {x: 135}, 0.2, {ease: FlxEase.quadInOut});
    }
    else {
        FlxTween.cancelTweensOf(item);
        FlxTween.tween(item, {x: offScreenX}, 0.2, {ease: FlxEase.quadInOut});
    }
}

class Option extends MusicBeatGroup
{
    public var bg:FlxSprite = new FlxSprite();
    public var barAbove:FlxSprite = new FlxSprite();
    public var barBelow:FlxSprite = new FlxSprite();
    public var icon:HealthIcon;

    public var selfPage:Int = 0;

    // not really private, i know that.
    private var bg_Width:Int = 500;
    private var bg_Height:Int = 100;
    private var bg_Alpha:Float = 0.2;

    private var bar_Anchor:Float = 5;
    private var bar_Alpha:Float = 0.8;
    private var bar_BelowY:Float = 100;

    private var icon_scale:Float = 0.73;
    private var icon_defAlpha:Float = 0.7;

    public function new(x:Float, y:Float, _icon:String) {
        super(x, y);

        bg.makeSolid(bg_Width, bg_Height, FlxColor.BLACK);
        bg.alpha = bg_Alpha;

        barAbove.makeSolid(bg_Width, bar_Anchor, -1);
        barAbove.x = bg.x;
        barAbove.alpha = bar_Alpha;

        barBelow.makeSolid(bg_Width, bar_Anchor, -1);
        barBelow.x = bg.x;
        barBelow.y += bar_BelowY;
        barBelow.alpha = bar_Alpha;

        icon = new HealthIcon(_icon);
        icon.antialiasing = Options.antialiasing;
        icon.scale.set(icon_scale, icon_scale);
        icon.updateHitbox();
        icon.x += 10;
        icon.alpha = icon_defAlpha;

        add(bg);
        add(barAbove);
        add(barBelow);
        add(icon);
    }
}

class FakeAlphabet extends Alphabet
{
    public var selfPage:Int = 0;

    public function new(X:Float, Y:Float, Text:String, Thing:String)
        super(X, Y, Text, Thing);
}