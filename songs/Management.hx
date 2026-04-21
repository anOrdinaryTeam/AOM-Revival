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

/**
* Simple Strum/Note Skin Changer 
* (TO USE IT IS REQUIRED TO PRECACHE THE SPRITES TO USE)
+
* @param path Path to the sprite
* @param _strum Designed Strum to change -> cpu/cpuStrums | player/playerStrums | strumLines.members[idx]
* @param _part (Optional) Which part of the Object to change -> 'strum'/'strums' | 'note'/'notes' | 'both'
* @param _pixel (Optional) Self-explain
*/
public function changeNoteSkin(path:String, _strum:Dynamic, ?_part:String, ?_pixel:Bool) if (_strum != null) {
    var realPath:String = 'modsNotes/$path';
    var part:String = _part ?? 'both';
    var pixel:Bool = _pixel ?? false;

    if (!pixel) if (!Assets.exists(Paths.image(path)) || !Assets.exists(Paths.getPath('images/$path.xml'))) {
        trace('Sprisheet/XML doesnt exists - [$path]');
        return;
    }
    else 
        if (!Assets.exists(Paths.image('$path-pixels')) || Assets.exists(Paths.image(path + 'Ends'))) {
            trace('One of two parts of the notes doesnt exists');
            return;
        }
    
    if (part == 'strum' || part == 'strums' || part == 'both') for (i => strum in _strum.members) {
        if (!pixel) {
            var prefixes:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
            strum.frames = Paths.getSparrowAtlas(realPath);
            strum.animation.addByPrefix('static', 'arrow${prefixes[i]}');
            strum.animation.addByPrefix('pressed', '${prefixes[i].toLowerCase()} press', 24, false);
            strum.animation.addByPrefix('confirm', '${prefixes[i].toLowerCase()} confirm', 24, false);
        }
        else {
            var ID:Int = strum.strumID;
            strum.loadGraphic(Paths.image(realPath));

            strum.animation.add("static", [ID]);
            strum.animation.add("pressed", [4 + ID, 8 + ID], 12, false);
            strum.animation.add("confirm", [12 + ID, 16 + ID], 24, false);
            strum.scale.set(6, 6);
        }

        strum.updateHitbox();
    }

    if (part == 'note' || part == 'notes' || part == 'both') for (babyArrow in _strum.notes) {
        var color:String = ["purple", "blue", "green", "red"][babyArrow.strumID % 4];
        var lastAnim:String = babyArrow.animation.name;

        if (!pixel) {
            var newPrefix:String = switch(lastAnim) {
                case 'scroll': '${color}0';
                case 'hold': '$color hold piece';
                case 'holdend': '${(color == "purple" ? 'pruple end hold' : '$color hold end')}0';
            }

            babyArrow.frames = Paths.getSparrowAtlas(realPath);
            babyArrow.animation.addByPrefix(lastAnim, newPrefix);
        }
        else {
            babyArrow.loadGraphic(Paths.image(realPath));
            note.animation.add(lastAnim, [4 + babyArrow.strumID]);
        }

        
        babyArrow.animation.play(lastAnim);
        babyArrow.updateHitbox();
    }
}

public function setObjectOrder(item:FlxBasic, pos:Int) if (item != null) {
    remove(item);
    insert(pos, item);
}

public function getObjectOrder(item:FlxBasic) if (item != null)
    return members.indexOf(item);

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