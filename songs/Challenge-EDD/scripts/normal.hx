public var matt:FunkinSprite;
public var tom:FunkinSprite;

public var canMattIdle:Bool = false;
public var canTomIdle:Bool = false;

function create() {
    graphicCache.cache(getModImage('Challenge-EDD/matt'));

    if (curDiff == 'hard') { importScript('songs/Challenge-EDD/scripts/who_i_choose/hard.hx'); }
    else { importScript('songs/Challenge-EDD/scripts/who_i_choose/fucked.hx'); }
}

function stepHit() {
    switch(curStep) {
        case 271: Matt();
    }
}

function beatHit() {
    if (Std.isOfType(matt, FunkinSprite) && canMattIdle) {
        matt.playAnim('idle');
    }
}

function Matt() {
    matt = new FunkinSprite(825, 240).loadSprite(getModImage('Challenge-EDD/matt'));
    matt.antialiasing = true;
    matt.scale.set(1.7, 1.7);

    matt.addAnim('walk', 'walk', 12, true, true);
    matt.addAnim('idle', 'idle', 12, false);
    matt.playAnim('walk', true);
    
    insert(7, matt);
    
    FlxTween.tween(matt, {x: 135}, 4, {onComplete: function() {
        canMattIdle = true;
        matt.x = 20;
        matt.playAnim('idle');
    }});
}