var shader:FunkinShader;
var iTime:Float = 0;
var chromatic:String = "
    #pragma header
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    #define iChannel0 bitmap
    #define iChannel1 bitmap
    #define texture flixel_texture2D
    #define fragColor gl_FragColor
    #define mainImage main

    uniform float _Indensity;
    uniform float iTime;

    float randomNoise(float x, float y)
    {
        return fract(sin(dot(vec2(x, y), vec2(12.9898, 78.233))) * 43758.5453);
    }

    void mainImage()
    {
        vec2 uv = fragCoord/iResolution.xy;
        
        float splitAmount = _Indensity * randomNoise(iTime, 2.0);
        vec4 ColorR = texture(iChannel0, vec2(uv.x + splitAmount, uv.y));
        vec4 ColorG = texture(iChannel0, uv);
        vec4 ColorB = texture(iChannel0, vec2(uv.x - splitAmount, uv.y));
        fragColor = vec4(ColorR.r, ColorG.g, ColorB.b, flixel_texture2D(bitmap, uv).a);
    }
";

// Only for be usable in The Anger Of God
public var stageParts:Array<FlxSprite> = [];
defaultCamZoom = 0.8;

// Obj's
var playerTrail:Character;
var jebusTrail:Character;

// Tweeneres
var playerTweenTrail:FlxTween;
var jebusTweenTrail:FlxTween;

// Timers
var playerTimerTrail:FlxTimer = new FlxTimer();
var jebusTimerTrail:FlxTimer = new FlxTimer();

// Trails configs
var offSide:Float = 250;
var onHitAlpha:Float = 0.7;
var timeIn:Float = 0.2;
var timeOut:Float = 0.3;
var waitTime:Float = 0.3;
var easeTrail:FlxEase = FlxEase.circInOut;

function preStageLoad()
    useStageData = false;

function addBg(spr:FlxSprite) if (spr != null) {
    spr.antialiasing = Options.antialiasing;
    addSprite(spr);
}

function create() {
    gf.setPosition(900, 300);
    dad.setPosition(63, 365);
    boyfriend.setPosition(1360, 380);

    if (Options.gameplayShaders) {
        shader = new FunkinShader(chromatic);
        shader._Indensity = 0.005;
        FlxG.game.addShader(shader);
    }

    if (songName != '1Corekiller') {
        var sky:FlxSprite = new FlxSprite(-600, -300, getModImage('Nevada/red'));
        sky.scale.set(1.7, 1.7);
        sky.updateHitbox();
        sky.scrollFactor.set(0.9, 0.9);
        addBg(sky);
        stageParts.push(sky);
    }

    var hills:FlxSprite = new FlxSprite(-400, -430, getModImage('Nevada/atras_pero_atras'));
    hills.scrollFactor.set(0.9, 0.9);
    hills.scale.set(1.3, 1.3);
    hills.updateHitbox();
    addBg(hills);
    stageParts.push(hills);
    
    var bgType:String = songName == '1Corekiller' ? 'fondo-de-atras2' : 'fondo-de-atras';
    var bg:FlxSprite = new FlxSprite(-200, -320, getModImage('Nevada/$bgType'));
    bg.scrollFactor.set(0.9, 0.9);
    bg.scale.set(1.3, 1.3);
    bg.updateHitbox();
    addBg(bg);
    stageParts.push(bg);

    var floor:FlxSprite = new FlxSprite(-727, -516, getModImage('Nevada/fondo-de-alfrente'));
    floor.scale.set(1.7, 1.7);
    floor.updateHitbox();
    addBg(floor);
    stageParts.push(floor);
}

function postCreate() {
    if (boyfriend.curCharacter == 'bf' || boyfriend.curCharacter == 'pico')
        boyfriend.cameraOffset.x -= 200;

    if (songName != '1Corekiller') return;

    jebusTrail = strumLines.members[0].characters[1];
    jebusTrail.alpha = 0.001;
    jebusTrail.color = dad.iconColor;
    jebusTrail.setPosition(dad.x - offSide, dad.y);
    remove(jebusTrail);
    insert(members.indexOf(dad), jebusTrail);

    playerTrail = strumLines.members[1].characters[1];
    playerTrail.alpha = 0.001;
    playerTrail.color = boyfriend.iconColor;
    playerTrail.setPosition(boyfriend.x + offSide, boyfriend.y);
    remove(playerTrail);
    insert(members.indexOf(boyfriend), playerTrail);
}

function onDadHit(e) {
    if (e.character.curCharacter == 'FNM/jebus') return;
    camGame.shake(0.01, 0.15);
    doTrailTween(jebusTrail, jebusTweenTrail, jebusTimerTrail);
}

function onPlayerHit() {
    if (songName != '1Corekiller') return;
    doTrailTween(playerTrail, playerTweenTrail, playerTimerTrail);
}

function update(dt) if (Options.gameplayShaders && shader != null) {
    iTime += dt;
    shader.iTime = iTime;
}

function doTrailTween(_obj:Character, _twn:FlxTween, _tmr:FlxTimer) {
    var obj:Character = _obj;
    var twn:FlxTween = _twn;
    var tmr:Character = _tmr;

    tmr?.cancel();
    tmr.start(waitTime, () -> {
        twn?.cancel();
        twn = FlxTween.tween(obj, {alpha: 0}, timeOut, {ease: easeTrail});
    });

    if (twn?.active || obj.alpha == onHitAlpha) return;
    twn?.cancel();
    twn = FlxTween.tween(obj, {alpha: onHitAlpha}, timeIn, {ease: easeTrail});
}

function destroy()
    FlxG.game.setFilters([]);