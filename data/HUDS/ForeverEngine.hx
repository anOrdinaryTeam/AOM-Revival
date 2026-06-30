import flixel.text.FlxTextBorderStyle;
public var hudItems:FlxTypedGroup<Dynamic> = new FlxTypedGroup();

var ratingsInt:Map<String, Int> = ["sick" => 0, "good" => 0, "bad" => 0, "shit" => 0];
var ratingFix:String;

var missNumScale:Float;
var missRatingScale:Float;

function onHudLoad(hud) if (hud == 'ForeverEngine') {
    hudItems.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, hudItems);

    var score:FunkinText = new FunkinText(0, Math.floor(healthBarBG.y + 40), 0, 'Score: 0 • Accuracy: 0% • ${getSaveData('Forever_MissType')}: 0 • Rank: F', 20);
    score.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5);
    score.screenCenter(FlxAxes.X);
    hudItems.add(score);

    var cornerMark:FunkinText = new FunkinText(0, 0, 0, getSaveData('Forever_Watermark') ? 'FOREVER ENGINE v0.3.1' : Flags.VERSION_MESSAGE.toUpperCase());
    cornerMark.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
    cornerMark.setPosition(FlxG.width - (cornerMark.width + 5), 5);
    hudItems.add(cornerMark);

    if (getSaveData('Forever_Info')) {
        var centerMark:FunkinText = new FunkinText(0, 0, 0, '- ${PlayState.SONG.meta?.name} [${curDiff.toUpperCase()}] -');
        centerMark.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
        hudItems.add(centerMark);

        centerMark.y = (FlxG.height / 24) - 24;
        centerMark.screenCenter(FlxAxes.X);

        centerMark.alpha = getSaveData('Forever_Opacity');
    }

    for (i in [healthBar, healthBarBG, iconP1, iconP2, score, cornerMark])
        i.alpha = getSaveData('Forever_Opacity');

    for (i in cpuStrums)    i.alpha = getSaveData('Forever_Opacity');
    for (i in cpu.notes)    i.alpha = getSaveData('Forever_Opacity');
    for (i in playerStrums) i.alpha = getSaveData('Forever_Opacity');
    for (i in player.notes) i.alpha = getSaveData('Forever_Opacity');

    scripts.call('postHudLoad');
}

function update() for (icons in [iconP1, iconP2]) {
	icons.setGraphicSize(Std.int(FlxMath.lerp(150, icons.width, .5)));
	icons.updateHitbox();
}

function beatHit() for (icons in [iconP1, iconP2]) {
    icons.setGraphicSize(Std.int(icons.width + 45));
    icons.updateHitbox();
}

function onRatingUpdate(_) {
    hudItems.members[0]?.text = 'Score $songScore • Accuracy: ${CoolUtil.quantize(accuracy * 100, 100)}% ';

    if (getSaveData('Forever_Ratings') && misses == 0)
        hudItems.members[0]?.text += '${getRating()} ';

    hudItems.members[0]?.text += '• ${getSaveData('Forever_MissType')}: $misses • Rank: ${_.rating.rating}';
    hudItems.members[0]?.screenCenter(FlxAxes.X);
}

function getRating() {
    if (misses == 0 && ratingsInt['sick'] >= 1 && ratingsInt['good'] == 0 && ratingsInt['bad'] == 0 && ratingsInt['shit'] == 0)
        return '[SFC]';
    else if (misses == 0 && ratingsInt['good'] >= 1 && ratingsInt['bad'] == 0 && ratingsInt['shit'] == 0)
        return '[GFC]';
    else if (misses == 0)
        return '[FC]';
}

function onPlayerHit(_) {
    ratingsInt[_.rating] += 1;

    if (getSaveData('Forever_Splash'))
        _.note.splash = "Forever/forever";

    if (getSaveData('Forever_Combo') && _.note.strumTime < Conductor.songPosition)
        ratingFix = '-late';
    else 
        ratingFix = '-early';
}

function onRatingsShown(_) {
    if (!getSaveData('Forever_Combo')) return;

    if (accuracy == -1 || accuracy == 1)
        _.ratingPrefix = 'modCombos/ForeverEngine/';

    switch(_.rating) {
        case 'good' | 'bad' | 'shit':
            _.ratingPrefix = 'modCombos/ForeverEngine/';
            _.ratingSuffix = ratingFix;
    }
}

function onPlayerMiss()
    if (getSaveData('Forever_Miss'))
        createRatingMiss();

function createRatingMiss() {
    var fixMisses:Int = 1;
    fixMisses += misses;

    var shitScore = []; 
	if (fixMisses >= 1000)
        shitScore.push(Math.floor(fixMisses / 1000) % 10);
    if (fixMisses >= 100)
	    shitScore.push(Math.floor(fixMisses / 100) % 10);
    if (fixMisses >= 10)
	    shitScore.push(Math.floor(fixMisses / 10) % 10);

	shitScore.push(fixMisses % 10);

    var i = 0;
    for (n in shitScore) {
        var numScore:FlxSprite = new FlxSprite((43 * i) + comboGroup.x, comboGroup.y + 150);
        numScore.loadGraphic(Paths.image('game/score/num$n'));
        numScore.color = FlxColor.fromRGB(204, 66, 66);
 
		numScore.acceleration.y = FlxG.random.int(200, 300);
		numScore.velocity.y -= FlxG.random.int(140, 160);
		numScore.velocity.x = FlxG.random.float(-10, 10);

        numScore.scale.set(.5, .5);
		numScore.updateHitbox();
        
		numScore.antialiasing = Options.antialiasing;
        add(numScore);

		FlxTween.tween(numScore, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.002,
			onComplete: () -> remove(numScore, true)
		});

        i++;

        var line:FlxSprite = new FlxSprite(numScore.x - (43 * i), comboGroup.y + 150);
        line.loadGraphic(Paths.image('modCombos/ForeverEngine/line'));
        line.color = FlxColor.fromRGB(204, 66, 66);
    
        line.acceleration.y = FlxG.random.int(200, 300);
    	line.velocity.y -= FlxG.random.int(140, 160);
    	line.velocity.x = FlxG.random.float(-10, 10);
    
        line.scale.set(.5, .5);
        line.updateHitbox();
    
        line.antialiasing = Options.antialiasing;
        add(line);
    
		FlxTween.tween(line, {alpha: 0}, 0.2, {
            startDelay: Conductor.crochet * 0.002,
			onComplete: () -> remove(line, true)
		});
    }

    var rating:FlxSprite = new FlxSprite(comboGroup.x, comboGroup.y);
    rating.loadGraphic(Paths.image('modCombos/ForeverEngine/miss'));

    rating.acceleration.y = 550;
    rating.velocity.y -= FlxG.random.int(140, 175);
    rating.velocity.x -= FlxG.random.int(0, 10);

    rating.scale.set(.7, .7);
    rating.updateHitbox();

    rating.antialiasing = Options.antialiasing;
    add(rating);

    FlxTween.tween(rating, {alpha: 0}, 0.2, {
        startDelay: Conductor.crochet * 0.001,
        onComplete: () -> remove(rating, true)
    });
}