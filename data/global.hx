import funkin.backend.system.framerate.Framerate;
import funkin.backend.assets.ModsFolderLibrary;
import funkin.backend.assets.ModsFolder;

var saveMap:Map<String, Dynamic> = [];
static var loadedSaveData:Bool = false;
static var changed:Bool = false;

public static var currentMod:String = 'NONE';
public static var currentModsList:Array<String>;

public static var lastModSelected:Int = 0;
public static var lastModSelected_Str:String = '';
public static var lastSongSelected:Int = 0;

public static var curSkin:String = 'Remake';

public static var CREATE_FILE_FEATURE:Bool = true;

using StringTools;

function new() {
    currentModsList = loadModFolders();
    trace('Loaded Mod List: $currentModsList');
}

function loadModFolders():Array<String>
{
    final folders:Array<String> = Paths.getFolderDirectories('');
    final result:Array<String> = [];

    for (folder in folders) if (folder.contains('Assets-')) {
        var _file:String = folder.replace('Assets-', '');
        result.push(_file);
    }

    return result;
}

function preStateSwitch() {
    importScript('data/scripts/ExternalFunctions');

    if (!changed)
        Framerate.codenameBuildField.visible = false;
    if (!loadedSaveData)
        LoadSaveData();
}

static function LoadSaveData() {
    // [ GENERAL ]
    FlxG.save.data.AOM_flashingLights ??= true;
    saveMap.set('FlashingLights', FlxG.save.data.AOM_flashingLights);

    FlxG.save.data.AOM_engineHUD ??= true;
    saveMap.set('allowCustomHud', FlxG.save.data.AOM_engineHUD);
    // [ END ]


    // [ PSYCH DATA ]
    FlxG.save.data.AOM_psych_HIDEHUD ??= false;
    saveMap.set('Psych_HideHud', FlxG.save.data.AOM_psych_HIDEHUD);

    FlxG.save.data.AOM_psych_TWEEN_SCORETXT_ONHIT ??= false;
    saveMap.set('Psych_BopScore', FlxG.save.data.AOM_psych_TWEEN_SCORETXT_ONHIT);

    FlxG.save.data.AOM_psych_HEALTHBAR_OPACITY ??= 1;
    saveMap.set('Psych_HudOpacity', FlxG.save.data.AOM_psych_HEALTHBAR_OPACITY);

    FlxG.save.data.AOM_psych_TIMEBAR_TYPE ??= "timeLeft";
    saveMap.set('Psych_TimeBarType', FlxG.save.data.AOM_psych_TIMEBAR_TYPE);

    FlxG.save.data.AOM_psych_SMOOTH_TIMEBAR ??= false;
    saveMap.set('Psych_SmoothTimeBar', FlxG.save.data.AOM_psych_SMOOTH_TIMEBAR);
    // [ END ]


    // [ KADE SAVE DATA ]
    FlxG.save.data.AOM_kade_TIMEBAR ??= true;
    saveMap.set('Kade_Timebar', FlxG.save.data.AOM_kade_TIMEBAR);

    FlxG.save.data.AOM_kade_WATERMARK ??= true;
    saveMap.set('Kade_Watermark', FlxG.save.data.AOM_kade_WATERMARK);

    FlxG.save.data.AOM_kade_WATERMARK_engine ??= 'KE';
    saveMap.set('Kade_WatermarkType', FlxG.save.data.AOM_kade_WATERMARK_engine);

    FlxG.save.data.AOM_kade_MISSES_TYPE ??= 'Combo Breaks';
    saveMap.set('Kade_MissesType', FlxG.save.data.AOM_kade_MISSES_TYPE);

    FlxG.save.data.AOM_kade_RATINGS ??= true;
    saveMap.set('Kade_Ratings', FlxG.save.data.AOM_kade_RATINGS);

    FlxG.save.data.AOM_kade_RATINGS_TYPE ??= 'KE';
    saveMap.set('Kade_RatingType', FlxG.save.data.AOM_kade_RATINGS_TYPE);
    // [ END ]
}

public static function getSaveData(var:String):Dynamic
    if (saveMap.get('$var') != null) return saveMap.get('$var');

public static function ReloadSaveData() {
    saveMap.set('allowCustomHud', FlxG.save.data.AOM_engineHUD);
    saveMap.set('FlashingLights', FlxG.save.data.AOM_flashingLights);

    saveMap.set('Psych_HideHud', FlxG.save.data.AOM_psych_HIDEHUD);
    saveMap.set('Psych_BopScore', FlxG.save.data.AOM_psych_TWEEN_SCORETXT_ONHIT);
    saveMap.set('Psych_HudOpacity', FlxG.save.data.AOM_psych_HEALTHBAR_OPACITY);
    saveMap.set('Psych_TimeBarType', FlxG.save.data.AOM_psych_TIMEBAR_TYPE);
    saveMap.set('Psych_SmoothTimeBar', FlxG.save.data.AOM_psych_SMOOTH_TIMEBAR);
    saveMap.set('Psych_SmoothTimeBar', FlxG.save.data.AOM_psych_SMOOTH_TIMEBAR);

    saveMap.set('Kade_Watermark', FlxG.save.data.AOM_kade_WATERMARK);
    saveMap.set('Kade_WatermarkType', FlxG.save.data.AOM_kade_WATERMARK_engine);
    saveMap.set('Kade_MissesType', FlxG.save.data.AOM_kade_MISSES_TYPE);
    saveMap.set('Kade_Ratings', FlxG.save.data.AOM_kade_RATINGS);
    saveMap.set('Kade_RatingType', FlxG.save.data.AOM_kade_RATINGS_TYPE);
}