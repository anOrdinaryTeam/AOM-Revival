public var fondopm:FlxSprite;

function postCreate(){

    loadHud('KadeEngine', '1.5.4');

    for (strum in cpu)
        strum.visible = false; 

    for (i in playerStrums) 
        i.x -= 640;

    for (ic in [iconP1, iconP2, healthBarBG])
        ic.visible = false;

    healthBar.flipX = true;
    healthBar.scale.set(0.345,0.225);
    healthBar.setPosition(370.25,593.25);

    health += 1;
    
}

function create(){
        
    var pixelbg:FlxSprite = new FlxSprite().makeSolid(FlxG.width*1.5, FlxG.height*1.5, 0xFFFFFFFF);
    pixelbg.setPosition(-945,-530);
    insert(0, pixelbg);

    fondopm = new FlxSprite(-852,-475, getModImage('pokemonmaster/fondo_pokemon_1'));
    insert(1,fondopm);

    var healthPM:FlxSprite = new FlxSprite(135,400, getModImage('pokemonmaster/health'));
    healthPM.scale.set(0.4,0.4);
    healthPM.camera = camHUD;
    insert(1,healthPM);

   var healthBarPM:FlxSprite = new FlxSprite(150,507, getModImage('pokemonmaster/healthBar'));
    healthBarPM.scale.set(0.35,0.35);
    healthBarPM.camera = camHUD;
    insert(2,healthBarPM);

    defaultCamZoom = 0.85; // 0.85
    dad.scale.set(0.6,0.6);

}

function beatHit(){

    if (health <= 0.5 && curBeat % 2 == 0){
        playModSound('lowhp',7.5);
    }

}

function onPlayerHit(e) e.healthGain = 0;
function onPlayerMiss(e) e.healthGain = -0.1;