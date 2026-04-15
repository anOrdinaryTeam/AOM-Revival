import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;

final pixelate:Bool = Options.antialiasing;
final getOptions:Dynamic = CoolUtil.parseJson(Paths.json('config/menuItems'));

var menuItemsGroup:FlxTypedGroup<Alphabet> = new FlxTypedGroup();
var bgFlasher:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, -1);
var logo:FlxSprite;

public var input:Bool = true;
public var danceOnBeat:Bool = true;
public var charactersMenu:FlxTypedGroup<Character> = new FlxTypedGroup();

// TESTING
var charMenu:String = 'rushSonic';

function create() {
    FlxG.mouse.visible = true;
    CoolUtil.playMenuSong();
    changeToDefaultRPC('In The Main Menu');

    final bg:FlxBackdrop = new FlxBackdrop(getImage('Menu/${FlxG.random.int(0, 4)}'), FlxAxes.XY, -1);
    bg.antialiasing = pixelate;
    bg.velocity.set(40, 40);
    add(bg);

    final bgItems:FlxSprite = new FlxSprite().loadGraphic(getImage('Menu/ui'));
    bgItems.antialiasing = true;
    bgItems.alpha = 0.8;
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
    }

    loadCharacterMenu();

    logo = new FlxSprite().loadGraphic(getImage('Menu/logo'));
    logo.antialiasing = pixelate;
    logo.scale.set(0.95, 0.95);
    logo.updateHitbox();
    logo.x -= 20; logo.y += 20;
    add(logo);

    final str:String = 'Author: ${Flags.MOD_AUTHOR}\nAnOrdinaryModpack: ${Flags.customFlags.get('MODPACK_VERSION')}';
    final verTxt:FunkinText = new FunkinText(5, 0, 0, str, 20);
    verTxt.y = (FlxG.height - verTxt.height) - 5;
    verTxt.antialiasing = true;
    add(verTxt);

    bgFlasher.alpha = 0.001;
    add(bgFlasher);

    // since Optionsmenu doesnt have callbacks events, I dont have other choice
    RefreshSaveDatas();
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

var SONG_TEST:String = 'Foolhardy';
var SONG_TEST_DIFF:String = 'hard';

function update(dt) {
    var logoScale:Float = lerp(logo.scale.x, 0.95, 0.1);
    logo.scale.set(logoScale, logoScale);

    if (FlxG.sound.music.volume < 0.8)
		FlxG.sound.music.volume += 0.5 * dt;

    if (input) {
        if (FlxG.keys.justPressed.T) {
            input = false;
            PlayState.loadSong(SONG_TEST, SONG_TEST_DIFF);
            FlxG.switchState(new PlayState());
        }

        if (controls.DEV_ACCESS) {
            persistentUpdate = false;
            persistentDraw = true;
            openSubState(new EditorPicker());
        }

        if (controls.SWITCHMOD) {
			openSubState(new ModSwitchMenu());
			persistentUpdate = false;
			persistentDraw = true;
		}

        if (FlxG.keys.justPressed.T) {
            input = false;
            FlxG.switchState(new ModState('testing'));
        }

        for (i => txt in menuItemsGroup.members) {
            var lerping:Float = lerp(txt.scale.x, FlxG.mouse.overlaps(txt, FlxG.camera) ? getOptions.options[i].size + 0.075 : getOptions.options[i].size, 0.3);
            txt.scale.set(lerping, lerping);

            if (FlxG.mouse.overlaps(txt, FlxG.camera) && FlxG.mouse.justPressed)
                onSelectedOption(txt.ID);
        }
    }
}

function beatHit() {
    logo.scale.set(0.98, 0.98);

    if (danceOnBeat)
        for (char in charactersMenu)
            char.dance();
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

                if (Json.stateType == 'SourceState') {
                    final ClassToRedirect:Dynamic = Type.resolveClass(Json.stateRedirect);
                    FlxG.switchState(new ClassToRedirect());
                }
                else
                    FlxG.switchState(new ModState(Json.stateRedirect));
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