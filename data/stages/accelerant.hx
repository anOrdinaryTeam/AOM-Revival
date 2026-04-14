public var sanford:FunkinSprite;
public var deimos:FunkinSprite;
public var helicopter:FunkinSprite;

public var boombox:FunkinSprite;
public var gfArmsUp:Character = new Character(335, 275, 'gfArmsUp');
public var gfHotdog:FunkinSprite;

function BG(str:String) return getModImage('Accelerant/$str');
using StringTools;

function create() {
    defaultCamZoom = 0.7;

    var bg:FlxSprite = new FlxSprite().loadGraphic(BG('bg'));
    bg.antialiasing = Options.antialiasing;
    bg.scale.set(1.3, 1);
    bg.updateHitbox();
    bg.scrollFactor.set(0.1, 0.1);
    bg.screenCenter();
    bg.x += 200;
    bg.y -= 190;
    addSprite(bg);

    helicopter = new FunkinSprite(-1500, -160).loadSprite(BG('helicopter'));
    helicopter.scale.set(1.1, 1.1);
    helicopter.updateHitbox();
    helicopter.addAnim('play', 'Helicopter', 24, true);
    helicopter.playAnim('play');
    helicopter.color = 0x847F7F;
    addSprite(helicopter);

    var cliffs:FlxSprite = new FlxSprite().loadGraphic(BG('cliffs'));
    cliffs.antialiasing = Options.antialiasing;
    cliffs.scrollFactor.set(0.8, 0.8);
    cliffs.scale.set(1.5, 1.4);
    cliffs.updateHitbox();
    cliffs.screenCenter();
    cliffs.x -= 120;
    cliffs.y += 80;
    addSprite(cliffs);

    sanford = new FunkinSprite(1100, -230).loadSprite(BG('sanford'));
    sanford.antialiasing = Options.antialiasing;
    sanford.scrollFactor.set(0.8, 0.8);
    sanford.scale.set(1.1, 1.1);
    sanford.updateHitbox();
    sanford.addAnim('entering', 'EnteringAnimSanford', 24, false);
    sanford.addAnim('idle', 'SanfordIdle', 24, false);
    sanford.addAnim('shoot', 'SanfordShoot', 24, false);
    sanford.addOffset('entering', 10, 365);
    sanford.animation.callback = (Anim) -> {
        if (Anim == 'entering') sanford.flipX = true;
    }
    sanford.animation.finishCallback = (Anim) -> {
        if (Anim == 'entering') {
            sanford.flipX = false;
            sanford.playAnim('idle');
        }
    }
    sanford.playAnim('idle');
    sanford.color = 0x847F7F;
    addSprite(sanford);

    deimos = new FunkinSprite(-580, -200).loadSprite(BG('deimos'));
    deimos.antialiasing = Options.antialiasing;
    deimos.scrollFactor.set(0.8, 0.8);
    deimos.scale.set(1.1, 1.1);
    deimos.updateHitbox();
    deimos.addAnim('entering', 'EnteringAnimDeimos', 24, false);
    deimos.addAnim('idle', 'DeimosIdle', 24, false);
    deimos.addAnim('shoot', 'DeimosShoot', 24, false);
    deimos.addOffset('entering', 70, 335);
    deimos.animation.finishCallback = (Anim) -> {
        if (Anim == 'entering') {
            deimos.playAnim('idle');

            gf.alpha = 0;
            gfArmsUp.alpha = boombox.alpha = 1;
            gfArmsUp.playAnim('upArms', true);
            gfArmsUp.animation.finishCallback = (Anim) -> {
                if (Anim == 'upArms') {
                    gfArmsUp.dance();
                    gfArmsUp.danceOnBeat = true;
                }
            }
        }
    }
    deimos.playAnim('idle');
    deimos.color = 0x847F7F;
    addSprite(deimos);

    var floor:FlxSprite = new FlxSprite().loadGraphic(BG('floor'));
    floor.antialiasing = Options.antialiasing;
    floor.scale.set(1.5, 1.4);
    floor.updateHitbox();
    floor.screenCenter();
    floor.y += 370;
    addSprite(floor);

    boombox = new FunkinSprite(185, 265).loadSprite(BG('stereo'));
    boombox.antialiasing = Options.antialiasing;
    boombox.addAnim('boom', 'stereo boom', 24, false);
    boombox.alpha = 0.001;
    addSprite(boombox);

    gfArmsUp.danceOnBeat = false;
    gfArmsUp.alpha = 0.001;
    gfArmsUp.antialiasing = Options.antialiasing;
    addSprite(gfArmsUp);

    var foreground:FlxSprite = new FlxSprite().loadGraphic(BG('foreground'));
    foreground.antialiasing = Options.antialiasing;
    foreground.scrollFactor.set(1.2, 1.2);
    foreground.scale.set(1.15, 1.2);
    foreground.updateHitbox();
    foreground.screenCenter();
    foreground.x -= 100;
    foreground.y += 350;
    add(foreground);

    sanford.alpha = deimos.alpha = 0.001;
}

function postCreate()
    loadHud('VS-Online');

var danceLeft:Bool = true;
function beatHit() {
    boombox.playAnim('boom');

    if (sanford.animation.curAnim.name == 'idle')
        sanford.playAnim('idle');

    if (deimos.animation.curAnim.name == 'idle')
        deimos.playAnim('idle');
}