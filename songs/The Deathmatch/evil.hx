var backpast:FlxSprite;
var rlightpast:FlxSprite;
var llightpast:FlxSprite;
var curtainspast:FlxSprite;
var stagepast:FlxSprite;

var bfpast:FunkinSprite;
var gfpast:FunkinSprite;
var dadpast:FunkinSprite;

var dadDrain:Float = .04;

function create() {
    // stage memories n shit
    camHUD.alpha = 0;
    
    backpast = new FlxSprite(-600, -200, getModImage('TheDeathmatch/stagebackpast'));
    backpast.scale.set(1.2, 1.2);
    add(backpast);

    stagepast = new FlxSprite(-600, 650, getModImage('TheDeathmatch/stagefrontpast'));
    stagepast.scale.set(1.2, 1.2);
    add(stagepast);

    rlightpast = new FlxSprite(-200, -125, getModImage('TheDeathmatch/stage_lightpast'));
    rlightpast.scale.set(1.2, 1.2);
    add(rlightpast);

    llightpast = new FlxSprite(1325, -125, getModImage('TheDeathmatch/stage_lightpast'));
    llightpast.scale.set(1.2, 1.2);
    llightpast.flipX = true;
    add(llightpast);

    curtainspast = new FlxSprite(-600, -200, getModImage('TheDeathmatch/stagecurtainspast'));
    curtainspast.scale.set(1.2, 1.2);
    add(curtainspast);

    gfpast = new FunkinSprite(425, 125).loadSprite(getModImage('TheDeathmatch/past_GF'));
    gfpast.addAnim('idle', 'GF Dancing Beat0', 24, true);
    gfpast.playAnim('idle');
    add(gfpast);

    bfpast = new FunkinSprite(825, 475).loadSprite(getModImage('TheDeathmatch/past_BF'));
    bfpast.addAnim('idle', 'BF idle dance', 24, true);
    bfpast.playAnim('idle');
    add(bfpast);

    dadpast = new FunkinSprite(75, 75).loadSprite(getModImage('TheDeathmatch/past_dad'));
    dadpast.addAnim('idle', 'Dad idle dance', 24, true);
    dadpast.playAnim('idle');
    add(dadpast);
    
    for (a in [backpast, stagepast, rlightpast, llightpast, curtainspast, gfpast, bfpast, dadpast])
            { a.antialiasing = true; }
    // stage memories n shit
}

// events go brr
function stepHit() {
    if (curDiff != 'canon') {
        switch(curStep) {
            case 112:
                defaultCamZoom = 0.5;
                camHUD.alpha = 1;
                for (i in [backpast, stagepast, rlightpast, llightpast, curtainspast, gfpast, bfpast, dadpast])
                    { remove(i, true); }

            case 512:
                for (i in [kworld, bpeople, fpeople])
                    { i.alpha = 1; }
            
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

                bpeople.playAnim('mom');
                changeCharacter(0, 'TheDeathmatch/dearest2');
                changeCharacter(1, 'TheDeathmatch/mom-death');

            case 1664:
                dadDrain = .02;
                bpeople.playAnim('idle');
                changeCharacter(0, 'TheDeathmatch/dearest3');
                changeCharacter(1, 'TheDeathmatch/bf-deathmatch');

            case 2432:
                dadDrain = .01;
                changeCharacter(0, 'TheDeathmatch/dearest4');
        }
    }
}

function onDadHit(_) {
    if (health > 0.4)
        health -= dadDrain;
}