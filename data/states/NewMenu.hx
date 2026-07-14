import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;
import funkin.editors.ui.UIState;
import funkin.backend.system.macros.GitCommitMacro;
import funkin.backend.system.Flags;

final pixelate:Bool = Options.antialiasing;
final getOptions:Dynamic = CoolUtil.parseJson(Paths.json('config/menuItems'));

var enterText:Alphabet;
var menuItemsGroup:FlxTypedGroup<Alphabet> = new FlxTypedGroup();
var bgFlasher:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, -1);
var logo:FlxSprite;

public var input:Bool = true;
public var danceOnBeat:Bool = true;
public var charactersMenu:FlxTypedGroup<Character> = new FlxTypedGroup();

// TESTING
var charMenu:String = '';

static var startmenu:Bool = false;

function create() {
    FlxG.camera.flash(0xFF000000, .3);

    FlxG.mouse.visible = true;
    CoolUtil.playMenuSong();
    changeToDefaultRPC('In The Main Menu');

    final bg:FlxBackdrop = new FlxBackdrop(getImage('Menu/${FlxG.random.int(0, 4)}'), FlxAxes.XY, -1);
    bg.antialiasing = pixelate;
    bg.velocity.set(40, 40);
    add(bg);

    final bgItems:FlxSprite = new FlxSprite().loadGraphic(getImage('Menu/ui'));
    bgItems.antialiasing = true;
    bgItems.alpha = .001;
    bgItems.scale.x += 0.3;
    bgItems.updateHitbox();
    add(bgItems);

    add(menuItemsGroup);
    for (i => JsonData in getOptions.options) {
        final XY:Array<Float> = JsonData.position.copy();
        final text:String = JsonData.text;
        final size:Float = JsonData.size;

        var text:Alphabet = new Alphabet(XY[0], XY[1], text, 'bold');
        text.antialiasing = pixelate;
        text.scrollFactor.set();
        text.scale.set(size, size);
        text.updateHitbox();
        text.ID = i;
        menuItemsGroup.add(text);

        text.x = (!startmenu ? XY[0] - 800 : XY[0]);
    }

    loadCharacterMenu();

    for (i in charactersMenu)
        if (!startmenu)
            i.x += 800;

    logo = new FlxSprite(305, 100).loadGraphic(getImage('Menu/logo'));
    logo.antialiasing = pixelate;
    logo.scale.set(0.95, 0.95);
    logo.updateHitbox();
    add(logo);

    logo.x = (!startmenu ? 305 : 20);
    logo.y = (!startmenu ? 100 : 20);

    if (!startmenu) {
        enterText = new Alphabet(0, 550, 'Press ENTER to continue', 'bold');
        enterText.antialiasing = Options.antialiasing;
        enterText.screenCenter(FlxAxes.X);
        enterText.scale.set(.65, .65);
        add(enterText);

        var path:String = 'Mods/Mid-Fight Masses/images/church3';
        if (Assets.exists(Paths.file('$path/pillarbroke.png'))) {
            pillar.x += 800;
            ruv.x += 800;
        }
    }
}

function loadCharacterMenu() {
    try {
        var content:Array<String> = Paths.getFolderDirectories('data/menuChars');
        var File:String = charMenu != '' ? charMenu : content[FlxG.random.int(0, content.length - 1)];
            
        var DataJson:Dynamic = CoolUtil.parseJson(Paths.json('menuChars/$File/data'));
        for (Json in DataJson.list) {
            var name:String = Json.char ?? 'bf';
            var pos:Array<Float> = Json.position.copy();
            var scale:Float = Json.scale ?? 1;
            var flip:Bool = Json.flipped ?? false;

            var char:Character = new Character(pos[0], pos[1], name);
            char.flipX = flip;
            char.scale.set(scale, scale);
            char.updateHitbox();
			// ENABLE THIS AFTER FIXING MENU CHAR POSSES
            //char.extraOffset.set(-char.offset.x, -char.offset.y);
            //char.dance();
            //var vx:Float = char.offset.x + char.frameOffset.x * char.scale.x;
            //var vy:Float = char.offset.y + char.frameOffset.y * char.scale.y;
            //char.x -= vx;
            //char.y -= vy;
            //char.extraOffset.x += vx;
            //char.extraOffset.y += vy;
            charactersMenu.add(char);
        }
        add(charactersMenu);
        trace('Character Menu choosed: $File');

        if (Assets.exists(Paths.script('data/menuChars/$File/script'))) {
            importScript('data/menuChars/$File/script');
            stateScripts.call('onCharsLoaded');
            trace('added menuchar script');
        }
    }
    catch(e:String)
        trace(e.toString());
}

function update(dt:Float) {
    var logoScale:Float = lerp(logo.scale.x, 0.95, 0.1);
    logo.scale.set(logoScale, logoScale);

    if (FlxG.sound.music.volume < 0.8)
		FlxG.sound.music.volume += 0.5 * dt;

    if (!startmenu && FlxG.keys.justPressed.ENTER && !FlxG.keys.justPressed.ESCAPE)
        moveMainMenu();

    if (input) {
        if (FlxG.keys.justPressed.T) {
            input = false;
            PlayState.loadSong(SONG_TEST, SONG_TEST_DIFF);
            FlxG.switchState(new PlayState());
        }

        if (controls.DEV_ACCESS #if ARKOSE_PORT || mobilePadJustPressed('E') #end) {
            persistentUpdate = false;
            persistentDraw = true;
            openSubState(new EditorPicker());
        }

        if (controls.SWITCHMOD #if ARKOSE_PORT || mobilePadJustPressed('M') #end) {
			openSubState(new ModSwitchMenu());
			persistentUpdate = false;
			persistentDraw = true;
		}

        if (FlxG.keys.justPressed.T) {
            input = false;
            FlxG.switchState(new ModState('testing'));
        }
    }

    for (i => txt in menuItemsGroup.members) {
        var lerping:Float = lerp(txt.scale.x, FlxG.mouse.overlaps(txt, FlxG.camera) ? getOptions.options[i].size + 0.075 : getOptions.options[i].size, 0.3);
        txt.scale.set(lerping, lerping);

        if (FlxG.mouse.overlaps(txt, FlxG.camera) && FlxG.mouse.justPressed)
            onSelectedOption(txt.ID);
    }
}

function beatHit() {
    logo.scale.set(0.98, 0.98);

    if (danceOnBeat)
        for (char in charactersMenu)
            char.dance();
}

function moveMainMenu() {
    startmenu = true;

    FlxFlicker.flicker(enterText, 1);
    FlxTween.tween(enterText, {alpha: 0}, 1.5, {onComplete: () -> remove(enterText, true)});
    FlxG.sound.play(Paths.sound('menu/confirm'));

    FlxTween.tween(logo, {x: 20, y: 20}, 2.5, {startDelay: 1, ease: FlxEase.expoOut});

    for (i in charactersMenu)
        FlxTween.tween(i, {x: i.x - 800}, 1.5, {startDelay: 1.5, ease: FlxEase.elasticInOut});

    menuItemsGroup.forEach(function(spr) {
        var delay:Float = 0.1 * spr.ID;
        FlxTween.tween(spr, {x: spr.x + 800}, 2.5, {startDelay: delay, ease: FlxEase.elasticInOut});
        FlxTween.tween(spr, {alpha: 1}, 2.5, {startDelay: delay, ease: FlxEase.BackInOut});
    });

    var path:String = 'Mods/Mid-Fight Masses/images/church3';
    if (Assets.exists(Paths.file('$path/pillarbroke.png'))) {
        for (i in [pillar, ruv])
            FlxTween.tween(i, {x: i.x - 800}, 1.5, {startDelay: 1.5, ease: FlxEase.elasticInOut});
    }
}

function onSelectedOption(option:Int) {
    input = false;

    CoolUtil.playMenuSFX(1, 0.7);
    if (Options.flashingMenu) {
        bgFlasher.alpha = 0.8;
        FlxTween.tween(bgFlasher, {alpha: 0}, 0.7);
    }

    menuItemsGroup.forEach(function(spr) {
        if (spr.ID == option) {
            FlxTween.tween(spr, {x: spr.x + 70}, 0.6, {ease: FlxEase.elasticInOut});
            FlxFlicker.flicker(spr, 1.1, Options.flashingMenu ? 0.06 : 0.15, false, false, function(flick:FlxFlicker) {
                final Json:Dynamic = getOptions.options[option]; // not a damn switcher baby!!!

                switch(Json.stateType) {
                    default: FlxG.switchState(new ModState(Json.stateRedirect));
                    case 'UIState': FlxG.switchState(new UIState(true, Json.stateRedirect));
                    case 'SourceState':
                        final ClassToRedirect:Dynamic = Type.resolveClass(Json.stateRedirect);
                        FlxG.switchState(new ClassToRedirect());
                }
            });
        }
        else {
            var delay:Float = 0.1 * spr.ID;
            var time:Float = 0.5;

            FlxTween.tween(spr, {x: spr.x - 400, alpha: 0}, time, {startDelay: delay, ease: FlxEase.quadInOut});
            FlxTween.tween(spr, {alpha: 0}, time, {startDelay: delay, ease: FlxEase.BackInOut});
        }
    });
}