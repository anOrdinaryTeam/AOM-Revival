function stepHit() {
    switch(curStep) {
        case 128:
            defaultCamZoom = 0.5;

        case 511:
            for (i in [kworld, bpeople, fpeople])
                { i.alpha = 1; }

        case 767:
            changeCharacter(1, 'TheDeathmatch/pico-death');
        
        case 1019:
            kworld.alpha = 0.001;
            world.alpha = 1;
            changeCharacter(1, 'TheDeathmatch/kids-death');
        
        case 1401:
            kworld.alpha = 1;
            remove(world, true);

            bpeople.playAnim('mom');
            changeCharacter(0, 'TheDeathmatch/dearest2');
            changeCharacter(1, 'TheDeathmatch/mom-death');

        case 1656:
            bpeople.playAnim('idle');
            changeCharacter(0, 'TheDeathmatch/dearest3');
            changeCharacter(1, 'TheDeathmatch/bf-deathmatch');

        case 2165:
            changeCharacter(0, 'TheDeathmatch/dearest4');
    }
}