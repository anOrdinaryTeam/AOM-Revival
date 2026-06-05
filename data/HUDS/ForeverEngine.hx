import funkin.backend.system.macros.GitCommitMacro;
import flixel.text.FlxTextBorderStyle;

public var hudItems:FlxTypedGroup<Dynamic> = new FlxTypedGroup();

var ratingsInt:Map<String, Int> = ["sick" => 0, "good" => 0, "bad" => 0, "shit" => 0];

var missNumScale:Float;
var missRatingScale:Float;

var isGold:Bool = true;

function onHudLoad(hud) if (hud == 'ForeverEngine') {
    hudItems.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, hudItems);

    var score:FunkinText = new FunkinText(0, Math.floor(healthBarBG.y + 40), 0, 'Score: 0 • Accuracy: 0% • ${getSaveData('Forever_MissType')}: 0 • Rank: F', 20);
    score.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5);
    score.screenCenter(FlxAxes.X);
    hudItems.add(score);

    var txtMark:String = getSaveData('Forever_Watermark') ? 'FOREVER ENGINE v0.3.1' : 'CODENAME ENGINE ${GitCommitMacro.commitHash}';
    var cornerMark:FunkinText = new FunkinText(0, 0, 0, txtMark);
    cornerMark.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
	cornerMark.setPosition(FlxG.width - (cornerMark.width + 5), 5);
    cornerMark.antialiasing = Options.antialiasing;
    hudItems.add(cornerMark);

    if (getSaveData('Forever_Info')) {
        var centerMark:FunkinText = new FunkinText(0, 0, 0, '- ${PlayState.SONG.meta?.name} [${curDiff.toUpperCase()}] -');
        centerMark.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
        centerMark.y = (FlxG.height / 24) - 24;
        centerMark.antialiasing = Options.antialiasing;
        centerMark.screenCenter(FlxAxes.X);
        centerMark.alpha = getSaveData('Forever_Opacity');
        hudItems.add(centerMark);
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

    isGold = (accuracy == -1 || accuracy == 1);
}

function beatHit() for (icons in [iconP1, iconP2]) {
    icons.setGraphicSize(Std.int(icons.width + 45));
    icons.updateHitbox();
}

function onRatingUpdate(_) {
    var quanAcc:Float = CoolUtil.quantize(accuracy * 100, 100);
    var str = 'Score: $songScore • Accuracy: $quanAcc% ${getAccuracyLetter()} • ${getSaveData('Forever_MissType')}: $misses • Rank: ${getRankLetter(quanAcc, _)}';
    hudItems.members[0]?.text = str;
    hudItems.members[0]?.screenCenter(FlxAxes.X);
}

function onPlayerHit(_) {    
    ratingsInt[_.rating] += 1;

    if (getSaveData('Forever_Combo')) {
        _.displayRating = _.showRating = false;

        if (!_.note.isSustainNote)
            createRating(_);

        missNumScale = _.numScale; 
        missRatingScale = _.ratingScale;
    }
    if (getSaveData('Forever_Splash'))
        _.note.splash = "Forever/forever";
}

function onPlayerMiss()
    if (getSaveData('Forever_Miss'))
        createRatingMiss();

function getAccuracyLetter() {
    var rating:String = '';

    if (getSaveData('Forever_Ratings')) {
        if (misses == 0 && ratingsInt['sick'] >= 1 && ratingsInt['good'] == 0 && ratingsInt['bad'] == 0 && ratingsInt['shit'] == 0)
            rating = '[SFC]';
        else if (misses == 0 && ratingsInt['good'] >= 1 && ratingsInt['bad'] == 0 && ratingsInt['shit'] == 0)
            rating = '[GFC]';
        else if (misses == 0)
            rating = '[FC]';
        else 
            rating = '';
    }

    return rating;
}

function getRankLetter(rank, cneRating) {
    if (getSaveData('Forever_Ratings')) {
        if (rank >= 100) return 'S+';
        if (rank >= 95)  return 'S';
        if (rank >= 90)  return 'A';
        if (rank >= 85)  return 'B';
        if (rank >= 80)  return 'C';
        if (rank >= 75)  return 'D';
        if (rank >= 70)  return 'E';
        if (rank >= 65)  return 'F';
    }
    else {
        rank = cneRating.rating.rating;
    }
    return rank;
}

function createRating(shit) {
    var shitScore = []; 
	if (combo >= 1000)
        shitScore.push(Math.floor(combo / 1000) % 10);
    if (combo >= 100)
	    shitScore.push(Math.floor(combo / 100) % 10);
    if (combo >= 10)
	    shitScore.push(Math.floor(combo / 10) % 10);

    if (combo == 0) combo = 1;
	shitScore.push(combo % 10);

    var i = 0;
    for (n in shitScore) {
        var numScore:FlxSprite = new FlxSprite((43 * i) + comboGroup.x, comboGroup.y + 150);
        numScore.loadGraphic(Paths.image((isGold ? 'modCombos/ForeverEngine/num$n' : 'game/score/num$n')));
 
		numScore.acceleration.y = FlxG.random.int(200, 300);
		numScore.velocity.y -= FlxG.random.int(140, 160);
		numScore.velocity.x = FlxG.random.float(-10, 10);

        numScore.scale.set(shit.numScale, shit.numScale);
		numScore.updateHitbox();
        
		numScore.antialiasing = Options.antialiasing;
        add(numScore);

		FlxTween.tween(numScore, {alpha: 0}, 0.2, {
            startDelay: Conductor.crochet * 0.002,
			onComplete: () -> destroitSmash(numScore)
		});
        i++;
    }

    var rating:FlxSprite = new FlxSprite(comboGroup.x, comboGroup.y);
    rating.loadGraphic(Paths.image((isGold ? 'modCombos/ForeverEngine/sick' : 'game/score/sick')));

    var ratingSuffix:String = '';
    if (shit.note.strumTime < Conductor.songPosition)
        ratingSuffix = 'late';
    else
        ratingSuffix = 'early';

    if (shit.rating != 'sick')
        rating.loadGraphic(Paths.image('modCombos/ForeverEngine/${shit.rating}-$ratingSuffix'));

    rating.acceleration.y = 550;
    rating.velocity.y -= FlxG.random.int(140, 175);
    rating.velocity.x -= FlxG.random.int(0, 10);

    rating.scale.set(shit.ratingScale, shit.ratingScale);
    rating.updateHitbox();

    rating.antialiasing = Options.antialiasing;
    add(rating);

    FlxTween.tween(rating, {alpha: 0}, 0.2, {
        startDelay: Conductor.crochet * 0.001,
        onComplete: () -> destroitSmash(rating)
    });
}

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

        numScore.scale.set(missNumScale, missNumScale);
		numScore.updateHitbox();
        
		numScore.antialiasing = Options.antialiasing;
        add(numScore);

		FlxTween.tween(numScore, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.002,
			onComplete: () -> destroitSmash(numScore)
		});

        i++;

        var line:FlxSprite = new FlxSprite(numScore.x - (43 * i), comboGroup.y + 150);
        line.loadGraphic(Paths.image('modCombos/ForeverEngine/line'));
        line.color = FlxColor.fromRGB(204, 66, 66);
    
        line.acceleration.y = FlxG.random.int(200, 300);
    	line.velocity.y -= FlxG.random.int(140, 160);
    	line.velocity.x = FlxG.random.float(-10, 10);
    
        line.scale.set(missNumScale, missNumScale);
        line.updateHitbox();
    
        line.antialiasing = Options.antialiasing;
        add(line);
    
		FlxTween.tween(line, {alpha: 0}, 0.2, {
            startDelay: Conductor.crochet * 0.002,
			onComplete: () -> destroitSmash(line)
		});
    }

    var rating:FlxSprite = new FlxSprite(comboGroup.x, comboGroup.y);
    rating.loadGraphic(Paths.image('modCombos/ForeverEngine/miss'));

    rating.acceleration.y = 550;
    rating.velocity.y -= FlxG.random.int(140, 175);
    rating.velocity.x -= FlxG.random.int(0, 10);

    rating.scale.set(missRatingScale, missRatingScale);
    rating.updateHitbox();

    rating.antialiasing = Options.antialiasing;
    add(rating);

    FlxTween.tween(rating, {alpha: 0}, 0.2, {
        startDelay: Conductor.crochet * 0.001,
        onComplete: () -> destroitSmash(rating)
    });
}