import funkin.backend.utils.DiscordUtil;

public var songName:String = PlayState.SONG.meta.name;
public var curDiff:String = PlayState.difficulty;

public static function getModImage(str:String) {
    if (currentMod == 'NONE')
        setManualPath(songName);

    return Paths.getPath('$pathSuffix' + '$currentMod/images/$str.png');
}

public static function addSprite(spr:Dynamic) if (spr != null)
    insert(members.indexOf(gf), spr);

function loadCustomHUD() {
    var hud:String = '';

    switch(currentMod) {
        case 'Sky' | 'Zardy' | 'xEvent' | 'Tabi' | 'Tricky': hud = 'KadeEngine';
        case 'Agoti': hud = "Mic'dUpEngine";
        default:
            switch(songName) {
                case 'Sink' | 'Corruptro': hud = 'PsychEngine';
                case 'Megalo Strike Back': hud = 'KadeEngine';
                case 'Treacherous Thorns': hud = 'Vanilla';
            }
    }

    if (hud != '') {
        importScript('data/HUDS/$hud');
        scripts.call('onHudLoad');
        for (chau in [scoreTxt, accuracyTxt, missesTxt])
            chau.visible = false;
    }
}

function onDadHit(_)
    _.strumGlowCancelled = FlxG.save.data.AOM_cpuStrumsGlow;
function onPlayerHit(_) if (!_.note.isSustainNote)
    _.showSplash = !FlxG.save.data.AOM_disableSplashs;

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
}

function postCreate() {
    if (getSaveData('allowCustomHud')) loadCustomHUD();
    camGame.pixelPerfectShake = true;
    camHUD.pixelPerfectShake = true;
}