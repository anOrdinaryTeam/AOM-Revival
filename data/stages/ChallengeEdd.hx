public var sky:FlxSprite;
var plane:FlxSprite;

function postCreate()
    loadHud('VS-Online');

function create() {
    defaultCamZoom = 0.65;

    graphicCache.cache(getModImage('ChallengeEdd/plane'));

    boyfriend.setPosition(1160, 90);
    gf.setPosition(605, 94); gf.scrollFactor.set(1, 1);
    dad.setPosition(286, 190);

    sky = new FlxSprite(-660, -925, getModImage('ChallengeEdd/sky'));
    sky.scale.set(1.5, 1.5);
    sky.scrollFactor.set(0.2, 0.2);
    insert(1, sky);

    var clouds:FlxSprite = new FlxSprite(-1060, -220, getModImage('ChallengeEdd/clouds'));
    clouds.scrollFactor.set(0.15, 0.15);
    insert(2, clouds);

    var parallax:FlxSprite = new FlxSprite(-710, 300, getModImage('ChallengeEdd/secParallax'));
    parallax.scrollFactor.set(0.75, 0.75);
    parallax.scale.set(1.5, 1.5);
    insert(3, parallax);

    var house:FlxSprite = new FlxSprite(-950, -50, getModImage('ChallengeEdd/house'));
    house.scale.set(1.5, 1.5);
    insert(4, house);

    var fence:FlxSprite = new FlxSprite(-390, 430, getModImage('ChallengeEdd/fence'));
    fence.scale.set(1.5, 1.5);
    insert(5, fence);

    var car:FlxSprite = new FlxSprite(-1210, 855, getModImage('ChallengeEdd/car'));
    car.scrollFactor.set(1.2, 1.2);
    car.scale.set(1.5, 1.5);
    add(car);
}

function Plane() {
    plane = new FlxSprite(1200, 0, getModImage('ChallengeEdd/plane'));
    plane.scrollFactor.set(0.2, 0.2);
    plane.scale.set(1.5, 1.5);
    insert(3, plane);

    FlxTween.tween(plane, {x: 1900}, 10, {onComplete: () -> remove(plane) });
}

function stepHit() {
    switch(curStep) {
        case 380: Plane();
    }
}