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

    obj.shader = new CustomShader('RGB');
    obj.shader.red = getColorArray(red);
    obj.shader.green = getColorArray(green);
    obj.shader.blue = getColorArray(blue);
    obj.shader.enabled = true;
    if (isStrum) obj.animation.onFrameChange.add((anim) -> {
        obj.shader.enabled = anim != 'static';
    });
}

function onNoteCreation(e) if ((usingSkins && skinStr != '') && e.strumLineID == 1 && e.noteType == null) {
    e.noteSprite = getSaveData('curSkinNote');
    e.note.splash = getSaveData('curSplash');
    if (usingRGB) createShader(e.note, e.strumID);
}

function onStrumCreation(e) if ((usingSkins && skinStr != '') && e.player == 1) {
    e.sprite = getSaveData('curSkinNote');
    if (usingRGB) createShader(e.strum, e.strumID, true);
}

function onPlayerHit(e) if (e.noteType == null && usingRGB)
    e.showSplash = false;