var plane:FlxSprite;

function create() {
    defaultCamZoom = 0.65;

    graphicCache.cache(getModImage('Challenge-EDD/plane'));

    boyfriend.setPosition(1160, 90);
    gf.setPosition(605, 94);
    dad.setPosition(286, 190);

    var sky:FlxSprite = new FlxSprite(-1060, -800, getModImage('Challenge-EDD/sky'));
    sky.scrollFactor.set(0.2, 0.2);
    insert(1, sky);

    var clouds:FlxSprite = new FlxSprite(-1060, -220, getModImage('Challenge-EDD/clouds'));
    clouds.scrollFactor.set(0.15, 0.15);
    insert(2, clouds);

    var parallax:FlxSprite = new FlxSprite(-710, 300, getModImage('Challenge-EDD/secParallax'));
    parallax.scrollFactor.set(0.75, 0.75);
    parallax.scale.set(1.5, 1.5);
    insert(3, parallax);

    var house:FlxSprite = new FlxSprite(-950, -50, getModImage('Challenge-EDD/house'));
    house.scale.set(1.5, 1.5);
    insert(4, house);

    var fence:FlxSprite = new FlxSprite(-390, 430, getModImage('Challenge-EDD/fence'));
    fence.scale.set(1.5, 1.5);
    insert(5, fence);

    var car:FlxSprite = new FlxSprite(-1175, 750, getModImage('Challenge-EDD/car'));
    insert(5, car);
}

function stepHit() {
    switch(curStep) {
        case 380: Plane();
    }
}

function postCreate() {
    loadHud('VS-Online');
}

function Plane() {
    plane = new FlxSprite(1200, 0, getModImage('Challenge-EDD/plane'));
    plane.scrollFactor.set(0.2, 0.2);
    plane.scale.set(1.5, 1.5);
    insert(3, plane);

    FlxTween.tween(plane, {x: 1900}, 10, {onComplete: function() {
        remove(plane);
    }});
}