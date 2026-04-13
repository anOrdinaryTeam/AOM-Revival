var canEdd:Bool = false;
var canTom:Bool = true;

function create() {
    for (h in ['matt-eduardo', 'tom', 'Mark', 'Jon', 'EduardoPunch'])
        { graphicCache.cache(getModImage('Challenge-EDD/hard/' + h)); }
    precacheCharacter(0, 'eduardo');
}

function stepHit() {
    switch(curStep)
    {
        case 416: Tom();

        case 911: 
            Matt();
            Eduardo();

            matt.x = 120;
            matt.playAnim('react', true);
            tom.playAnim('surp', true);
            edd.playAnim('EddTurnAround', true, 'LOCK');

        case 944:
            canMattIdle = true;
            canTomIdle = true;

            matt.x = 55;
            matt.playAnim('idle', true);
            tom.playAnim('idle', true);
            edd.playAnim('idle', true, 'DANCE');

        case 1007, 1231, 1359, 1487:
            canEdd = true;
        case 1135, 1295, 1423, 1551:
            canEdd = false;
    }

}

function beatHit() {
    if (Std.isOfType(tom, FunkinSprite) && canTomIdle)   { // i hate ts but it works
        if (curCameraTarget == 1) {
            if (!canTom) {
                tom.playAnim('turns2');
                canTom = true;
            }
            else { tom.playAnim('idle'); }
        }

        else if (curCameraTarget == 0) {
            if (canTom) {
                tom.playAnim('turns');
                canTom = false;
            }
            else { tom.playAnim('look'); }
        }
    }
}

function onNoteHit(_) {
    if (canEdd) {
        playerCam.x = 350;
        playerCam.y = 450;
    }
    else if (!canEdd) {
        playerCam.x = 1060;
        playerCam.y = 500;
    }
}

function Matt() {
    remove(matt);

    matt = new FunkinSprite(null, 240).loadSprite(getModImage('Challenge-EDD/hard/matt-eduardo'));
    matt.antialiasing = true;
    matt.scale.set(1.7, 1.7);

    matt.addAnim('react', 'reaction', 12, false);
    matt.addAnim('idle', 'mattPISSED', 12, false);

    canMattIdle = false;
    canTomIdle = false;

    insert(7, matt);
}

function Tom() {
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

    FlxTween.tween(tom, {x: 1545}, 4, {onComplete: function() {
        canTomIdle = true;
        tom.playAnim('idle');
    }});
}

function Eduardo() {
    eduardo = true;

    remove(dad);
    insert(5, dad);

    changeCharacter(0, 'eduardo');
    dad.setPosition(-886, 50);

    opponentCam.x = -150;
    opponentCam.y = 400;

    edd = new Character(286, 190, "edd_side");
    insert(14, edd);
}