function create(){

        precacheCharacter(0, 'pixelpokemonmaster'); // los pendejos
        precacheCharacter(1, 'pixelpokemonmasterbf');

        setRatingPrefix('KadeNewPixel');
        setRatingPrefix('KadeNew');

}

function stepHit()

    switch(curStep){

        case 512, 640, 1056: // Switch... on!

            changeCharacter(0, 'pixelpokemonmaster');
            changeCharacter(1, 'pixelpokemonmasterbf');

            dad.flipX = false; // Me di cuenta que asi no era XDDDDDDDDDDD
            dad.scale.set(0.6,0.6);
            dad.setPosition(90,-350);

            boyfriend.setPosition(-585,100);
            boyfriend.scale.set(0.7,0.7);

            defaultCamZoom = 1.25; // 0.85
            fondopm.visible = false;
            playerCam.y = 128;

            //ratingPrefix = 'KadeNewPixel';
            
            case 576, 704, 1264: // Bite the dust!
            
            changeCharacter(0, 'pokemonmaster');
            changeCharacter(1, 'pokemonmasterbf');
            
            dad.flipX = true;
            dad.scale.set(0.6,0.6);
            dad.setPosition(200,-555);
            
            boyfriend.setPosition(-700,90);
            boyfriend.scale.set(1,1);
            
            defaultCamZoom = 0.85; // 0.85
            fondopm.visible = true;
            playerCam.y = 0;

            //ratingPrefix = 'KadeNew';

        }