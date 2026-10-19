using StringTools;

var daColors:Array<Array<FlxColor>>;
var usingRGB:Bool = getSaveData('curSkinNoteDisplay').contains('Custom');
public var usingSkins:Bool = getSaveData('usingSkins');

var skinStr:String = getSaveData('curSkinNote');

function create() if (usingSkins && usingRGB)
    daColors = [for (i in FlxG.save.data.AOM_RGB) [for (j in i) j]];

function createShader(obj:Dynamic, id:Int, isStrum:Bool = false) {
    var red:FlxColor = daColors[id][0];
    var green:FlxColor = daColors[id][1];
    var blue:FlxColor = daColors[id][2];

    obj.shader = FunkinShader.fromFile('RGB');
    obj.shader.red = getColorArray(red);
    obj.shader.green = getColorArray(green);
    obj.shader.blue = getColorArray(blue);
    obj.shader.enabled = true;
    if (isStrum) obj.animation.onPlay.add((anim) -> {
        obj.shader.enabled = anim != 'static';
    });
}

function onNoteCreation(e) if ((usingSkins && skinStr.length > 0) && e.strumLineID == 1 && (e.noteType == null || e.noteSprite == 'game/notes/default')) {
    e.noteSprite = getSaveData('curSkinNote');
    e.note.splash = getSaveData('curSplash');
    if (usingRGB) createShader(e.note, e.strumID);
}

function onStrumCreation(e) if ((usingSkins && skinStr.length > 0) && e.player == 1) {
    e.sprite = getSaveData('curSkinNote');
    if (usingRGB) createShader(e.strum, e.strumID, true);
}

function onPlayerHit(e) if (e.noteType == null && usingRGB)
    e.showSplash = false;

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

    if (usingSkins && getSaveData('curSkinNote') == path) {
        trace('- ChangeNoteSkin: Stopped Function, current Skin Note is already in use');
        return;
    }

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