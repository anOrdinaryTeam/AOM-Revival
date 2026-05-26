import funkin.backend.system.macros.GitCommitMacro;
import flixel.text.FlxTextBorderStyle;

public var hudItems:FlxTypedGroup<Dynamic> = new FlxTypedGroup();

function onHudLoad(hud, ver) if (hud == 'ForeverEngine') {
    hudItems.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, hudItems);

    var scoreDisplay:String = 'beep bop bo skdkdkdbebedeoop brrapadop';
    var score:FunkinText = new FunkinText(0, Math.floor(healthBarBG.y + 40), 0, 'Score: 0 • Accuracy: 0% • Combo Breaks: 0 • Rank: F', 20);
    score.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5);
    score.screenCenter(FlxAxes.X);
    hudItems.add(score);

    var txtMark:String = getSaveData('Forever_WatermarkType') == 'FE' ? 'FOREVER ENGINE v$ver' : 'CODENAME ENGINE ${GitCommitMacro.commitHash}';
    var cornerMark:FunkinText = new FunkinText(0, 0, 0, txtMark);
    cornerMark.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
	cornerMark.setPosition(FlxG.width - (cornerMark.width + 5), 5);
    cornerMark.antialiasing = Options.antialiasing;
    hudItems.add(cornerMark);

    var centerMark:FunkinText = new FunkinText(0, 0, 0, '- ${PlayState.SONG.meta?.name} [${curDiff.toUpperCase()}] -');
    centerMark.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
    centerMark.y = (FlxG.height / 24) - 24;
    centerMark.antialiasing = Options.antialiasing;
    centerMark.screenCenter(FlxAxes.X);
    hudItems.add(centerMark);

    scripts.call('postHudLoad');
}

function onRatingUpdate(_) {
    var str = 'Score: $songScore • Accuracy: ${CoolUtil.quantize(accuracy * 100, 100)}% ${getAccuracyLetter()} • Combo Breaks: $misses • Rank: ${getRankLetter(CoolUtil.quantize(accuracy * 100, 100))}';
    hudItems.members[0]?.text = str;
    hudItems.members[0]?.screenCenter(FlxAxes.X);
}

var ratingsInt:Map<String, Int> = ["sick" => 0, "good" => 0, "bad" => 0, "shit" => 0];
function onPlayerHit(_) {
    ratingsInt[_.rating] += 1;

    trace(ratingsInt);
}
function getAccuracyLetter() {
    var rating:String = '';
    
    if (misses == 0 && ratingsInt['sick'] >= 1 && ratingsInt['good'] == 0 && ratingsInt['bad'] == 0 && ratingsInt['shit'] == 0)
        rating = '[SFC]';
    else if (misses == 0 && ratingsInt['good'] >= 1 && ratingsInt['bad'] == 0 && ratingsInt['shit'] == 0)
        rating = '[GFC]';
    else if (misses == 0)
        rating = '[FC]';
    else 
        rating = '';
}

function getRankLetter(rank) {
    var rating:String = '';

    var scoreRank:Array<Bool> = [
        rank >= 100,
        rank >= 95,
        rank >= 90,
        rank >= 85,
        rank >= 80,
        rank >= 75,
        rank >= 70,
        rank >= 65
    ];

    for (i in 0...scoreRank.length) {
        var shit = scoreRank[i];

        if (shit) {
            switch(i) {
                case 0: rating += 'S+';
                case 1: rating += 'S';
                case 2: rating += 'A';
                case 3: rating += 'B';
                case 4: rating += 'C';
                case 5: rating += 'D';
                case 6: rating += 'E';
                case 6: rating += 'F';
            }
            break;
        }
    }
    return rating;
}