import flixel.text.FlxTextBorderStyle;
import funkin.backend.system.macros.GitCommitMacro;
import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import flixel.util.FlxStringUtil;

public var hudItems:FlxTypedGroup<Dynamic> = new FlxTypedGroup();
var fuckingcomboCamera:FlxCamera = new FlxCamera();
var missesType:String = getSaveData('Kade_MissesType');
doIconBop = false;

// Made by @pharaotis in discord
var currentTimingShown:FunkinText = new FunkinText(0, 0, 0, "0ms", 20);
var tween:FlxTween = null;
var colors:Map<String, FlxColor> = [
    'shit' => FlxColor.RED,
    'bad' => FlxColor.RED,
    'good' => FlxColor.GREEN,
    'sick' => FlxColor.CYAN
];

function pharaotisMsTiming() {
    currentTimingShown.setFormat(null, 20, FlxColor.WHITE, null, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    currentTimingShown.setPosition(FlxG.width / 1.75, FlxG.height / 2.5); // change this to something else this was just a placeholder   
    currentTimingShown.alpha = 0;
    hudItems.add(currentTimingShown);
}

function onHudLoad(hud, ver) if (hud == 'KadeEngine') {
    fuckingcomboCamera.bgColor = 0;
    FlxG.cameras.insert(fuckingcomboCamera, 1, false);
    PlayState.instance.comboGroup.x -= 200;

    for (i in cpuStrums) i.x -= 45;
    for (i in playerStrums) i.x -= 45;
    
    hudItems.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, hudItems);

    var nameSong:String = PlayState.SONG.meta.displayName;

    var score:FunkinText = new FunkinText(FlxG.width / 2 - 235, downscroll ? healthBarBG.y - 45 : healthBarBG.y + 45, 0, "Score: 0 | " + missesType + ": 0 | Accuracy: N/A", 20);
    score.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
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

        var songName = new FlxText(timeBarBG.x + (timeBarBG.width / 2) - (nameSong.length * 5), timeBarBG.y, 0, nameSong, 16);
		songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, 'right', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songName.scrollFactor.set();
		hudItems.add(songName);
    }

    if (getSaveData('Kade_Watermark')) {
        var ke_Version:String = getSaveData('Kade_WatermarkType') == 'KE' ? ver : GitCommitMacro.commitHash;
        var str:String = '$nameSong - ${curDiff.toUpperCase()} | ${getSaveData('Kade_WatermarkType')}: $ke_Version';
        
        var watermark:FunkinText = new FunkinText(4, downscroll ? 5 : healthBarBG.y + 50, 0, str);
        watermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, 'right', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
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
    var str = 'Score: ' + songScore + ' | ' + missesType + ': ' + misses + ' | Accuracy: ' + CoolUtil.quantize(accuracy * 100, 100) + '%';
    if (getSaveData('Kade_Ratings')) str += ' | ' + getRankLetter(CoolUtil.quantize(accuracy * 100, 100), _.rating.rating);
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
        var wifeConditions:Array<Bool> = [
            acc >= 99.9935, // AAAAA
            acc >= 99.980, // AAAA:
            acc >= 99.970, // AAAA.
            acc >= 99.955, // AAAA
            acc >= 99.90, // AAA:
            acc >= 99.80, // AAA.
            acc >= 99.70, // AAA
            acc >= 99, // AA:
            acc >= 96.50, // AA.
            acc >= 93, // AA
            acc >= 90, // A:
            acc >= 85, // A.
            acc >= 80, // A
            acc >= 70, // B
            acc >= 60, // C
            acc < 60 // D
        ];

        for(i in 0...wifeConditions.length) {
            var b = wifeConditions[i];
            if (b) {
                switch(i) {
                    case 0: rating += " AAAAA";
                    case 1: rating += " AAAA:";
                    case 2: rating += " AAAA.";
                    case 3: rating += " AAAA";
                    case 4: rating += " AAA:";
                    case 5: rating += " AAA.";
                    case 6: rating += " AAA";
                    case 7: rating += " AA:";
                    case 8: rating += " AA.";
                    case 9: rating += " AA";
                    case 10: rating += " A:";
                    case 11: rating += " A.";
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
        rating += ' - ' + cneRating;

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