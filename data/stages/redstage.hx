function postCreate(){

    loadHud('KadeEngine', '1.5.4');

    for (strum in cpu)
        strum.visible = false; 

    for (i in playerStrums) 
        i.x -= 640;

    for (hb in [healthBar, healthBarBG])
        hb.flipX = true;

    for (ic in [iconP1, iconP2])
        ic.visible = false;

}

function create(){
        
    health += 1;
    var fondo:FlxSprite = new FlxSprite(-852,-475, getModImage('pokemonmaster/fondo_pokemon_1'));
    defaultCamZoom = 0.85;
    insert(1,fondo);
    //dad.size = 0.5;

}

function onPlayerHit(e) e.healthGain = 0;
function onPlayerMiss(e) e.healthGain = -0.028;