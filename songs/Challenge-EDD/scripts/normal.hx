public var matt:FunkinSprite;
public var door:FunkinSprite;

public var canMattIdle:Bool = false;
public var canTomIdle:Bool = false;
var alreadyOpen:Bool = false;

function create() {
    importScript('songs/Challenge-EDD/$curDiff.hx');
    for (n in ['matt', 'eddDoor'])
        graphicCache.cache(getModImage('ChallengeEdd/$n'));
}

function stepHit() {
    switch(curStep) {
        case 271: Matt();
        case 416: if (curDiff == 'hard') Door();
    }
}

function beatHit() {
    if (canMattIdle)
        matt.playAnim('idle');
}

function Door() {
    if (!alreadyOpen) {
        door = new FunkinSprite(770, 305).loadSprite(getModImage('ChallengeEdd/eddDoor'));
        door.antialiasing = true;
        door.scale.set(1.5, 1.5);

        door.addAnim('open', 'Door Opening', 12, false, false, [1,2,3,4,5,6,7,8,9,10,12]);
        door.addAnim('close', 'Door Opening', 12, false, false, [13,14,1]);

        insert(5, door);

        alreadyOpen = true;
    }
    door.playAnim('open');
    door.animation.finishCallback = function(name:String) {
    if (name == 'open') { new FlxTimer().start(0.5, () -> door.playAnim('close')); }
    }
}

function Matt() {
    Door();

    matt = new FunkinSprite(825, 240).loadSprite(getModImage('ChallengeEdd/matt'));
    matt.antialiasing = true;
    matt.scale.set(1.7, 1.7);

    matt.addAnim('walk', 'walk', 12, true, true);
    matt.addAnim('idle', 'idle', 12, false);
    matt.playAnim('walk', true);
    
    insert(7, matt);
    
    FlxTween.tween(matt, {x: 135}, 3, {onComplete: function() {
        canMattIdle = true;
        matt.x = 20;
        matt.playAnim('idle');
    }});
}