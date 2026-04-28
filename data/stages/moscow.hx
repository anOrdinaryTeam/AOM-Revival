// var pruner:FunkinSprite;
// var camFollowPos = new FlxPoint();

// // function onStartCountdown() {
// //     FlxG.camera.follow(camFollowPos);
// //     camFollowPos.setPosition(350, -700);

// //     camHUD.alpha = 0.001;
// // }

function create() {
    useStageData == false;
    
    vocals.volume = 0; // FUCK V-SLICE CHART

    var bg:FlxSprite = new FlxSprite(-1100, -975, getModImage('Moscow/bg'));
    bg.scrollFactor.set(0.8, 0.8);
    insert(1, bg);

    var casa:FlxSprite = new FlxSprite(-1100, -975, getModImage('Moscow/casa'));
    casa.scrollFactor.set(0.9, 0.9);
    insert(2, casa);

    pruner = new FunkinSprite(1980, 0).loadSprite(getModImage('Moscow/pruner'));
    add(pruner);

    pruner.addAnim('idle', 'lawn', 24, true);
    pruner.playAnim('idle');

    pruner.scale.set(1.5, 1.5);
    pruner.scrollFactor.set(1.2, 1.2);

    pruner.alpha = 0.001;
}