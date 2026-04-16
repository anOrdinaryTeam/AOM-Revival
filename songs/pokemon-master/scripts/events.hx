function create()

        precacheCharacter(0, 'pixelpokemonmaster');
        precacheCharacter(1, 'pixelpokemonmasterbf');

function stepHit()

    switch(curStep){

        case 512: // Switch... on!
            changeCharacter(0, 'pixelpokemonmaster');
            changeCharacter(1, 'pixelpokemonmasterbf');
    }