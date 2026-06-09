var backpast:FlxSprite;
var rlightpast:FlxSprite;
var llightpast:FlxSprite;
var curtainspast:FlxSprite;
var stagepast:FlxSprite;

var bfpast:FunkinSprite;
var gfpast:FunkinSprite;
var dadpast:FunkinSprite;

var dadDrain:Float = .04;

var past = new FunkinShader('
    #pragma header

    void main() {
        vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
        float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
        gl_FragColor = vec4(vec3(gray), color.a);
    }
');

function create() {
    camHUD.alpha = 0;

    for (chars in [boyfriend, gf, dad]) chars.shader = past;
    
    var folder:String = 'stages/default';

    backpast = new FlxSprite(-600, -200, getImage('$folder/stageback'));
    backpast.antialiasing = Options.antialiasing;
    backpast.scale.set(1.2, 1.2);
    addSprite(backpast);

    stagepast = new FlxSprite(-600, 650, getImage('$folder/stagefront'));
    stagepast.antialiasing = Options.antialiasing;
    stagepast.scale.set(1.2, 1.2);
    addSprite(stagepast);

    if (!Options.lowMemoryMode) {
        rlightpast = new FlxSprite(-200, -125, getImage('$folder/stage_light'));
        rlightpast.antialiasing = Options.antialiasing;
        rlightpast.scale.set(1.2, 1.2);
        addSprite(rlightpast);

        llightpast = new FlxSprite(1325, -125, getImage('$folder/stage_light'));
        llightpast.antialiasing = Options.antialiasing;
        llightpast.scale.set(1.2, 1.2);
        llightpast.flipX = true;
        addSprite(llightpast);

        for (items in [rlightpast, llightpast]) items.shader = past;
    }

    curtainspast = new FlxSprite(-600, -200, getImage('$folder/stagecurtains'));
    curtainspast.antialiasing = Options.antialiasing;
    curtainspast.scale.set(1.2, 1.2);
    addSprite(curtainspast);

    for (items in [backpast, stagepast, curtainspast]) items.shader = past;
}

function stepHit() {
    switch(curStep) {
        case 112:
            camGame.zoom = defaultCamZoom = 0.5;
            camHUD.alpha = 1;

            for (chars in [boyfriend, dad]) chars.shader = null;
            for (items in [backpast, stagepast, curtainspast]) remove(items, true);

            if (!Options.lowMemoryMode)
                for (items in [rlightpast, llightpast]) remove(items, true);

            changeCharacter(0, 'TheDeathmatch/dearest');
            changeCharacter(1, 'TheDeathmatch/bf-deathmatch');

            gf.visible = false;

        case 512:
            if (!Options.lowMemoryMode)
                for (items in [bpeople, fpeople]) items.alpha = 1;

            kworld.alpha = 1;

        case 768:
            changeCharacter(1, 'TheDeathmatch/pico-death');

        case 1024:
            kworld.alpha = 0.001;
            world.alpha = 1;
            changeCharacter(1, 'TheDeathmatch/kids-death');

        case 1408:
            dadDrain = .03;
            kworld.alpha = 1;
            remove(world, true);

            changeCharacter(0, 'TheDeathmatch/dearest2');
            changeCharacter(1, 'TheDeathmatch/mom-death');

            if (!Options.lowMemoryMode)
                bpeople.playAnim('mom');

        case 1664:
            dadDrain = .02;
            changeCharacter(0, 'TheDeathmatch/dearest3');
            changeCharacter(1, 'TheDeathmatch/bf-deathmatch');
            
            if (!Options.lowMemoryMode)
                bpeople.playAnim('idle');

        case 2432:
            dadDrain = .01;
            changeCharacter(0, 'TheDeathmatch/dearest4');
    }
}

function onDadHit(_)
    if (health > 0.4)
        health -= dadDrain;