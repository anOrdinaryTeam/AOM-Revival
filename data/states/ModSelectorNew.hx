class Background extends FlxSprite
{
    public var contrastBG:Bool = false;
    public function new(image:String, contrast:Bool) {
        super();
        this.contrastBG = contrast;
        loadGraphic(image);
    }
}

class Logo extends FlxSprite
{
    public var ogPos:Array = [0, 0];
    public function new(image:String, pos:Array) {
        super(pos[0], pos[1]);
        loadGraphic(image);
        this.ogPos = pos.copy();        
    }
}

var allowInput:Bool = true;
var curSelected:Int = lastModSelected;

var contrastGraphic:FlxSprite;
var modsAlphabet:FlxTypedGroup<Alphabet> = new FlxTypedGroup();
var backgroundsGrp:FlxTypedGroup<Background> = new FlxTypedGroup();
var logosGrp:FlxTypedGroup<Logo> = new FlxTypedGroup();

function create() {
    CoolUtil.playMenuSong();
    changeToDefaultRPC('In The Mod Selector');
    add(backgroundsGrp);

    contrastGraphic = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
    contrastGraphic.alpha = 0.01;
    add(contrastGraphic);

    var bgItems:FlxSprite = new FlxSprite().loadGraphic(getImage('Menu/ui'));
    bgItems.antialiasing = true;
    bgItems.scale.x += 1;
    bgItems.scale.y += 0.7;
    bgItems.x -= 100;
    bgItems.updateHitbox();
    bgItems.screenCenter(FlxAxes.Y);
    add(bgItems);

    add(modsAlphabet);
    add(logosGrp);

    for (i => ModName in currentModsList) {
        var title:Alphabet = new Alphabet(50, 0, ModName, "bold");
        title.antialiasing = Options.antialiasing;
        title.alpha = 0.5;
        modsAlphabet.add(title);
    }

    for (i => str in currentModsList) try {
        var modPath:String = 'Assets-$str/images/menu';

        if (findFile('$modPath/data.json')) {
            var rawJson:Dynamic = CoolUtil.parseJson(Paths.getPath('$modPath/data.json'));

            if (rawJson != null) {
                var chooseData:Int = FlxG.random.int(0, rawJson.backgrounds.length - 1);

                var chooseBG:Array<Dynamic> = rawJson.backgrounds[chooseData];
                var bgStr:String = chooseBG[0];
                var contrastBool:Bool = chooseBG[1];

                var bg:Background = new Background(Paths.getPath('$modPath/$bgStr.png'), contrastBool);
                bg.setGraphicSize(FlxG.width, FlxG.height);
                bg.updateHitbox();
                bg.screenCenter();
                bg.antialiasing = Options.antialiasing;
                backgroundsGrp.add(bg);

                var logoStr:String = rawJson.logo;
                var chooseLogoData:Array<Dynamic> = rawJson.logoData[chooseData];
                var logoPos:Array<Float> = [chooseLogoData[0], chooseLogoData[1]];
                var logoScale:Float = chooseLogoData[2];

                var logo:Logo = new Logo(Paths.getPath('$modPath/$logoStr.png'), logoPos);
                logo.scale.set(logoScale, logoScale);
                logo.updateHitbox();
                logo.ID = i;
                logo.alpha = 0.001;
                logo.antialiasing = Options.antialiasing;
                logosGrp.add(logo);
            }
        }
        else {
            var defLogoPos:Array<Float> = [1000, 400]; 
            var defLogoScale:Float = 0.45;

            var logo:Logo = new Logo(Paths.image('missing-icon'), defLogoPos);
            logo.scale.set(defLogoScale, defLogoScale);
            logo.updateHitbox();
            logo.ID = i;
            logo.alpha = 0.001;
            logo.antialiasing = Options.antialiasing;
            logosGrp.add(logo);

            var bg:Background = new Background(Paths.image('missing-bg'), false);
            bg.setGraphicSize(FlxG.width, FlxG.height);
            bg.updateHitbox();
            bg.screenCenter();
            bg.antialiasing = Options.antialiasing;
            backgroundsGrp.add(bg);
        }
    }
    catch(e:String)
        trace(e.toString());

    var info:FunkinText = new FunkinText(0, 15, 0, '[Select The Mod To Play]', 25);
    info.x = (FlxG.width - info.width) - 5;
    add(info);

    scroll(0, true);
    currentMod = 'NONE';
    
	#if ARKOSE_PORT
	addMobilePad("UP_DOWN", "A_B");
	#end
}

function update(dt) {
    if (FlxG.sound.music.volume < 0.8)
		FlxG.sound.music.volume += 0.5 * dt;

    if (allowInput) {
        scroll((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);

        if (controls.ACCEPT)
            select();
        
        if (controls.BACK) {
            allowInput = false;
            FlxG.switchState(new ModState('Menu'));
        }

        for (k => option in modsAlphabet.members) {
            var spaceBetween:Float = 130;
            var y:Float = ((FlxG.height - spaceBetween) / 2) + ((k - curSelected) * spaceBetween);
            option.y = CoolUtil.fpsLerp(option.y, y, 0.25);
        }
    }
}

function scroll(i:Int = 0, f:Bool = false) {
    if (i == 0 && !f) return;
    CoolUtil.playMenuSFX(0, 0.5);

    // old
    var curLogo:Logo = logosGrp.members[curSelected];
    FlxTween.tween(curLogo, {alpha: 0, y: i == 1 ? curLogo.y + 100 : curLogo.y - 100}, 0.2, {ease: FlxEase.quadInOut});
    modsAlphabet.members[curSelected].alpha = 0.5;

    curSelected = FlxMath.wrap(curSelected + i, 0, currentModsList.length-1);
    lastModSelected = curSelected;

    // new
    var curLogo:Logo = logosGrp.members[curSelected];
    FlxTween.tween(curLogo, {y: curLogo.ogPos[1], alpha: 1}, 0.2, {ease: FlxEase.quadInOut});
    modsAlphabet.members[curSelected].alpha = 1;

    changeBackground();
}

function TweenLogo(i:Int) {
    var curLogo:Logo = logosGrp.members[curSelected];
    FlxTween.tween(curLogo, {alpha: 0, y: i == 1 ? curLogo.y + 100 : curLogo.y - 100}, 0.2, {ease: FlxEase.quadInOut});
}

function changeBackground() {
    FlxTween.cancelTweensOf(contrastGraphic);
    FlxTween.tween(contrastGraphic, {alpha: 1}, 0.1, {ease: FlxEase.quadInOut, onComplete: () -> {
        var doContrast:Bool = backgroundsGrp.members[curSelected].contrastBG;

        for (all in backgroundsGrp) all.alpha = 0.001;
        backgroundsGrp.members[curSelected].alpha = 1;
        FlxTween.tween(contrastGraphic, {alpha: doContrast ? 0.5 : 0}, 0.1, {ease: FlxEase.quadInOut});
    }});
}

function select() {
    allowInput = false;
    currentMod = currentModsList[curSelected];
    trace(currentMod);
    FlxG.switchState(new ModState('NewFreeplay'));
}

static function findFile(str:String)
    return Assets.exists(Paths.getPath(str));