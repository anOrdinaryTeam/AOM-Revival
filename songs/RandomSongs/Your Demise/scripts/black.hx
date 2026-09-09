var black:FlxSprite;

function create() {
    black = new FlxSprite(0, 0).makeGraphic(1280, 720, 0xFF000000);
    black.scrollFactor.set();
    add(black);

    // PUTA MADRE CNE ANDATE AL CARAJO Y MUERE
    if (members.indexOf(comboGroup) < members.indexOf(black)) {
        remove(comboGroup);
        add(comboGroup);
    }
}

function beatHit(curBeat:Int) {
    if (curBeat == 33) {
        FlxTween.tween(black, {alpha: 0}, 0.15, {ease: FlxEase.linear});
    }
    if (curBeat == 223) {
        FlxTween.tween(black, {alpha: 1}, 1.25, {ease: FlxEase.linear});
    }
}
