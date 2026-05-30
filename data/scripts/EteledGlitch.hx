// made by myself because i didnt understand Eteled Code
import funkin.game.Note;
using StringTools;

var austinGlitch:Character;

var glitchedStrumCpu:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var glitchedStrumPlayer:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var glitchedNotes:FlxTypedGroup<Note> = new FlxTypedGroup();

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

    for (notes in glitchedNotes)
        notes.alpha = val ? 1 : 0.001;

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

function onNoteCreation(e) {
    if (e.strumLineID == 0) return;

    var curNote:Note = e.note;
    glitchedNotes.add(curNote);
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

function update() if (useGlitchedNotes) {
    player.notes.forEachAlive(daNote -> {
        glitchedNotes.members[player.notes.members.indexOf(daNote)].x = daNote.x;
	    glitchedNotes.members[player.notes.members.indexOf(daNote)].y = daNote.y;
    });
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

public function cleanGlitchedBGS() {
    glitchedCam.clear();
    bgsGlitched.clear();
}