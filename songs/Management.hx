importScript('data/scripts/ExternalFunctions');
import funkin.backend.utils.DiscordUtil;
import funkin.editors.charter.Charter;
using StringTools;

public var songName:String = PlayState.SONG.meta.displayName;
public var songPath:String = PlayState.SONG.meta.name;

public var curDiff:String = PlayState.difficulty;
public var ratingPrefix:String = '';

public var useCamMov:Bool = false;
public var camMoveAmt:Float = 10;
public var usePsychSplashes:Bool = false;

public function getModImage(str:String) {
    if (currentMod == 'NONE')
        findModSong(songName);

    return Paths.getPath('Mods/$currentMod/images/$str.png');
}

public function addSprite(spr:Dynamic) if (spr != null)
    insert(members.indexOf(gf ?? dad), spr);

public function loadHud(hud:String, ?ver:String = 'IS NULL PENDEJO') {
    if (!getSaveData('allowCustomHud'))
        return;
    
    // var nameHUD:String = getSaveData('customHud');
    // var customHUD:String = (nameHUD != 'none' ? nameHUD : hud);

    if (Assets.exists(Paths.script('data/HUDS/$hud'))) {
        importScript('data/HUDS/$hud');
        scripts.call('onHudLoad', [hud, ver]);

        for (chau in [scoreTxt, accuracyTxt, missesTxt])
            chau.visible = false;
    }
    else
        trace('Hud "$hud" is missing');
}

public function setRatingPrefix(tag:String) {
    ratingPrefix = tag;
    var folder:Array<String> = Paths.getFolderContent('images/modCombos/$ratingPrefix', false, 1, true);
    for (graphic in folder) graphicCache.cache(Paths.image('modCombos/$ratingPrefix/$graphic'));
}

public function setObjectOrder(item:FlxBasic, pos:Int) if (item != null) {
    remove(item);
    insert(pos, item);
}

public function getObjectOrder(item:FlxBasic) if (item != null)
    return members.indexOf(item);

public function destroitSmash(item:FlxBasic) if (item != null) {
    item.kill();
    item.destroy();
    remove(item, true);
}

function AOM_RPC_FUNCTION()
{
    var singleArts:Array<String> = ['RandomSongs', 'Sonic.EXE', 'Retrospecter'];
    var image:String = singleArts.contains(currentMod) ? curSongID : currentMod.toLowerCase();

    var linkImage:String = 'https://raw.githubusercontent.com/anOrdinaryTeam/AOM-rpc-arts-container/refs/heads/main/${curSongID}.png';
    DiscordUtil.changePresenceAdvanced({
        state: '$songName - [${curDiff.toUpperCase()}]',
        details: paused ? '- Paused' : '- Playing',
        largeImageKey: linkImage
    });
}

function create() {
    RefreshSaveDatas();

    if (Assets.exists(Paths.script('Mods/$currentMod/globalScript')))
        importScript('Mods/$currentMod/globalScript');

    updateDiscordPresence = AOM_RPC_FUNCTION;
}

function postCreate() {
    if (FlxG.camera.zoom != defaultCamZoom)
        FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.01);

    camGame.pixelPerfectShake = true;
    camHUD.pixelPerfectShake = true;
    PauseSubState.script = 'data/scripts/PauseNewOptions';
}

function postUpdate() if (useCamMov && !forceCamPos) switch(strumLines.members[curCameraTarget].characters[0].animation.curAnim.name) {
    case "singLEFT", "singLEFT-alt": follow([-camMoveAmt, 0]);
    case "singDOWN", "singDOWN-alt": follow([0, camMoveAmt]);
    case "singUP", "singUP-alt": follow([0, -camMoveAmt]);
    case "singRIGHT", "singRIGHT-alt": follow([camMoveAmt, 0]);
}

function follow(offsets:Array<Float>) {
    camFollow.x += offsets[0];
    camFollow.y += offsets[1];
}

function onNoteCreation(e)
    if (usePsychSplashes) e.note.splash = 'psych';

function onDadHit(_)
    _.strumGlowCancelled = FlxG.save.data.AOM_cpuStrumsGlow;

function onPlayerHit(_) {
    if (!_.note.isSustainNote) _.showSplash = !FlxG.save.data.AOM_disableSplashs;
    if (ratingPrefix != '') _.ratingPrefix = 'modCombos/$ratingPrefix/';
}