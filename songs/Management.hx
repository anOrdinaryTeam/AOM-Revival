import funkin.backend.utils.DiscordUtil;
import funkin.editors.charter.Charter;

public var songName:String = PlayState.SONG.meta.name;
public var curDiff:String = PlayState.difficulty;
var ratingPrefix:String = '';

public function getModImage(str:String) {
    if (currentMod == 'NONE')
        setManualPath(songName);

    return Paths.getPath('$pathSuffix' + '$currentMod/images/$str.png');
}

public function addSprite(spr:Dynamic) if (spr != null)
    insert(members.indexOf(gf), spr);

public function loadHud(hud:String, ver:String = 'IS NULL PENDEJO') {
    if (!getSaveData('allowCustomHud')) return;
    if (Assets.exists(Paths.script('data/HUDS/$hud'))) {
        importScript('data/HUDS/$hud');
        scripts.call('onHudLoad', [hud, ver]);
        for (chau in [scoreTxt, accuracyTxt, missesTxt]) chau.visible = false;
    }
    else
        trace('Hud "$hud" is missing');
}

public function setRatingPrefix(tag:String) {
    ratingPrefix = tag;
    var folder:Array<String> = Paths.getFolderContent('images/modCombos/$ratingPrefix', false, 1, true);
    for (graphic in folder) graphicCache.cache(Paths.image('modCombos/Eteled/$graphic'));
}

function create() {
    ReloadSaveData();
    updateDiscordPresence = () -> {
        var image:String = currentMod == 'RandomSongs' ? curSongID : currentMod.toLowerCase();
        DiscordUtil.changePresenceAdvanced({
            state: '$songName - [${curDiff.toUpperCase()}]',
            details: paused ? '- Paused' : '- Playing',
            largeImageKey: image
        });
    }

    if (Assets.exists(Paths.script('Assets-$currentMod/globalScript')))
        importScript('Assets-$currentMod/globalScript');
}

// function update() if (ACCESS_TO_CHARTER_EDITOR && controls.DEV_ACCESS)
//     FlxG.switchState(new Charter(songName, curDiff, null, false));

function postCreate() {
    if (FlxG.camera.zoom != defaultCamZoom) FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.01);
    camGame.pixelPerfectShake = true;
    camHUD.pixelPerfectShake = true;
}

function onDadHit(_) _.strumGlowCancelled = FlxG.save.data.AOM_cpuStrumsGlow;
function onPlayerHit(_) {
    if (!_.note.isSustainNote) _.showSplash = !FlxG.save.data.AOM_disableSplashs;
    if (ratingPrefix != '') _.ratingPrefix = 'modCombos/$ratingPrefix/';
}