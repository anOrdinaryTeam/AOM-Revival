public var stageBroken:Array<Dynamic> = [];
public var bg:FlxSprite;
public var scrapJumpscare:FunkinSprite;

public var blackGame:FlxSprite;
public var blackHud:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);

defaultCamZoom = 0.78;

function preStageLoad()
    useStageData = false;

function addBg(spr:FlxSprite, add:Bool = true) if (spr != null) {
    add ??= true;
    spr.antialiasing = Options.antialiasing;
    addSprite(spr);
    if (add) stageBroken.push(spr);
}

function create() {
    gf.setPosition(950, 740);
    dad.setPosition(320, 630);
    boyfriend.setPosition(1660, 710);

    var sky:FlxSprite = new FlxSprite(-400, 0, getModImage('Prison/sprite'));
    sky.setGraphicSize(Std.int(4096 * 1.1));
    sky.updateHitbox();
    sky.scrollFactor.set(1.1, 1.1);
    addBg(sky);

    var sanford:FunkinSprite = new FunkinSprite(1260, 330, getModImage('Prison/sanford'));
    sanford.addAnim('idle', 'sanford', 24, true);
    sanford.playAnim('idle');
    addBg(sanford);

    var deimos:FunkinSprite = new FunkinSprite(1370, 328, getModImage('Prison/deimos'));
    deimos.addAnim('idle', 'deimos', 24, true);
    deimos.playAnim('idle');
    addBg(deimos);

    var buildings:FlxSprite = new FlxSprite(850, 500, getModImage('Prison/apartamento_scaface'));
    addBg(buildings);

    var floatingWall:FunkinSprite = new FunkinSprite(150, 0, getModImage('Prison/fondo_pedazo'));
    floatingWall.addAnim('idle', 'trozo de coso instance', 24, true);
    floatingWall.playAnim('idle');
    floatingWall.scale.set(1.5, 1.5);
    floatingWall.updateHitbox();
    addBg(floatingWall);

    bg = new FlxSprite(-600, -300, getModImage('Prison/background'));
    bg.scale.set(1.2, 1.5);
    bg.updateHitbox();
    addBg(bg, false);

    graphicCache.cache(getModImage('Prison/fondo_scaface'));
    for (hide in stageBroken) hide.alpha = 0.001;
}

function postCreate() {
    if (boyfriend.curCharacter == 'pico')
        boyfriend.cameraOffset.x -= 155;

    blackGame = new FlxSprite(bg.x, bg.y).makeSolid(bg.width, bg.height, FlxColor.BLACK);
    blackGame.scrollFactor.set();
    blackGame.alpha = 0.001;
    add(blackGame);

    blackHud.alpha = blackGame.alpha;
    blackHud.scrollFactor.set();
    blackHud.camera = camHUD;
    add(blackHud);

    scrapJumpscare = new FunkinSprite(-300, downscroll ? -470 : -160, getModImage('scrap_js'));
    scrapJumpscare.addAnim('boo', 'escarface SUSto instance', 24, false);
    scrapJumpscare.antialiasing = Options.antialiasing;
    scrapJumpscare.animation.onFrameChange.add(() -> scrapJumpscare.alpha = 1);
    scrapJumpscare.animation.onFinish.add(() -> {
        scrapJumpscare.active = false;
        remove(scrapJumpscare, true);
    });
    scrapJumpscare.alpha = 0.001;
    scrapJumpscare.camera = camHUD;
    add(scrapJumpscare);
}

function onDadHit(e) {
    if (e.character.curCharacter == boyfriend.curCharacter) return;
    camGame.shake(0.02, 0.1, null, true, 0x01);
}