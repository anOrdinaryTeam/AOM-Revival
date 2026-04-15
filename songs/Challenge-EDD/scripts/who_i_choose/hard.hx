var tom:FunkinSprite;
var jon:FunkinSprite;
var mark:FunkinSprite;
var punch:FunkinSprite;

var canJMidle:Bool = false;
var canEdd:Bool = false;
var canTom:Bool = true;

function create() {
    for (h in ['matt-eduardo', 'tom', 'Mark', 'Jon', 'EduardoPunch']) { graphicCache.cache(getModImage('Challenge-EDD/hard/' + h)); }
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
            
        case 928, 932, 936:
            defaultCamZoom += 0.1;
            sky.alpha -= 0.15;

        case 944:
            defaultCamZoom = 0.65;
            FlxTween.tween(sky, {alpha: 1}, 1);

            canMattIdle = true;
            canTomIdle = true;

            matt.x = 55;
            matt.playAnim('idle', true);
            tom.playAnim('idle', true);
            edd.playAnim('idle', true, 'DANCE');

        case 1007, 1231, 1359, 1487: canEdd = true;
        case 1135, 1295, 1423, 1551: canEdd = false;

        case 1599: Dudes(true);
    }

}

function beatHit() {
    if (canTomIdle)   { // i hate ts but it works
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

    if (canJMidle && curBeat % 2 == 0) {
        jon.playAnim('idle');
        mark.playAnim('idle');
    }
}

function onNoteHit(_) {
    if (canEdd) {
        playerCam.x = 425;
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

    insert(9, matt);
}

function Tom() {
    tom = new FunkinSprite(825, 270).loadSprite(getModImage('Challenge-EDD/hard/tom'));
    tom.antialiasing = true;
    tom.scale.set(1.7, 1.7);
    
    tom.addAnim('idle', 'idle', 12, false);
    tom.addAnim('look', 'tomLooking', 12, false);
    tom.addAnim('turns', 'tomTurns', 24, false);
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

    opponentCam.x = -620;
    opponentCam.y = 350;

    edd = new Character(286, 190, "edd_side");
    insert(14, edd);

    Dudes(false);
}

function Dudes(canHit:Bool) {
    if (!canHit) {
        jon = new FunkinSprite(-690, 180).loadSprite(getModImage('Challenge-EDD/hard/Jon'));
        jon.antialiasing = true;
        jon.scale.set(1.3, 1.3);
        jon.addAnim('idle', 'JonIdle', 12, false);
        insert(5, jon);
        
        mark = new FunkinSprite(-550, 165).loadSprite(getModImage('Challenge-EDD/hard/Mark'));
        mark.antialiasing = true;
        mark.scale.set(1.1, 1.1);
        mark.addAnim('idle', 'MarkIdle', 12, false);
        insert(5, mark);
        
        canJMidle = true;
    } else {
        remove(dad);
        remove(jon);
        remove(mark);

        canJMidle = false;

        punch = new FunkinSprite(-800, 130).loadSprite(getModImage('Challenge-EDD/hard/EduardoPunch'));
        punch.antialiasing = true;
        punch.scale.set(1.35, 1.35);

        punch.addAnim('woosh', 'Woosh', 12, false);
        punch.addAnim('punch', 'Punch', 12, false);
        punch.addAnim('a', 'A', 12, false);
        punch.addAnim('ow', 'OW', 12, false);
        punch.addAnim('even', 'Even', 18, true);
        punch.addAnim('say', 'Say', 12, false);
        punch.addAnim('shut', 'ShutUp', 24, false);

        insert(5, punch);

        punch.playAnim('woosh', true, 'LOCK');
        punch.animation.finishCallback = function(name:String) {
            if (name == 'woosh') {
                new FlxTimer().start(0.15, () -> punch.playAnim('punch', true, 'LOCK'));
            }
            else if (name == 'punch') {
                punch.playAnim('a', true, 'LOCK');
                new FlxTimer().start(0.5, () -> punch.playAnim('ow', true, 'LOCK'));
            }
            else if (name == 'ow') {
                new FlxTimer().start(0.15, () -> punch.playAnim('even', true, 'LOCK'));
                new FlxTimer().start(1.15, () -> punch.playAnim('say', true, 'LOCK'));
            }
            else if (name == 'say')
                punch.playAnim('shut', true, 'LOCK');
        }
    }
}