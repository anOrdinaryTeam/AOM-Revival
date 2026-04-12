import hxvlc.flixel.FlxVideoSprite;
import flixel.text.FlxTextBorderStyle;
import flixel.FlxCameraFollowStyle;
import modchart.Manager;

public var mirror:FlxSprite;
public var MyWay:FlxVideoSprite;

public var black:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
public var IllMake:FunkinSprite;
public var lyrics:FlxText;

var billyCam:FlxCamera = new FlxCamera();
var notesTime:Array<Float> = [];
var video:FlxVideoSprite;
var bars:FlxSprite;

defaultCamZoom = 0.725;
introLength = 0;

public function BillyPath(str:String)
    return getModImage('Silly Billy/$str');

function create() {
    FlxG.cameras.remove(camGame, false);
    FlxG.cameras.remove(camHUD, false);
    FlxG.cameras.insert(billyCam, 0);
    FlxG.cameras.insert(camGame, 1);
    FlxG.cameras.insert(camHUD, 2, false);

    camGame.bgColor = 0x0;
    billyCam.bgColor = 0x0;
    billyCam.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.04);

    comboGroup.visible = false;
    useCamMov = true;
    camMoveAmt = 25;

    for (d in ['transLookalike', 'bf-lookalike', 'transLookalike2'])
        precacheCharacter(0, d);

    graphicCache.cache(BillyPath('broken_mirror'));
    mirror = new FlxSprite().loadGraphic(BillyPath('silly_mirror'));
    mirror.antialiasing = Options.antialiasing;
    mirror.camera = billyCam;
    add(mirror);

    var sprites:FunkinSprite = new FunkinSprite(0,0,BillyPath('bgAssets'));
    sprites.addAnim('idle', 'Silly_floor', 0, false);
    sprites.playAnim('idle');
    sprites.antialiasing = Options.antialiasing;
    sprites.camera = camGame;
    insert(1, sprites);

    var sprites:FunkinSprite = new FunkinSprite(0,0,BillyPath('bgAssets'));
    sprites.addAnim('idle', 'Silly_idk_1', 0, false);
    sprites.playAnim('idle');
    sprites.antialiasing = Options.antialiasing;
    sprites.camera = camGame;
    insert(2, sprites);

    var sprites:FunkinSprite = new FunkinSprite(0,0,BillyPath('bgAssets'));
    sprites.addAnim('idle', 'Silly_idk_2', 0, false);
    sprites.playAnim('idle');
    sprites.antialiasing = Options.antialiasing;
    sprites.camera = camGame;
    insert(3, sprites);
}

var MODCHART:Bool = true;

function postCreate() {
    importScript('songs/Silly Billy/healthbar');
    
    if (MODCHART) {
        var modManager:Manager = new Manager();
        modManager.addModifier('Transform', 0);
        modManager.addModifier('Boost', 0);
        add(modManager);

        modManager.setPercent('x', 700, 0);
        modManager.setPercent('y', downscroll ? 680 : 400, 0);
        modManager.setPercent('z', 0.25, 0);
        modManager.setPercent('flip', -0.25, 0);
        modManager.setPercent('Boost', 2.0, 0);
        modManager.setPercent('brake', 0.2, 0);
        modManager.setPercent('sudden', 0.9, 0);
        modManager.setPercent('suddenOffset', 1, 0);
        modManager.setPercent('alpha', 0.5, 0);
    }

    IllMake = new FunkinSprite(1600, 1130, BillyPath('lyrics'));
    IllMake.addAnim('play', 'story_of_yourtalebilly', 24, false);
    IllMake.antialiasing = Options.antialiasing;
    IllMake.alpha = 0.001;
    IllMake.camera = camGame;
    add(IllMake);

    var vig = new FlxSprite().loadGraphic(BillyPath('hud/vignette'));
    vig.camera = camHUD;
    insert(1, vig);

    black.camera = camHUD;
    add(black);

    video = new FlxVideoSprite(212, 121);
    video.load(Paths.video('open'));
    video.bitmap.onEndReached.add(video.destroy);
    video.camera = camHUD;
    video.antialiasing = true;
    video.scale.set(1.5, 1.5);
    video.updateHitbox();
    add(video);

    MyWay = new FlxVideoSprite();
    MyWay.load(Paths.video('SO_STAY_FINAL'));
    MyWay.bitmap.onEndReached.add(MyWay.destroy);
    MyWay.camera = camHUD;
    MyWay.antialiasing = true;
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
        strum.camera = billyCam;
        strum.scale.set(1, 1);
        strum.updateHitbox();
        if (i >= 1) strum.x += i * 95;
    }
    
    dad.camera = camGame;
    boyfriend.camera = camGame;
    camGame.visible = false;
}

function onSongStart() video.play();
function onStrumCreation(_) _.cancelAnimation();
function onNoteCreation(_) _.note.splash = 'billy';

function onPostStrumCreation(_) if (_.player == 0)
    _.strum.camera = billyCam;

function onPostNoteCreation(_) if (_.strumLineID == 0) {
    _.note.scale.set(1, 1);
    _.note.updateHitbox();
    _.note.scrollFactor.set(1, 1);

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

function update() {
    billyCam.zoom = FlxG.camera.zoom;

    if (!paused) {
        if (MyWay != null) MyWay.resume();
        if (video != null) video.resume();
    }
}