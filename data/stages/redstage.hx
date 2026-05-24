public var fondopm:FlxSprite;
public var charizard:FunkinSprite;
public var pikachu:FunkinSprite;
public var pixelcharizard:FunkinSprite;
public var pixelpikachu:FunkinSprite;

function postCreate(){
    loadHud('KadeEngine', '1.5.4');

    for (strum in cpu)
        strum.visible = false; 

    for (i in playerStrums) 
        i.x -= 640;

    for (ic in [iconP1, iconP2, healthBarBG])
        ic.visible = false;

    healthBar.flipX = true;
    healthBar.scale.set(0.35,0.225);
    healthBar.x = 370.25;
    healthBar.y = (downscroll ? 608.95 : 593.25);

    health += 1;
}

function create(){

    var pixelbg:FlxSprite = new FlxSprite().makeSolid(FlxG.width*1.5, FlxG.height*1.5, 0xFFFFFFFF);
    pixelbg.setPosition(-945,-530);
    insert(0, pixelbg);

    fondopm = new FlxSprite(-852,-475, getModImage('pokemonmaster/fondo_pokemon_1'));
    fondopm.antialiasing = Options.antialiasing;
    insert(1,fondopm);

    var healthPM:FlxSprite = new FlxSprite(135,400, getModImage('pokemonmaster/health'));
    healthPM.antialiasing = Options.antialiasing;
    healthPM.scale.set(0.4,0.4);
    healthPM.camera = camHUD;
    add(healthPM);

    var healthBarPM:FlxSprite = new FlxSprite(150,507, getModImage('pokemonmaster/healthBar'));
    healthBarPM.antialiasing = Options.antialiasing;
    healthBarPM.scale.set(0.35,0.35);
    healthBarPM.camera = camHUD;
    add(healthBarPM);

    charizard = new FunkinSprite(dad.x - 340, dad.y - 750).loadSprite(getModImage('pokemonmaster/charizard'));
    charizard.antialiasing = Options.antialiasing;
    charizard.addAnim('idle', 'chari idle', 24, false, false);
    charizard.addAnim('attack', 'charizard atack', 24, false, false);
    charizard.scale.set(0.55,0.55);
    charizard.addOffset('attack', charizard.x + 680, 25);
    insert(4, charizard);

    pikachu = new FunkinSprite(dad.x + 235, dad.y - (750/2)+20).loadSprite(getModImage('pokemonmaster/pikachu'));
    pikachu.antialiasing = Options.antialiasing;
    pikachu.addAnim('idle', 'PIKACHU IDLE', 24, false, false);
    pikachu.addAnim('attack', 'pikaatack', 24, false, false);
    pikachu.scale.set(0.55,0.55);
    insert(getObjectOrder(dad)+1, pikachu);

    pixelcharizard = new FunkinSprite(dad.x - 260, dad.y - 410).loadSprite(getModImage('pokemonmaster/pixelcharizard'));
    pixelcharizard.addAnim('idle', 'chariidle instancia', 24, false, false);
    pixelcharizard.scale.set(0.55,0.55);
    pixelcharizard.addOffset('attack', charizard.x + 680, 25);
    insert(5, pixelcharizard);
    pixelcharizard.visible = false;

    pixelpikachu = new FunkinSprite(dad.x + 150, dad.y - (750/2)+220).loadSprite(getModImage('pokemonmaster/pixelpikachu'));
    pixelpikachu.addAnim('idle', 'pikachu idle instancia', 24, false, false);
    pixelpikachu.scale.set(0.55,0.55);
    insert(getObjectOrder(dad)+1, pixelpikachu);
    pixelpikachu.visible = false;

    defaultCamZoom = 0.8; // 0.8
    dad.scale.set(0.6,0.6);
}

function beatHit(){
    if (curBeat % 2 == 0){
        charizard.playAnim('idle');
        pixelcharizard.playAnim('idle');
    }
    else{
        pikachu.playAnim('idle');
        pixelpikachu.playAnim('idle');
    }
    if (health <= 0.5 && curBeat % 2 == 0){
        playModSound('lowhp',7.5);
    }

}

function onPlayerHit(e) e.healthGain = 0;
function onPlayerMiss(e) e.healthGain = -0.1;