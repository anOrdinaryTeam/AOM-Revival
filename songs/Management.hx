import funkin.backend.utils.DiscordUtil;
import funkin.editors.charter.Charter;
importScript('data/scripts/ExternalFunctions');
using StringTools;

public var songName:String = PlayState.SONG.meta.name.split('/')[1];
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
    for (graphic in folder) graphicCache.cache(Paths.image('modCombos/$ratingPrefix/$graphic'));
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
public function changeNoteSkin(path:String, _strum:Dynamic, _part:String, _pixel:Bool) if (_strum != null) {
    var part:String = _part; // fucking null-safety
    var pixel:Bool = _pixel; // ^^^

    if (!pixel) if (!Assets.exists(Paths.image(path)) || !Assets.exists(Paths.getPath('images/$path.xml'))) {
        trace('Sprisheet/XML doesnt exists - [$path]');
        return;
    }
    else if (pixel)
        if (!Assets.exists(Paths.image('$path-pixels')) || Assets.exists(Paths.image(path + 'Ends'))) {
            trace('One of two parts of the notes doesnt exists');
            return;
        }
    
    if (part == 'strum' || part == 'strums' || part == 'both') for (i => strum in _strum.members) {
        var lastAnim:String = strum.animation.name;

        if (!pixel) {
            var prefixes:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
            strum.frames = Paths.getSparrowAtlas(path);
            strum.animation.addByPrefix('static', 'arrow${prefixes[i]}');
            strum.animation.addByPrefix('pressed', '${prefixes[i].toLowerCase()} press', 24, false);
            strum.animation.addByPrefix('confirm', '${prefixes[i].toLowerCase()} confirm', 24, false);
            strum.antialiasing = Options.antialiasing;
            strum.scale.set(0.7, 0.7);
        }
        else {
            var ID:Int = i;
            strum.loadGraphic(Paths.image('$path-pixels'), true, 17, 17);

            strum.animation.add("static", [ID]);
            strum.animation.add("pressed", [4 + ID, 8 + ID], 12, false);
            strum.animation.add("confirm", [12 + ID, 16 + ID], 24, false);
            strum.antialiasing = false;
            strum.scale.set(6, 6);
        }

        strum.updateHitbox();
        strum.animation.play(lastAnim);
    }

    if (part == 'note' || part == 'notes' || part == 'both') for (babyArrow in _strum.notes) if (babyArrow.noteType == null) {
        var color:String = ["purple", "blue", "green", "red"][babyArrow.strumID % 4];
        var lastAnim:String = babyArrow.animation.name;
        var newPrefix:String = switch(lastAnim) {
            case 'scroll': '${color}0';
            case 'hold': '$color hold piece0';
            case 'holdend': '${(color == "purple" ? 'pruple end hold' : '$color hold end')}0';
        }

        if (!pixel) {
            babyArrow.frames = Paths.getSparrowAtlas(path);
            babyArrow.animation.addByPrefix(lastAnim, newPrefix);
            babyArrow.antialiasing = Options.antialiasing;
            babyArrow.scale.set(0.7, 0.7);
        }
        else {
            // XDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD help
            var isSus:Bool = babyArrow.isSustainNote;
            var pixelPrefix:String = isSus ? 'Ends' : '-pixels';
            babyArrow.loadGraphic(Paths.image(path + pixelPrefix), true, isSus ? 7 : 17, isSus ? 6 : 17);

            if (isSus) {
                babyArrow.animation.add('hold', [babyArrow.strumID]);
                babyArrow.animation.add('holdend', [4 + babyArrow.strumID]);
            }
            else
                babyArrow.animation.add('scroll', [4 + babyArrow.strumID]);

            babyArrow.antialiasing = false;
            babyArrow.scale.set(6, 6);
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
        var image:String = currentMod == 'RandomSongs' || currentMod == 'Sonic.EXE' ? curSongID : currentMod.toLowerCase();

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