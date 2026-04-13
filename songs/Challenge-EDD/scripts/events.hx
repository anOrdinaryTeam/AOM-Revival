var matt:FunkinSprite;
var tom:FunkinSprite;

var mattIdle:Bool = false;
var tomIdle:Bool = false;
var canTom:Bool = true;

var eduardo:Bool = false;

public var edd:Character;

function create() {
    if (curDiff == 'hard') {
        for (h in ['matt-eduardo', 'tom', 'Mark', 'Jon', 'EduardoPunch'])
            graphicCache.cache(getModImage('Challenge-EDD/hard/' + h));
            precacheCharacter(0, 'eduardo');
    }
    else {
        for (f in ['bf-tord', 'edd-tord', 'matt-tord', 'tomRunsIn', 'tordBot', 'tordGlass', 'tordBG', 'tordHelicopter', 'tordFlails', 'bf-lookup'])
            graphicCache.cache(getModImage('Challenge-EDD/fucked/' + f));
            precacheCharacter(0, 'tord');
    }
}

function stepHit() {
    if (curDiff == 'hard')
    {
        switch(curStep)
        {
            case 271:
                matt(true, false);
            case 416:
                tom(true, false);
            case 911:
                mattIdle = false; tomIdle = false;
                eduardo();
            case 928:
                matt(false, true);
                mattIdle = true; tomIdle = true;
        }
    }
    else
    {
        //
    }
}

function beatHit() {
    if (mattIdle) {
        matt.x = 20;
        matt.playAnim('idle');
    }

    if (curCameraTarget == 1 && tomIdle) {
        if (!canTom) {
            tom.playAnim('turns2');
            canTom = true;
        }
        else { tom.playAnim('idle'); }
    }
    else if (curCameraTarget == 0 && tomIdle) {
        if (canTom) {
            tom.playAnim('turns');
            canTom = false;
        }
        else { tom.playAnim('look'); }
    }
}

function onNoteHit(_) {
    if (_.noteType == "edd note") {
        playerCam.x = 850;
        playerCam.y = 450;
    }
    else {
        playerCam.x = 1060;
        playerCam.y = 500;
    }

}

function matt(index:Bool, can:Bool) {
    if (index)
    {
        matt = new FunkinSprite(825, 240).loadSprite(getModImage('Challenge-EDD/matt'));
        matt.antialiasing = true;
        matt.scale.set(1.7, 1.7);

        matt.addAnim('walk', 'walk', 12, true, true);
        matt.addAnim('idle', 'idle', 12, false);
        matt.playAnim('walk', true);
        
        insert(7, matt);
        
        FlxTween.tween(matt, {x: 135}, 4, {onComplete: function() { mattIdle = true; }});
    }
    if (can) {
        if (curDiff == 'hard')
        {
            matt.destroy();

            matt = new FunkinSprite(25, 220).loadSprite(getModImage('Challenge-EDD/hard/matt-eduardo'));
            matt.antialiasing = true;
            matt.scale.set(1.7, 1.7);

            matt.addAnim('react', 'mattReactionTord', 12, false);
            matt.addAnim('idle', 'mattPISSED', 12, false);

            insert(7, matt);
        }
        else
        {
            //
        }
    }
}

function tom(index:Bool, can:Bool) {
    if (index)
    {
        tom = new FunkinSprite(825, 270).loadSprite(getModImage('Challenge-EDD/hard/tom'));
        tom.antialiasing = true;
        tom.scale.set(1.7, 1.7);
        
        tom.addAnim('idle', 'idle', 12, false);
        tom.addAnim('look', 'tomLooking', 12, false);
        tom.addAnim('turns', 'tomTurns', 24, false, true);
        tom.addAnim('turns2', 'tomTurns', 24, false, true, [8,7,6,5,4,3,2,1]);
        tom.addAnim('surp', 'tomSurprise', 12, false);
        
        tom.addAnim('walk', 'walk', 12, true, true);
        tom.playAnim('walk', true);
        
        insert(7, tom);

        FlxTween.tween(tom, {x: 1545}, 4, {onComplete: function() { tomIdle = true; }});
    }
    if (can)
    {
        //
    }
}

function eduardo() {
    eduardo = true;

    remove(dad);
    insert(5, dad);

    changeCharacter(0, 'eduardo');
    dad.setPosition(-886, 50);

    opponentCam.x = -150;
    opponentCam.y = 400;

    edd = new Character(286, 190, "edd_side");
    edd.cameraOffset.set(850, 450);
    edd.playAnim('EddTurnAround', true);
    insert(13, edd);
}