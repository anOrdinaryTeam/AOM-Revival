import funkin.backend.system.macros.GitCommitMacro;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.ShaderResizeFix;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.utils.NativeAPI;
import openfl.system.Capabilities;
import hxvlc.util.Handle;
import Sys;

static var saveMap:Map<String, Dynamic> = [];
static var loadedSaveData:Bool = false;
static var changed:Bool = false;

public static var currentMod:String = 'NONE';
public static var currentModsList:Array<String>;

public static var lastModSelected:Int = 0;
public static var lastModSelected_Str:String = '';
public static var lastSongSelected:Int = 0;
public static var lastDiffSelected:Int = 0;

public static var CREATE_FILE_FEATURE:Bool = true;
#if !ARKOSE_PORT
// Meant to be use in Fatality + saving the Res for anybody
// who uses a custom res on Cne (like me with a 768p monitor)
public static var ORIGINAL_RES:Array<Float>;
#end

using StringTools;

function new() {
    Handle.init([]);
    currentModsList = loadModFolders();
    trace('Loaded Mod List: $currentModsList ');

    if (GitCommitMacro.commitHash == '9757b00') {
        NativeAPI.showMessageBox('Not in Nightly Build', 'Download the Experimental CNE');
        CoolUtil.openURL("https://codename-engine.com/");
        Sys.exit(0);
    }
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

public static function RefreshSaveDatas() {
    // [ GENERAL ]
    if (saveMap.get('FlashingLights') != FlxG.save.data.AOM_flashingLights)
        saveMap.set('FlashingLights', FlxG.save.data.AOM_flashingLights);

    if (saveMap.get('allowCustomHud') != FlxG.save.data.AOM_engineHUD)
        saveMap.set('allowCustomHud', FlxG.save.data.AOM_engineHUD);

    if (saveMap.get('usingSkins') != FlxG.save.data.AOM_usingSkin)
        saveMap.set('usingSkins', FlxG.save.data.AOM_usingSkin);

    if (saveMap.get('curSkinNote') != FlxG.save.data.AOM_curSkinNote)
        saveMap.set('curSkinNote', FlxG.save.data.AOM_curSkinNote);

    if (saveMap.get('curSkinNoteDisplay') != FlxG.save.data.AOM_curSkinNote_Display)
        saveMap.set('curSkinNoteDisplay', FlxG.save.data.AOM_curSkinNote_Display);
    // [ END ]

    
    // [ MODS/SONGS CONFIGS ]
    if (saveMap.get('Fatality_MoveWindow') != FlxG.save.data.AOM_Fatality_WindowMove)
        saveMap.set('Fatality_MoveWindow', FlxG.save.data.AOM_Fatality_WindowMove);

    if (saveMap.get('Fatality_SpawnPopUps') != FlxG.save.data.AOM_Fatality_PopUps)
        saveMap.set('Fatality_SpawnPopUps', FlxG.save.data.AOM_Fatality_PopUps);

    if (saveMap.get('Fatality_PopUpsLimiter') != FlxG.save.data.AOM_Fatality_PopUps)
        saveMap.set('Fatality_PopUpsLimiter', FlxG.save.data.AOM_Fatality_PopUps);
    // [ END ]


    // [ PSYCH DATA ]
    if (saveMap.get('Psych_HideHud') != FlxG.save.data.AOM_psych_HIDEHUD)
        saveMap.set('Psych_HideHud', FlxG.save.data.AOM_psych_HIDEHUD);

    if (saveMap.get('Psych_BopScore') != FlxG.save.data.AOM_psych_TWEEN_SCORETXT_ONHIT)
        saveMap.set('Psych_BopScore', FlxG.save.data.AOM_psych_TWEEN_SCORETXT_ONHIT);

    if (saveMap.get('Psych_HudOpacity') != FlxG.save.data.AOM_psych_HEALTHBAR_OPACITY)
        saveMap.set('Psych_HudOpacity', FlxG.save.data.AOM_psych_HEALTHBAR_OPACITY);

    if (saveMap.get('Psych_TimeBarType') != FlxG.save.data.AOM_psych_TIMEBAR_TYPE)
        saveMap.set('Psych_TimeBarType', FlxG.save.data.AOM_psych_TIMEBAR_TYPE);
    
    if (saveMap.get('Psych_SmoothTimeBar') != FlxG.save.data.AOM_psych_SMOOTH_TIMEBAR)
        saveMap.set('Psych_SmoothTimeBar', FlxG.save.data.AOM_psych_SMOOTH_TIMEBAR);
    // [ END ]


    // [ KADE DATA ]
    if (saveMap.get('Kade_Timebar') != FlxG.save.data.AOM_kade_TIMEBAR)
        saveMap.set('Kade_Timebar', FlxG.save.data.AOM_kade_TIMEBAR);

    if (saveMap.get('Kade_Watermark') != FlxG.save.data.AOM_kade_WATERMARK)
        saveMap.set('Kade_Watermark', FlxG.save.data.AOM_kade_WATERMARK);

    if (saveMap.get('Kade_WatermarkType') != FlxG.save.data.AOM_kade_WATERMARK_engine)
        saveMap.set('Kade_WatermarkType', FlxG.save.data.AOM_kade_WATERMARK_engine);

    if (saveMap.get('Kade_MissesType') != FlxG.save.data.AOM_kade_MISSES_TYPE)
        saveMap.set('Kade_MissesType', FlxG.save.data.AOM_kade_MISSES_TYPE);

    if (saveMap.get('Kade_Ratings') != FlxG.save.data.AOM_kade_RATINGS)
        saveMap.set('Kade_Ratings', FlxG.save.data.AOM_kade_RATINGS);

    if (saveMap.get('Kade_RatingType') != FlxG.save.data.AOM_kade_RATINGS_TYPE)
        saveMap.set('Kade_RatingType', FlxG.save.data.AOM_kade_RATINGS_TYPE);

    if (saveMap.get('Kade_HitMS') != FlxG.save.data.AOM_kade_HIT_MS)
        saveMap.set('Kade_HitMS', FlxG.save.data.AOM_kade_HIT_MS);
    // [ END ]
}

static function LoadSaveData() {
    // [ GENERAL ]
    FlxG.save.data.AOM_flashingLights ??= true;
    saveMap.set('FlashingLights', FlxG.save.data.AOM_flashingLights);

    FlxG.save.data.AOM_engineHUD ??= true;
    saveMap.set('allowCustomHud', FlxG.save.data.AOM_engineHUD);

    FlxG.save.data.AOM_usingSkin ??= false;
    saveMap.set('usingSkins', FlxG.save.data.AOM_usingSkin);

    FlxG.save.data.AOM_curSkinNote ??= '';
    saveMap.set('curSkinNote', FlxG.save.data.AOM_curSkinNote);

    FlxG.save.data.AOM_curSkinNote_Display ??= 'NONE';
    saveMap.set('curSkinNoteDisplay', FlxG.save.data.AOM_curSkinNote_Display);

    FlxG.save.data.AOM_RGB ??= [
        [0xFFC24B99, 0xFFFFFFFF, 0xFF3C1F56],
        [0xFF00FFFF, 0xFFFFFFFF, 0xFF1542B7],
        [0xFF12FA05, 0xFFFFFFFF, 0xFF0A4447],
        [0xFFF9393F, 0xFFFFFFFF, 0xFF651038]
    ];
    // [ END ]

    // [ MODS/SONGS CONFIG ]

        // [ FATALITY ]
        FlxG.save.data.AOM_Fatality_WindowMove ??= true;
        saveMap.set('Fatality_MoveWindow', FlxG.save.data.AOM_Fatality_WindowMove);

        FlxG.save.data.AOM_Fatality_PopUps ??= true;
        saveMap.set('Fatality_SpawnPopUps', FlxG.save.data.AOM_Fatality_PopUps);

        FlxG.save.data.AOM_Fatality_Limiter_PopUps ??= false;
        saveMap.set('Fatality_PopUpsLimiter', FlxG.save.data.AOM_Fatality_Limiter_PopUps);
        // [ END ]

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


    // [ KADE DATA ]
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

    FlxG.save.data.AOM_kade_HIT_MS ??= false;
    saveMap.set('Kade_HitMS', FlxG.save.data.AOM_kade_HIT_MS);
    // [ END ]
}

public static function getSaveData(var:String):Dynamic
    if (saveMap.get('$var') != null)
        return saveMap.get('$var');
    else
        trace('"$var" Doesnt exists');

public static function changeToDefaultRPC(_state:String) {
    DiscordUtil.changePresenceAdvanced({
        state: _state,
        largeImageKey: 'icon'
    });
}

var winWidth:Int;
var winHeight:Int;

public static function windowShit(newWidth:Int, newHeight:Int, ?winScale:Float = 0.9){
    if(newWidth != 1280 || newHeight != 720) {
        aspectShit(newWidth, newHeight);
        FlxG.resizeWindow(winWidth * winScale, winHeight * winScale);
    } 
    else
        FlxG.resizeWindow(newWidth, newHeight);

    FlxG.resizeGame(newWidth, newHeight);
    FlxG.scaleMode.width = FlxG.width = FlxG.initialWidth = newWidth;
    FlxG.scaleMode.height = FlxG.height = FlxG.initialHeight = newHeight;
    ShaderResizeFix.doResizeFix = true;
    ShaderResizeFix.fixSpritesShadersSizes();
    window.x = Capabilities.screenResolutionX/2 - window.width/2;
    window.y = Capabilities.screenResolutionY/2 - window.height/2;
}

function aspectShit(width:Int, height:Int):String {
    var idk1:Int = height;
    var idk2:Int = width;
    while (idk1 != 0) {
        idk1 = idk2 % idk1;
        idk2 = height;
    }
    winWidth = Math.floor(Capabilities.screenResolutionX * ((height / idk2) / (width / idk2))) > Capabilities.screenResolutionY ? Math.floor(Capabilities.screenResolutionY * ((width / idk2) / (height / idk2))) : Capabilitities.screenResolutionX;
    winHeight = Math.floor(Capabilities.screenResolutionX * ((height / idk2) / (width / idk2))) > Capabilities.screenResolutionY ? Capabilities.screenResolutionY : Math.floor(Capabilities.screenResolutionX * ((height / idk2) / (width / idk2)));
}