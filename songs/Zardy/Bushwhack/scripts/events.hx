var grabSteps:Array<Int> = [383, 768, 1151, 1536, 1905, 2466, 2767, 3071, 4143];
var hand:FlxSprite;
var otherHand:FlxSprite;
var mic:FlxSprite;

function postCreate() {
    precacheCharacter(0, 'Zardy/cablecrown');

    mic = new FlxSprite(dad.x + 70, dad.y - 85, getModImage('maze/Mic'));
    mic.setGraphicSize(Std.int(mic.width * 0.4));
    mic.antialiasing = Options.antialiasing;
    mic.alpha = 0.001;

    hand = new FlxSprite().loadGraphic(getModImage('maze/Arm0'));
    hand.setPosition(mic.x - hand.width, mic.y + 40);
    hand.setGraphicSize(Std.int(hand.width * 0.4));
    hand.antialiasing = Options.antialiasing;
    hand.alpha = 0.001;
    add(hand);

    otherHand = new FlxSprite(hand.x, hand.y, getModImage('maze/Grab'));
	otherHand.setGraphicSize(Std.int(otherHand.width * 0.4));
	otherHand.alpha = 0;
	add(otherHand);

    add(mic);
}

function stepHit() {
    if (grabSteps.contains(curStep))
        GRAB();

    switch(curStep) {
        case 1910:
            FlxTween.tween(iconP2, {alpha: 0.001}, 0.3);
            FlxTween.tween(dad, {alpha: 0.001}, 0.3);
            FlxTween.tween(mic, {alpha: 1}, 0.1);
        case 1920:
            var newX = dad.x - 1300;
			var newY = dad.y + 10;
            changeCharacter(0, 'Zardy/cablecrown');
            dad.setPosition(newX, newY);

            hand.alpha = 1;
            FlxTween.tween(hand, {x: mic.x - 2600}, 1, {onComplete: () -> {
                remove(hand, true);
                playModSound('cable_claw_impact');

                otherHand.x = hand.x - 335;
				otherHand.y = hand.y;
				otherHand.alpha = 1;
                mic.alpha = 0;

                playModSound('cable_claw_retract');
                FlxTween.tween(otherHand,{x: dad.x - 2700}, 0.8, {onComplete: cableSpawn});
            }});
    }        
}

function cableSpawn() {
    FlxTween.tween(FlxG.camera, {zoom: 1.6}, 1, {onComplete: () -> defaultCamZoom = 1.6});
    FlxTween.tween(dad, {x: rawJson.opponentPos[0] - 300}, 1);
    dad.alpha = 1;

    mic.alpha = 1;
    mic.x = dad.x;

    remove(otherHand, true);
    playModSound('micfuckinhit');

    FlxTween.tween(mic, {x: mic.x + 3400}, 2, {
        onUpdate: () -> {
            mic.angle += 4;

            if (mic.overlaps(boyfriend) && grabbedInput && health != 0) {
                playModSound('bf_mic_hit');
                FlxG.camera.flash(FlxColor.RED,1,null,true);
                health -= 999;
            }
        },
        onComplete: () -> {
            remove(mic, true);

            FlxTween.tween(FlxG.camera, {zoom: 0.7}, 0.4, {onComplete: () -> defaultCamZoom = 0.7});
            FlxTween.tween(iconP2, {alpha: 1}, 0.3);
        }
    });
}