// made by myself because i didnt understand Eteled Code
using StringTools;

var glitchedStrumCpu:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var glitchedStrumPlayer:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var glitchedNotes:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();

var austinGlitch:Character;

var visibleGlitch(default, set):Bool = false;
function set_visibleGlitch(val:Bool) {
    var randomGroup:Int = FlxG.random.int(0, 2);

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

    return val;
}

function postCreate() if (!getSaveData('allowCustomHud'))
    addStuff();
function postHudLoad() if (getSaveData('allowCustomHud'))
    addStuff();

function stepHit() {
    var glitchChance:Int = FlxG.random.int(0, 13);

    if (glitchChance == 7) {
        visibleGlitch = true;
        new FlxTimer().start(FlxG.random.float(0.1, 0.5), () -> visibleGlitch = false);   
    }
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
    var skin:String = player ? (name == 'bf-mii' ? 'bfGlitch' : 'austinGlitch') : (name.contains('eteled') ? 'eteled' : 'austinGlitch');
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

function addStuff() {
    insert(members.indexOf(strumLines), glitchedStrumCpu);
    insert(members.indexOf(strumLines), glitchedStrumPlayer);

    generateStrum(true);
    generateStrum(false);

    if (dad.curCharacter == 'austin' || boyfriend.curCharacter == 'austin-playable') {
        var playerVersion:Bool = boyfriend.curCharacter.contains('-playable');
        var getter:Character = playerVersion ? boyfriend : dad;
        var str:String = playerVersion ? 'austin-glitch-playable' : 'austin-glitch';

        austinGlitch = new Character(getter.x, getter.y, str, playerVersion);
        austinGlitch.antialiasing = Options.antialiasing;
        austinGlitch.alpha = 0.001;
        insert(members.indexOf(dad), austinGlitch);
    }
}