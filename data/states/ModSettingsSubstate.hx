import funkin.options.type.Checkbox;
import funkin.options.type.NumOption;
import AomText;

var optionsY:Array<Dynamic> = [];
var options:Array<Dynamic> = [];
var curOption:Int = 0;
var input:Bool = true;

var descText:AomText;
var descTextBG:FlxSprite;

function create() {
    var modName:String = data.Mod;
    var songName:String = data.Song;
    var inPause:Bool = data.PauseState;

    var pathJson:String = modName != 'RandomSongs' ? '$modName/settings' : 'RandomSongs/settings/$songName';

    if ((modName == '' || modName == null) || (modName == 'RandomSongs' && (songName != null && songName == ''))) {
        close();
        return;
    }
    if (!Assets.exists(Paths.file('Mods/$pathJson.json'))) {
        trace('No mod settings');
        close();
        return;
    }

    var stateCam:FlxCamera = new FlxCamera();
    stateCam.bgColor = 0;
    FlxG.cameras.add(stateCam, false);
	cameras = [stateCam];

    var bg:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
    bg.alpha = 0.5;
    add(bg);

    if (inPause) {
        var pauseWarning:AomText = new AomText(0, 0, 'You may need to restart the Song for any\nchange takes effect', 0.4);
        pauseWarning.alignment = 'center';
        pauseWarning.color = FlxColor.RED;
        pauseWarning.screenCenter(FlxAxes.X);
        pauseWarning.alpha = 0.001;
        add(pauseWarning);
        FlxTween.tween(pauseWarning, {alpha: 1}, 0.5);

        input = false;
        new FlxTimer().start(0.1, () -> input = true);
    }
    
    try {
        var Settings:Dynamic = CoolUtil.parseJson(Paths.file('Mods/$pathJson.json')).settings;

        for (i => values in Settings) {
            var setting:Dynamic = createOption(values.text, values.type, values.desc ?? '', values.id, values.value_modifier ?? null);
            setting.x += 50;
            setting.y = 0 + 150 * i;
            setting.ID = i;
            add(setting);

            optionsY.push(setting.y);
            options.push(setting);
        }
    }
    catch(e:Dynamic) {
        var file:String = modName != 'RandomSongs' ? modName : songName;
        trace('Failed to load settings file - [$file.json]');
        close();
        return;
    }

    descTextBG = new FlxSprite().makeSolid(1, 1, 0);
    descTextBG.alpha = 0.4;
    add(descTextBG);

    descText = new AomText(0, 0, '', 0.4);
    descText.alignment = 'center';
    add(descText);

    scrolls();
}

function update() if (input) {
    if (controls.BACK) {
        input = false;
        RefreshSaveDatas();
        CoolUtil.playMenuSFX(2);

        close();
        return;
    }

    if (controls.UP_P || controls.DOWN_P)
        scrolls((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0), true);

    if (options[curOption] != null) {
        var Item:Dynamic = options[curOption];

        if (controls.ACCEPT)
            Item.select();

        if (controls.LEFT_P || controls.RIGHT_P)
            Item.changeSelection((controls.LEFT_P ? -1 : 0) + (controls.RIGHT_P ? 1 : 0));

        for (i => items in options)
            updateItemsPos(items, optionsY[i]);
    }
}

function scrolls(i:Int = 0, s:Bool = false) {
    if (s) CoolUtil.playMenuSFX(0);
    options[curOption].selected = false;
    curOption = FlxMath.wrap(curOption + i, 0, options.length - 1);
    options[curOption].selected = true;

    descText.text = options[curOption].desc;
    descText.screenCenter(FlxAxes.X);
    descText.y = (FlxG.height - descText.height) - 20;

    descTextBG.makeSolid((descText.width + 20), (descText.height + 10), FlxColor.BLACK);
    descTextBG.x = (descText.x + (descText.width - descTextBG.width) / 2);
    descTextBG.y = (descText.y + (descText.height - descTextBG.height) / 2);
}

function updateItemsPos(object:Dynamic, center:Float)
    object.y = CoolUtil.fpsLerp(object.y, center - (object.height * curOption) + 270, 0.25);

function createOption(text:String, type:String, desc:String, id:Dynamic, ?values:Array<Dynamic>):Dynamic
{
    var Option:Dynamic = null;
    switch(type.toLowerCase()) {
        case 'checkbox': Option = new Checkbox(text, desc, id, null, FlxG.save.data);
        case 'number':
            var minVal:Float = values[0];
            var maxVal:Float = values[1];
            var stepVal:Float = values[2];

            Option = new NumOption(text, desc, minVal, maxVal, stepVal, id, null, FlxG.save.data);
    }

    return Option;
}