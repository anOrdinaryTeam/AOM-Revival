import flixel.effects.FlxFlicker;
import flixel.addons.display.FlxBackdrop;

var acceptInputs:Bool = true;
var enterText:Alphabet;

var logo:FlxSprite;

function create() {
    FlxG.camera.flash(0xFF000000, .3);
    persistentUpdate = persistentDraw = true;
    CoolUtil.playMenuSong();

    final bg:FlxBackdrop = new FlxBackdrop(getImage('Menu/${FlxG.random.int(0, 4)}'), FlxAxes.XY, -1);
    bg.antialiasing = true;
    bg.velocity.set(40, 40);
    add(bg);

    logo = new FlxSprite(0, 100).loadGraphic(getImage('Menu/logo'));
    logo.antialiasing = true;
    logo.screenCenter(FlxAxes.X);
    logo.scale.set(0.95, 0.95);
    logo.updateHitbox();
    add(logo);

    enterText = new Alphabet(0, 550, 'Press ENTER to continue', 'bold');
    enterText.antialiasing = Options.antialiasing;
    enterText.screenCenter(FlxAxes.X);
    enterText.scale.set(.65, .65);
    add(enterText);
}

function update() {
    var logoScale:Float = lerp(logo.scale.x, 0.95, 0.1);
    logo.scale.set(logoScale, logoScale);

    if (FlxG.keys.justPressed.ENTER && !FlxG.keys.justPressed.ESCAPE)
        moveMainMenu();
}

function beatHit() {
    logo.scale.set(0.98, 0.98);
}

function moveMainMenu() {
    if (!acceptInputs) return;
    acceptInputs = false;

    FlxFlicker.flicker(enterText, 1);
    FlxG.sound.play(Paths.sound('menu/confirm'));

    new FlxTimer().start(1, () -> FlxG.switchState(new MainMenuState()));
}