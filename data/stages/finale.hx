import flixel.addons.display.FlxBackdrop;

static function finalePath(str:String)
    return getModImage('finale/$str');

function create() {
    importScript('data/scripts/pixelate');
    enablePixelUI = false;
    defaultCamZoom = 1.05;
    gf.visible = false;

    var space = new FlxBackdrop(finalePath('FinaleBG_1'));
    space.scrollFactor.set(0, 0);
    space.velocity.x = -10;
    addSprite(space);

    var stageback = new FlxSprite(-290, -100, finalePath('FinaleBG_2'));
    stageback.scrollFactor.set(0.4, 0.6);
    stageback.setGraphicSize(Std.int(stageback.width * 1.9));
    stageback.updateHitbox();
    addSprite(stageback);

    var stagefront = new FlxSprite(-194, -32, finalePath('FinaleFG'));
    stagefront.scrollFactor.set(1, 1);
    stagefront.setGraphicSize(Std.int(stagefront.width * 1.4));
    stagefront.updateHitbox();
    addSprite(stagefront);
}

function postCreate() {
    loadHud('KadeEngine', '1.4.2');
}

function onCountdown(e) if (e.swagCounter != 4) {
    var a:String = ['intro3', 'intro2', 'intro1', 'introGo'][e.swagCounter];
    e.soundPath = 'monikaPixelCountdown/$a';
    e.antialiasing = false;
    e.scale = PlayState.daPixelZoom;

    switch(e.swagCounter) {
        case 1: e.spritePath = 'modCountdowns/MonikaPixel/ready-pixel';
        case 2: e.spritePath = 'modCountdowns/MonikaPixel/set-pixel';
        case 3: e.spritePath = 'modCountdowns/MonikaPixel/go-pixel';
    }
}

function onPlayerHit(event) {
    event.ratingPrefix = 'modCombos/MonikaPixel/';
    event.ratingScale = PlayState.daPixelZoom * 0.7;
    event.ratingAntialiasing = false;

    event.numScale = PlayState.daPixelZoom;
    event.numAntialiasing = false;
}