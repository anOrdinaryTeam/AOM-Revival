introLength = 0;
camZoomOnBeat = false;

var wave   = new CustomShader('pendrive/wave');
var glitch = new CustomShader('pendrive/glitch2');
var chrom  = new CustomShader('pendrive/chromAbb');
var mosaic = new CustomShader('pendrive/mosaic');

var bg:FlxSprite;
var bg2:FlxSprite;

var circle:FlxSprite;
var fog:FlxSprite;
var behind:FlxSprite;
var comp2:FlxSprite;
var desk:FlxSprite;
var comp:FlxSprite;
var frame:FlxSprite;

var jump:FunkinSprite;
var blackshit:FlxSprite;

var canBop:Bool = true;
var numBop:Int = 4;

function create() {
    defaultCamZoom = 2.2;

    useCamMov = true;
    camMoveAmt = 25;

    boyfriend.iconColor = 0xFF35487c;

    for (s in ['BlueUSB', 'BlueUSB-real', 'BlueUSB-real1'])
        precacheCharacter(0, 'Countdown/$s');

    bg = new FlxSprite(0, 50, getModImage('Countdown/penbg'));
    bg.antialiasing = Options.antialiasing;
    addSprite(bg);

    circle = new FlxSprite(-20, 0, getModImage('Countdown/circle'));
    circle.antialiasing = Options.antialiasing;
    addSprite(circle);

    bg2 = new FlxSprite(0, 80, getModImage('Countdown/penbg2'));
    bg2.antialiasing = Options.antialiasing;
    bg2.visible = false;
    addSprite(bg2);

    fog = new FlxSprite(0, 50, getModImage('Countdown/fog3'));
    fog.antialiasing = Options.antialiasing;
    fog.scale.set(2, 2);
    fog.visible = false;
    addSprite(fog);

    jump = new FunkinSprite().loadSprite(getModImage('Countdown/jump'));
    jump.scale.set(.6, .6);
    addSprite(jump);
    
    jump.addAnim('idle', 'i', 24, true);
    jump.alpha = .001;

    behind = new FlxSprite(-275, 75, getModImage('Countdown/bgthingreal'));
    behind.antialiasing = Options.antialiasing;
    behind.scale.set(1.25, 1.25);
    behind.updateHitbox();
    addSprite(behind);

    comp2 = new FlxSprite(-275, 75, getModImage('Countdown/compute2'));
    comp2.antialiasing = Options.antialiasing;
    comp2.scale.set(1.25, 1.25);
    comp2.updateHitbox();
    addSprite(comp2);

    desk = new FlxSprite(-275, 75, getModImage('Countdown/desk'));
    desk.antialiasing = Options.antialiasing;
    desk.scale.set(1.25, 1.25);
    desk.updateHitbox();
    addSprite(desk);

    comp = new FlxSprite(-275, 75, getModImage('Countdown/computer'));
    comp.antialiasing = Options.antialiasing;
    comp.scale.set(1.25, 1.25);
    comp.updateHitbox();
    addSprite(comp);

    frame = new FlxSprite(-275, 75, getModImage('Countdown/frame'));
    frame.antialiasing = Options.antialiasing;
    frame.scale.set(1.25, 1.25);
    frame.updateHitbox();
    addSprite(frame);
    
    blackshit = new FlxSprite().makeSolid(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
    blackshit.camera = camGame;
    blackshit.alpha = 0;
    add(blackshit);
}

function postCreate() {
    loadHud('PsychEngine');

    iconP1.setIcon('Countdown/b1');

    wave.speed     = .0025;
    wave.intensity = 6;
    wave.bloom     = 0;

    glitch.AMT   = 0;
    glitch.SPEED = .5;

    for (huh in [wave, glitch])
        huh.iTime = .1;

    bg.shader  = wave;
    bg2.shader = wave;

    camGame.addShader(glitch);

    chrom.amount = 0;
    comp.shader = chrom;

    mosaic.pixel = .1;
    camGame.addShader(mosaic);

}

function postUpdate(elapsed:Float) {
    for (huh in [wave, glitch])
        huh.iTime = huh.iTime + elapsed;
}

function stepHit() {
    switch(curStep) {
        case 536:
            canBop = false;

	        FlxTween.tween(chrom, {amount: 1.5}, .5, {ease: FlxEase.expoOut});
            FlxTween.tween(camGame, {zoom: .525}, .2, {ease: FlxEase.sineInOut, onComplete: () -> {
	            FlxTween.tween(mosaic, {pixel: 20}, .2, {ease: FlxEase.expoIn});
                FlxTween.tween(camGame, {zoom: 1.25}, 1.3, {ease: FlxEase.expoOut});

                for (i in [comp, comp2, desk, frame, behind])
                    FlxTween.tween(i.scale, {x: 2, y: 2},1.3, {ease: FlxEase.expoOut, onComplete: () ->
                        i.alpha = 0
                    });
            }});
        
        case 546:
            changeCharacter(0, 'Countdown/BlueUSB-real1');

            FlxTween.tween(camGame, {zoom: .8}, .75, {ease: FlxEase.expoOut, onUpdate: () ->
                defaultCamZoom = camGame.zoom
            });
            FlxTween.tween(mosaic, {pixel:  .1}, .5, {ease: FlxEase.expoOut});
	        FlxTween.tween(chrom,  {amount:  0}, .1, {ease: FlxEase.expoOut});

            canBop = true;
            numBop = 2;
            wave.speed = .02;

        case 1308:
            FlxTween.tween(blackshit, {alpha: 1},  .6, {ease: FlxEase.expoOut});
            FlxTween.tween(glitch,    {AMT:  .4},  .4, {ease: FlxEase.sineOut});
            FlxTween.tween(camGame,   {zoom: 1.5}, .4, {ease: FlxEase.cubeOut});

            canBop = false;

        case 1312:
            changeCharacter(0, 'Countdown/BlueUSB-real');
            iconP1.setIcon('Countdown/b2');

            FlxTween.tween(blackshit, {alpha: 0},  .75, {ease: FlxEase.expoOut});
            FlxTween.tween(glitch,    {AMT:   0},   .5, {ease: FlxEase.sineOut});
            FlxTween.tween(camGame,   {zoom: .65}, .75, {ease: FlxEase.expoOut, onUpdate: () -> 
                defaultCamZoom = camGame.zoom
            });

            for (i in [circle, bg])
                remove(i, true);
            for (i in [bg2, fog])
                i.visible = true;

            canBop = true;
            wave.bloom = 0;

        case 1936:
            FlxTween.tween(wave,      {bloom: .5},        1.3, {ease: FlxEase.cubeOut});
			FlxTween.tween(fog.scale, {x: 1.25, y: 1.25}, 15);

        case 2096:
            FlxTween.tween(camGame, {zoom: 2}, 2.6, {ease: FlxEase.sineInOut, onUpdate: () ->
                defaultCamZoom = camGame.zoom
            });
            
            FlxTween.tween(glitch, {AMT:   .4},  2.6, {ease: FlxEase.sineInOut});
            FlxTween.tween(mosaic, {pixel: 40},  2.6, {ease: FlxEase.sineInOut});

            FlxTween.tween(blackshit, {alpha: 1}, 2.6, {ease: FlxEase.sineInOut});
            FlxTween.tween(camHUD,    {alpha: 0}, 2.6, {ease: FlxEase.sineInOut});


        case 2180:
            dad.alpha = 0;
            for (i in [bg2, fog, blackshit])
                remove(i, true);

            for (i in [comp, comp2, desk, frame, behind]) {
                FlxTween.tween(i,       {alpha: 1},         2.6, {ease: FlxEase.sineInOut});
                FlxTween.tween(i.scale, {x: 1.25, y: 1.25}, 5.2, {ease: FlxEase.sineInOut});
            }

            FlxTween.tween(camGame, {zoom: .5}, 5.2, {ease: FlxEase.sineInOut, onUpdate: () -> 
                defaultCamZoom = camGame.zoom
            });

            camGame.removeShader(glitch);
            camGame.removeShader(mosaic);
            camZoomingMult = 0;
            canBop = false;

        case 2356:
            jump.alpha = 1;
            jump.playAnim('idle');

    }
}

function beatHit() {
    if (curBeat >= 328 && curBeat < 484 && curBeat % 2 == 0)
        numbers();
    
    if (curBeat % numBop == 0 && canBop) {
        camGame.zoom += .015 * camZoomingMult;
        camHUD.zoom  += .03  * camZoomingMult;
    }
}

function numbers() {
    var X:Int = FlxG.random.int(600, 1500);
    var Y:Int = FlxG.random.int(600, 1100);

	var number:FunkinText = new FunkinText(X, Y, 0, FlxG.random.int(1, 10), 120);
    number.setFormat(Paths.font('pendrive/sonic-1-hud-font.ttf'), 120, FlxColor.WHITE);
    addSprite(number);

    number.angle = FlxG.random.int(-5, 5);
    number.alpha = 0;

    FlxTween.tween(number, {alpha: 1}, 1, {onComplete: () -> {
        FlxTween.tween(number, {alpha: 0}, 2, {onComplete: () -> remove(number, true) });
    }});

    FlxTween.circularMotion(number, number.x, number.y, 10, 0, FlxG.random.bool(50), 2, true);
}