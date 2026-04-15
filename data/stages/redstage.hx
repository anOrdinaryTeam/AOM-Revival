function postCreate(){

    loadHud('KadeEngine', '1.5.4');
    for (strum in cpu)
        strum.visible = false; 
    for (i in playerStrums) i.x -= 640;
    for (hb in [healthBar, healthBarBG])
        hb.flipX = true;

}

function create(){
        

    var fondo:FlxSprite = new FlxSprite(-852,-475, getModImage('pokemonmaster/fondo_pokemon_1'));
    defaultCamZoom = 0.85;
    insert(1,fondo);

}