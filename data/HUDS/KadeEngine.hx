import funkin.backend.system.macros.GitCommitMacro;
import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import flixel.util.FlxStringUtil;
import AomText;

public var hudItems:FlxTypedGroup<Dynamic> = new FlxTypedGroup();
var fuckingcomboCamera:FlxCamera = new FlxCamera();
var missesType:String = getSaveData('Kade_MissesType');
doIconBop = false;

// Made by @pharaotis in discord
var currentTimingShown:AomText;
var tween:FlxTween = null;
var colors:Map<String, FlxColor> = [
    'shit' => FlxColor.RED,
    'bad' => FlxColor.RED,
    'good' => FlxColor.GREEN,
    'sick' => FlxColor.CYAN
];

function pharaotisMsTiming() {
    currentTimingShown = new AomText(FlxG.width / 1.75, FlxG.height / 2.5, '0ms', 0.3, 'Pixel');
    currentTimingShown.setFormat(-1, 'none', 'outline', 3, FlxColor.BLACK);
    currentTimingShown.alpha = 0;
    hudItems.add(currentTimingShown);
}

function onHudLoad(hud, ver) if (hud == 'KadeEngine') {
    fuckingcomboCamera.bgColor = 0;
    FlxG.cameras.insert(fuckingcomboCamera, 1, false);
    PlayState.instance.comboGroup.x -= 200;

    for (i => player in playerStrums.members) {
        player.x -= 45;
        cpu.members[i].x -= 45;
    }
    
    hudItems.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, hudItems);

    var nameSong:String = PlayState.SONG.meta.displayName;

    var score:AomText = new AomText(0, (downscroll ? healthBarBG.y - 45 : healthBarBG.y + 45), 'Score: 0 | $missesType: 0 | Accuracy: N/A', 0.22);
    score.setFormat(-1, 'center', 'OUTLINE', 6, FlxColor.BLACK);
    score.screenCenter(FlxAxes.X);
    score.scrollFactor.set();
    hudItems.add(score);

    if (getSaveData('Kade_Timebar')) {
        var timeBarBG:FlxSprite = new FlxSprite(0, 10, Paths.image('game/healthBar'));
        timeBarBG.screenCenter(FlxAxes.X);
        timeBarBG.scrollFactor.set();
        hudItems.add(timeBarBG);

        var timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, FlxBarFillDirection.LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), inst,
            'time', 0, inst.length);
        timeBar.scrollFactor.set();
        timeBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
        timeBar.numDivisions = timeBar.width;
        hudItems.add(timeBar);

        var songName:AomText = new AomText(timeBarBG.x + (timeBarBG.width / 2) - (nameSong.length * 5), timeBarBG.y - 2, nameSong, 0.23);
        songName.setFormat(-1, 'center', 'OUTLINE', 7, FlxColor.BLACK);
        songName.scrollFactor.set();
        hudItems.add(songName);
    }

    if (getSaveData('Kade_Watermark')) {
        var ke_Version:String = getSaveData('Kade_WatermarkType') == 'KE' ? ver : GitCommitMacro.commitHash;
        var str:String = '$nameSong - ${curDiff.toUpperCase()} | ${getSaveData('Kade_WatermarkType')}: $ke_Version';

        var watermark:AomText = new AomText(4, downscroll ? 5 : healthBarBG.y + 50, str, 0.23);
        watermark.setFormat(-1, 'right', 'OUTLINE', 7, FlxColor.BLACK);
        watermark.scrollFactor.set();
        hudItems.add(watermark);
    }

    if (getSaveData('Kade_HitMS'))
        pharaotisMsTiming();

    scripts.call('postHudLoad');
}

function update() for (icons in [iconP1, iconP2]) {
    icons.setGraphicSize(Std.int(CoolUtil.fpsLerp(150, icons.width, 0.50)));
    icons.updateHitbox();
}

function postUpdate()
    PlayState.instance.comboGroup.cameras = [fuckingcomboCamera];

function beatHit() for (icons in [iconP1, iconP2]) {
    var value:Float = (Conductor.bpm < 340) ? 30 : 4;
    icons.setGraphicSize(Std.int(icons.width + value));
	icons.updateHitbox();
}

var ratingsInt:Map<String, Int> = ["sick" => 0, "good" => 0, "bad" => 0, "shit" => 0];
function onPlayerHit(_) {
    ratingsInt[_.rating] += 1;

    if (getSaveData('Kade_HitMS') && !_.note.isSustainNote && _.player)
        showMS(_);
}

function onRatingUpdate(_) {
    var str = 'Score: $songScore | $missesType: $misses | Accuracy: ${CoolUtil.quantize(accuracy * 100, 100)}%';
    if (getSaveData('Kade_Ratings'))
        str += ' | ${getRankLetter(CoolUtil.quantize(accuracy * 100, 100), _.rating.rating)}';

    hudItems.members[0]?.text = str;
    hudItems.members[0]?.screenCenter(FlxAxes.X);
}

function getRankLetter(acc:Float, cneRating:String) {
    var rating:String = 'N/A';

    if (misses == 0 && ratingsInt["sick"] == 0 && ratingsInt["good"] == 0 && ratingsInt["bad"] == 0 && ratingsInt["shit"] == 0)
        rating = '(MFC)';
    else if (misses == 0 && ratingsInt["bad"] == 0 && ratingsInt["shit"] == 0 && ratingsInt["good"] >= 1)
        rating = "(GFC)";
    else if (misses == 0)
        rating = "(FC)";
    else if (misses < 10)
        rating = "(SDCB)";
    else
        rating = "(Clear)";

    if (getSaveData('Kade_RatingType') == 'KE') {
        var wifeConditions:Array<Bool> = [acc >= 99.9935, acc >= 99.980, acc >= 99.970, acc >= 99.955, 
            acc >= 99.90, acc >= 99.80, acc >= 99.70, acc >= 99, acc >= 96.50, acc >= 93, acc >= 90,
            acc >= 85, acc >= 80, acc >= 70, acc >= 60, acc < 60 
        ];

        for(i in 0...wifeConditions.length) {
            var b = wifeConditions[i];
            if (b) {
                switch(i) {
                    case 0: rating += " AAAAA";
                    case 1: rating += " AAAA";
                    case 2: rating += " AAAA";
                    case 3: rating += " AAAA";
                    case 4: rating += " AAA";
                    case 5: rating += " AAA";
                    case 6: rating += " AAA";
                    case 7: rating += " AA";
                    case 8: rating += " AA";
                    case 9: rating += " AA";
                    case 10: rating += " A";
                    case 11: rating += " A";
                    case 12: rating += " A";
                    case 13: rating += " B";
                    case 14: rating += " C";
                    case 15: rating += " D";       
                }
                break;
            }
        }
    }
    else
        rating += ' - $cneRating';

    // this is kade engine
    return rating;
}

function showMS(e) {
    var msTiming:Float = trunucateFloat(-(e.note.strumTime - Conductor.songPosition), 0);
    currentTimingShown.alpha = 1;
    currentTimingShown.color = colors[e.rating];
    currentTimingShown.text = msTiming + "ms";

    tween?.cancel();
	tween = FlxTween.tween(currentTimingShown, {alpha: 0}, 0.2, {
		startDelay: Conductor.crochet * 0.001,
		onComplete: () -> tween = null
	});
}

function trunucateFloat(number:Float, precision:Int):Float
{
    var num = number;
    num = num * Math.pow(10, precision);
    num = Math.round(num) / Math.pow(10, precision);
    return num;
}