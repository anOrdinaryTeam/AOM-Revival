public var pixelMode:Bool = false;

function create(){

    precacheCharacter(0, 'PokemonMaster/pixelpokemonmaster'); // los pendejos
    precacheCharacter(1, 'PokemonMaster/pixelpokemonmasterbf');
    // precacheNotes('modNotes/pokemonmaster/NOTE_assets');

}

function stepHit()

    switch(curStep){
        
        case 512, 640, 1056: // Switch... on!
        
            pixelMode = true;

            changeCharacter(0, 'PokemonMaster/pixelpokemonmaster');
            changeCharacter(1, 'PokemonMaster/pixelpokemonmasterbf');
            changeNoteSkin('modNotes/pokemonmaster/NOTE_assets', player, 'both', false);

            dad.flipX = false; // Me di cuenta que asi no era XDDDDDDDDDDD
            dad.scale.set(0.6,0.6);
            dad.setPosition(90,-350);

            boyfriend.setPosition(-585,100);
            boyfriend.scale.set(0.7,0.7);

            defaultCamZoom = 1.25; // 0.85
            fondopm.visible = false;
            charizard.visible = false;
            pixelcharizard.visible = true;
            pikachu.visible = false;
            pixelpikachu.visible = true;
            playerCam.y = 128;

            //ratingPrefix = 'KadeNewPixel';
            
            case 576, 704, 1264: // Bite the dust!

            pixelMode = false;
            
            changeCharacter(0, 'PokemonMaster/pokemonmaster');
            changeCharacter(1, 'PokemonMaster/pokemonmasterbf');
            changeNoteSkin('game/notes/default', player, 'both', false);
            
            dad.flipX = true;
            dad.scale.set(0.6,0.6);
            dad.setPosition(200,-555);
            
            boyfriend.setPosition(-700,90);
            boyfriend.scale.set(1,1);
            
            defaultCamZoom = 0.85; // 0.85
            fondopm.visible = true;
            charizard.visible = true;
            pixelcharizard.visible = false;
            pikachu.visible = true;
            pixelpikachu.visible = false;
            playerCam.y = 0;

            //ratingPrefix = 'KadeNew';

        }