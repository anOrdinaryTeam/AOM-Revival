// made by myself because i didnt understand Eteled Code
import funkin.game.Note;
using StringTools;

var austinGlitch:Character;

var glitchedStrumCpu:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var glitchedStrumPlayer:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var glitchedNotes:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();

var bgsGlitched:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var glitchedCam:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();

var visibleGlitch(default, set):Bool = false;
var currentGlitchedBG(default, set):Int = 0;

var usingGlitchedBGs:Bool = false;
public var useGlitchedNotes:Bool = false;
public var startGlitchedBGS:Bool = false;

function set_visibleGlitch(val:Bool) {
    if (austinGlitch != null) {
        var toHide:Character = austinGlitch.isPlayer ? boyfriend : dad;
        toHide.alpha = val ? 0.001 : 1;
        austinGlitch.alpha = val ? 1 : 0.001;
    }

    for (i in 0...4) {
        playerStrums.members[i].alpha = val ? 0.001 : 1;
        glitchedStrumPlayer.members[i].alpha = val ? 1 : 0.001;

        if (glitchedStrumCpu.members.length > 0) {
            cpuStrums.members[i].alpha = val ? 0.001 : 1;
            glitchedStrumCpu.members[i].alpha = val ? 1 : 0.001;
        }
    }

    if (val) generateGlitchedNotes();
    else glitchedNotes.clear();

    return val;
}

function set_currentGlitchedBG(val:Int) if (bgsGlitched.members.length > 0 && glitchedCam.members.length > 0) {
    var randomAlpha:Float = FlxG.random.float(0.1, 0.2);
    var randomTime:Float = FlxG.random.float(0.2, 0.5);

    if (val == 7) {
        var randomBG:FunkinSprite = glitchedCam.members[FlxG.random.int(0, glitchedCam.members.length - 1)];
        randomBG.playAnim('play', true);
        randomBG.alpha = randomAlpha;
        new FlxTimer().start(randomTime, () -> randomBG.alpha = 0);
    }
    else if (val == 8) {
        var randomBG:FunkinSprite = bgsGlitched.members[FlxG.random.int(0, bgsGlitched.members.length - 1)];
        randomBG.playAnim('play', true);
        randomBG.alpha = randomAlpha;
        new FlxTimer().start(randomTime, () -> randomBG.alpha = 0);
    }
}

function postCreate() if (!getSaveData('allowCustomHud'))
    addStuff();
function postHudLoad() if (getSaveData('allowCustomHud'))
    addStuff();

function stepHit() {
    if (useGlitchedNotes) {
        var glitchChance:Int = FlxG.random.int(0, 13);

        if (glitchChance == 7) {
            visibleGlitch = true;
            new FlxTimer().start(FlxG.random.float(0.1, 0.5), () -> visibleGlitch = false);
        }
    }

    if (usingGlitchedBGs && startGlitchedBGS)
        currentGlitchedBG = FlxG.random.int(0, 15);
}

function beatHit() if (austinGlitch != null)
    if (curBeat % 2 == 0) austinGlitch.dance();

function onDadHit(_) if (austinGlitch != null)
    if (!austinGlitch.curCharacter.contains('-playable')) austinGlitch.playSingAnim(_.direction);

function onPlayerHit(_) if (austinGlitch != null)
    if (austinGlitch.curCharacter.contains('-playable')) austinGlitch.playSingAnim(_.direction);

function generateStrum(player:Bool) {
    var getterStrums = player ? playerStrums : cpuStrums;
    var group:FlxTypedGroup = player ? glitchedStrumPlayer : glitchedStrumCpu;
    var name:String = player ? boyfriend.curCharacter : dad.curCharacter;
    var skin:String = player ? (name == 'Eteled/bf-mii' ? 'bfGlitch' : 'austinGlitch') : (name.contains('eteled') ? 'eteled' : 'austinGlitch');
    graphicCache.cache(Paths.image('modNotes/Eteled/$skin'));

    for (i in 0...4) {
        if (skin == 'eteled') break;
        var strum:FunkinSprite = new FunkinSprite(getterStrums.members[i].x, getterStrums.members[i].y);
        strum.loadSprite(Paths.image('modNotes/Eteled/$skin'));
        strum.addAnim('static', 'arrow${['LEFT', 'DOWN', 'UP', 'RIGHT'][i]}', 0, false);
        strum.playAnim('static', true);
        strum.antialiasing = Options.antialiasing;
        strum.camera = camHUD;
        strum.scale.set(0.7, 0.7);
        strum.updateHitbox();
        strum.alpha = 0.001;
        group.add(strum);
    }
}

function addStuff() if (useGlitchedNotes) {
    insert(members.indexOf(strumLines), glitchedStrumCpu);
    insert(members.indexOf(strumLines), glitchedStrumPlayer);

    glitchedNotes.camera = camHUD;
    insert(members.indexOf(strumLines), glitchedNotes);

    generateStrum(true);
    generateStrum(false);

    if (dad.curCharacter == 'Eteled/austin' || boyfriend.curCharacter == 'Eteled/austin-playable') {
        var playerVersion:Bool = boyfriend.curCharacter.contains('-playable');
        var getter:Character = playerVersion ? boyfriend : dad;
        var str:String = playerVersion ? 'austin-glitch-playable' : 'austin-glitch';

        austinGlitch = new Character(getter.x, getter.y, 'Eteled/$str', playerVersion);
        austinGlitch.antialiasing = Options.antialiasing;
        austinGlitch.alpha = 0.001;
        insert(members.indexOf(dad), austinGlitch);
    }
}

function generateGlitchedNotes() {
    var P1:String = boyfriend.curCharacter;
    var P2:String = dad.curCharacter;

    var P1_skin:String = (P1 == 'Eteled/bf-mii' ? 'bfGlitch' : 'austinGlitch');
    var P2_skin:String = 'austinGlitch';

    var maxNotes:Int = !P2.contains('eteled') ? 32 : 32 / 2;
    var rdmLength:Int = FlxG.random.int(2, 24);
    var strumsX:Array<Float> = [];
    var colors:Array<String> = ['purple', 'blue', 'green', 'red'];

    for (i in 0...rdmLength) {
        var chooseStrum:Bool = FlxG.random.bool();
        var strum = !P2.contains('eteled') ? (chooseStrum ? player : cpu) : player;
        var skin:String = !P2.contains('eteled') ? (chooseStrum ? P1_skin : P2_skin) : P1_skin;
        
        var rdmStrum:Int = FlxG.random.int(0, 3);
        var offX:Float = strum.members[rdmStrum].x;
        var offY:Float = FlxG.random.float(strum.members[0].y, 600);

        var spr:FunkinSprite = new FunkinSprite(offX, offY, Paths.image('modNotes/Eteled/$skin'));
        spr.addAnim('idle', '${colors[rdmStrum]} alone', 0, false);
        spr.playAnim('idle', true);
        spr.antialiasing = Options.antialiasing;
        spr.scale.set(0.7, 0.7);
        spr.updateHitbox();
        glitchedNotes.add(spr);
    }
}

public function addGlitchedBGs() {
    usingGlitchedBGs = true;
    glitchedCam.camera = camHUD;
    addSprite(bgsGlitched);
    insert(1, glitchedCam);
    
    var sheets:Array<String> = ['glitchAnim', 'noise2', 'noise2R', 'sheet'];
    for (sprite in sheets) {
        var spr:FunkinSprite = new FunkinSprite().loadSprite(getModImage('effects/$sprite'));
        spr.addAnim('play', switch(sprite) {
            case 'glitchAnim': 'g';
            case 'noise2' | 'noise2R': 'f';
            case 'sheet': 'Idle';
        }, 24, true);
        spr.antialiasing = Options.antialiasing;
        spr.scale.set(8, 8);
        spr.updateHitbox();
        spr.alpha = 0.001;

        glitchedCam.add(spr);
        bgsGlitched.add(spr);
    }
}

/*
  > NOTE: I honestly gave up trying to understand how
    Austin Glitched Notes works, it's too hard to read
    Kade Engine Source's tbh, so for anyone who wanna redo
    this Script or know how to recreate it, always welcome.

    So I made a scratchy randomizer that just recreates visually
    how the mechanic looks in the Mod, nothing big nor special,
    sorry if I failed you on this one.

    - Zanxt.
*/

public function cleanGlitchedBGS() {
    glitchedCam.clear();
    bgsGlitched.clear();
}