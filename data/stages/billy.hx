import hxvlc.flixel.FlxVideoSprite;
import flixel.text.FlxTextBorderStyle;

var index:Int = 0;
var defaultZoom:Float = 0.725;

var bars:FlxSprite;
public var mirror:FlxSprite;
public var MyWay:FlxVideoSprite;

defaultCamZoom = defaultZoom;
introLength = 0;

public function BillyPath(str:String)
    return getModImage('Silly Billy/$str');

function BillyVideo(str:String)
    return Paths.video(str);

function create() {
    useCamMov = true;
    camMoveAmt = 20;
    for (precache in ['transLookalike', 'bf-lookalike', 'transLookalike2'])
        precacheCharacter(0, precache);

    var preloadVideo:FlxVideoSprite = new FlxVideoSprite(0,0);
    preloadVideo.load(BillyVideo('open'));
    preloadVideo.bitmap.onEndReached.add(preloadVideo.destroy);
    preloadVideo.camera = camHUD;
    preloadVideo.antialiasing = false;
    preloadVideo.play();
    add(preloadVideo);
    preloadVideo.stop();

    var preloadVideo:FlxVideoSprite = new FlxVideoSprite(0,0);
    preloadVideo.load(BillyVideo('SO_STAY_FINAL'));
    preloadVideo.bitmap.onEndReached.add(preloadVideo.destroy);
    preloadVideo.camera = camHUD;
    preloadVideo.antialiasing = false;
    preloadVideo.play();
    add(preloadVideo);
    preloadVideo.stop();

    graphicCache.cache(BillyPath('broken_mirror'));
    mirror = new FlxSprite().loadGraphic(BillyPath('silly_mirror'));
    mirror.antialiasing = Options.antialiasing;
    insert(1, mirror);

    var sprites:FunkinSprite = new FunkinSprite(0,0,BillyPath('bgAssets'));
    sprites.addAnim('idle', 'Silly_floor', 0, false);
    sprites.playAnim('idle');
    sprites.antialiasing = Options.antialiasing;
    insert(2, sprites);

    var sprites:FunkinSprite = new FunkinSprite(0,0,BillyPath('bgAssets'));
    sprites.addAnim('idle', 'Silly_idk_1', 0, false);
    sprites.playAnim('idle');
    sprites.antialiasing = Options.antialiasing;
    insert(3, sprites);

    var sprites:FunkinSprite = new FunkinSprite(0,0,BillyPath('bgAssets'));
    sprites.addAnim('idle', 'Silly_idk_2', 0, false);
    sprites.playAnim('idle');
    sprites.antialiasing = Options.antialiasing;
    insert(4, sprites);

    remove(strumLines, false);
    insert(3, strumLines);
}

var video:FlxVideoSprite;
public var black:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
public var IllMake:FunkinSprite;
public var lyrics:FlxText;

function postCreate() {
    remove(gf);
    importScript('songs/Silly Billy/healthbar');

    IllMake = new FunkinSprite(1600, 1130, BillyPath('lyrics'));
    IllMake.addAnim('play', 'story_of_yourtalebilly', 24, false);
    IllMake.antialiasing = Options.antialiasing;
    IllMake.alpha = 0.001;
    add(IllMake);

    var vig = new FlxSprite().loadGraphic(BillyPath('hud/vignette'));
    vig.camera = camHUD;
    insert(1, vig);

    black.camera = camHUD;
    black.alpha = 0.01;
    add(black);

    video = new FlxVideoSprite(212, 121);
    video.load(BillyVideo('open'));
    video.bitmap.onEndReached.add(video.destroy);
    video.camera = camHUD;
    video.antialiasing = true;
    video.scale.set(1.5, 1.5);
    video.alpha = 0.001;
    video.updateHitbox();
    add(video);

    MyWay = new FlxVideoSprite();
    MyWay.load(BillyVideo('SO_STAY_FINAL'));
    MyWay.bitmap.onEndReached.add(MyWay.destroy);
    MyWay.camera = camHUD;
    MyWay.antialiasing = true;
    MyWay.alpha = 0.0001;
    insert(2, MyWay);

    for (i in [healthBar, healthBarBG, iconP1, iconP2]) i.visible = false;
    bars = new FlxSprite().loadGraphic(BillyPath('hud/bars'));
    bars.camera = camHUD;
    bars.antialiasing = Options.antialiasing;
    insert(3, bars);

    lyrics = new FlxText();
    lyrics.setFormat(Paths.font("Times New Roman.ttf"), 48, 0xFFcfa92d, 'center', FlxTextBorderStyle.OUTLINE, 0xFF000000);
    lyrics.borderSize = 2;
    lyrics.camera = camHUD;
    lyrics.screenCenter(FlxAxes.X);
    lyrics.text = '';
    insert(4, lyrics);

    for (i in 0...cpu.members.length) {
        var strum = cpu.members[i];
        strum.scrollFactor.set(1, 1);
        strum.scale.set(1, 1);
        strum.updateHitbox();
        strum.setPosition(760 + (i * 225), downscroll ? 1150 : 400);
        strum.alpha = 0.3;
    }

    // camGame.visible = false;
}

function onSongStart() video.play();
function onStrumCreation(_) _.cancelAnimation();

function onPostStrumCreation(_) if (_.player == 0 && downscroll) {
    _.strum.camera = camGame;
    _.strum.angle = 180;
    _.strum.flipX = _.strum.flipY = true;
    _.strum.extraCopyFields.push("flipX");
    _.strum.extraCopyFields.push("flipY");
}

function onPostNoteCreation(_) if (_.strumLineID == 0) {
    _.note.updateFlipY = false;
    _.note.scale.set(1, 1);
    _.note.updateHitbox();
    _.note.alpha = 0.3;
}

function onFocus() if (paused) {
    if (video != null) video.pause();
    if (MyWay != null) MyWay.pause();
}
else {
    if (video != null) video.resume();
    if (MyWay != null) MyWay.resume();
}

function onGamePause() {
    paused = true;
    persistentUpdate = false;
    persistentDraw = true;
    if (video != null) video.pause();
    if (MyWay != null) MyWay.pause();
}

function update() if (!paused) {
    if (MyWay != null) MyWay.resume();
    if (video != null) video.resume();
}