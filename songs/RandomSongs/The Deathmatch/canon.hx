gf.visible = false;

function stepHit() {
    switch(curStep) {
        case 128:
            defaultCamZoom = 0.5;

        case 511:
            if (!Options.lowMemoryMode)
                for (items in [bpeople, fpeople]) items.alpha = 1;

            kworld.alpha = 1;

        case 767:
            changeCharacter(1, 'TheDeathmatch/pico-death');
        
        case 1019:
            kworld.alpha = 0.001;
            world.alpha = 1;
            changeCharacter(1, 'TheDeathmatch/kids-death');
        
        case 1401:
            kworld.alpha = 1;
            remove(world, true);

            changeCharacter(0, 'TheDeathmatch/dearest2');
            changeCharacter(1, 'TheDeathmatch/mom-death');

            if (!Options.lowMemoryMode)
                bpeople.playAnim('mom');

        case 1656:
            changeCharacter(0, 'TheDeathmatch/dearest3');
            changeCharacter(1, 'TheDeathmatch/bf-deathmatch');

            if (!Options.lowMemoryMode)
                bpeople.playAnim('idle');

        case 2165:
            changeCharacter(0, 'TheDeathmatch/dearest4');
    }
}