import funkin.backend.utils.DiscordUtil;
import funkin.editors.charter.Charter;
importScript('data/scripts/ExternalFunctions');
using StringTools;

public var songName:String = PlayState.SONG.meta.name;
public var curDiff:String = PlayState.difficulty;
public var ratingPrefix:String = '';

public var useCamMov:Bool = false;
public var camMoveAmt:Float = 10;
public var usePsychSplashes:Bool = false;

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

public function changeNoteSkin(path:String, _strum:Dynamic, _part:String = 'both') if (_strum != null) {
    var part:String = _part.toLowerCase();
    if (!Assets.exists(Paths.image(path)) || !Assets.exists(Paths.getPath('images/$path.xml'))) {
        trace('Sprisheet/XML doesnt exists - [$path]');
        return;
    }

    if (part == 'strum' || part == 'strums' || part == 'both') for (i => strum in _strum.members) {
        var prefixes:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
        strum.frames = Paths.getSparrowAtlas(path);
        strum.animation.addByPrefix('static', 'arrow${prefixes[i]}');
        strum.animation.addByPrefix('pressed', '${prefixes[i].toLowerCase()} press', 24, false);
        strum.animation.addByPrefix('confirm', '${prefixes[i].toLowerCase()} confirm', 24, false);
        strum.updateHitbox();
    }

    if (part == 'note' || part == 'notes' || part == 'both') for (babyArrow in _strum.notes) {
        var lastAnim:String = babyArrow.animation.name;
        var color:String = ["purple", "blue", "green", "red"][babyArrow.strumID % 4];

        babyArrow.frames = Paths.getFrames(path);
        babyArrow.animation.addByPrefix(lastAnim, switch(lastAnim){
            case 'scroll': '${color}0';
            case 'hold': '${color} hold piece';
            case 'holdend': '${(color == "purple" ? 'pruple end hold' : '${color} hold end')}0';
        });
        babyArrow.animation.play(lastAnim);
        babyArrow.updateHitbox();
    }
}

function create() {
    RefreshSaveDatas();
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

function follow(offsets:Array<Float>) {
    camFollow.x += offsets[0];
    camFollow.y += offsets[1];
}

function postUpdate() if (useCamMov) switch(strumLines.members[curCameraTarget].characters[0].animation.curAnim.name) {
    case "singLEFT", "singLEFT-alt": follow([-camMoveAmt, 0]);
    case "singDOWN", "singDOWN-alt": follow([0, camMoveAmt]);
    case "singUP", "singUP-alt": follow([0, -camMoveAmt]);
    case "singRIGHT", "singRIGHT-alt": follow([camMoveAmt, 0]);
}

function postCreate() {
    if (FlxG.camera.zoom != defaultCamZoom) FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.01);
    camGame.pixelPerfectShake = true;
    camHUD.pixelPerfectShake = true;
}

function onNoteCreation(e) if (usePsychSplashes) e.note.splash = 'psych';
function onDadHit(_) _.strumGlowCancelled = FlxG.save.data.AOM_cpuStrumsGlow;
function onPlayerHit(_) {
    if (!_.note.isSustainNote) _.showSplash = !FlxG.save.data.AOM_disableSplashs;
    if (ratingPrefix != '') _.ratingPrefix = 'modCombos/$ratingPrefix/';
}

public function setObjectOrder(item:FlxBasic, pos:Int) if (item != null) {
    remove(item);
    insert(pos, item);
}

public function getObjectOrder(item:FlxBasic) if (item != null)
    return members.indexOf(item);