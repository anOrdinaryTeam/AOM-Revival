import flixel.text.FlxTextBorderStyle;
import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import flixel.util.FlxStringUtil;

public var hudItems:FlxTypedGroup<Dynamic> = new FlxTypedGroup();
var fuckingcomboCamera:FlxCamera = new FlxCamera();
var Settings:Map<String, Dynamic> = [
    "hide" => !getSaveData('Psych_HideHud'),
    "opacity" => getSaveData('Psych_HudOpacity'),
    "tweenScoreTxt" => getSaveData('Psych_BopScore'),
    "timeBarType" => getSaveData('Psych_TimeBarType'),
];

var lengthSong:String = '';

doIconBop = false;

function onHudLoad(hud) if (hud == 'PsychEngine') {
    fuckingcomboCamera.bgColor = 0;
    FlxG.cameras.insert(fuckingcomboCamera, 1, false);
    PlayState.instance.comboGroup.x -= 200;

    hudItems.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, hudItems);

    for (i in [healthBar, healthBarBG, iconP1, iconP2])
        i.alpha = Settings["opacity"];

    var offsetY:Float = downscroll ? healthBarBG.y - 56 : healthBarBG.y + 35;
    var score:FlxText = new FlxText(0, offsetY, FlxG.width, 'Score: 0 | Misses: 0 | Rating: ?', 20);
    score.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    score.scrollFactor.set();
	score.borderSize = 1.25;
	score.visible = Settings["hide"];
	score.active = false;
    hudItems.add(score);

    if (Settings["timeBarType"] != 'disabled') {
        var timeBarBG:FlxSprite = new FlxSprite(0,0, Paths.image('psych_timeBar'));
        timeBarBG.screenCenter(FlxAxes.X);
        timeBarBG.y = (0 - timeBarBG.height) + 40;
        timeBarBG.alpha = 0;
        hudItems.add(timeBarBG);
    
        var timeBar:FlxBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, FlxBarFillDirection.LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), inst,
            'time', 0, inst.length);
        timeBar.scrollFactor.set();
        timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
        timeBar.numDivisions = timeBar.width;
        timeBar.unbounded = getSaveData('Psych_SmoothTimeBar');
        timeBar.alpha = 0;
        hudItems.add(timeBar);

        var songNameBool:Bool = Settings["timeBarType"] == 'songName' ? true : false;
        var offsettxt:Float = songNameBool ? 6 : 10;

        var timeTxt:FlxText = new FlxText(0, timeBar.y - offsettxt, 400, songNameBool ? songName : "", 32);
        timeTxt.setFormat(Paths.font("vcr.ttf"), songNameBool ? 24 : 32, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        timeTxt.scrollFactor.set();
        timeTxt.screenCenter(FlxAxes.X);
        timeTxt.alpha = 0;
        timeTxt.borderSize = 2;
        timeTxt.active = false;
        hudItems.add(timeTxt);
    }

    lengthSong = FlxStringUtil.formatTime(inst.length / 1000, false);
    scripts.call('postHudLoad');
}

function onSongStart() if (Settings["timeBarType"] != 'disabled')
    for (i in [1,2,3]) if (hudItems.members[i] != null)
        FlxTween.tween(hudItems.members[i], {alpha: 1}, 0.5, {ease: FlxEase.circOut});

var ratingStuff:Array<Dynamic> = [
    ['You Suck!', 0.2], 
    ['Shit', 0.4],
    ['Bad', 0.5], 
    ['Bruh', 0.6],
    ['Meh', 0.69],
    ['Nice', 0.7],
    ['Good', 0.8],
    ['Great', 0.9],
    ['Sick!', 1], 
    ['Perfect!!', 1]
];
var ratingsInt:Map<String, Int> = ["sick" => 1, "good" => 0.75, "bad" => 0.5, "shit" => 0];
var ratingsInt_2:Map<String, Int> = ["sick" => 0, "good" => 0, "bad" => 0, "shit" => 0];

var totalNotesHit:Float = 0.0;
var totalPlayed:Int = 0;
var ratingPercent:Float = 0;
var ratingName:String = '';

var scoreTxtTween:FlxTween;

function onPlayerHit(_) if (!_.note.isSustainNote) {
    totalNotesHit += ratingsInt[_.rating];
    ratingsInt_2[_.rating] += 1;
    bopScoreTxt(Settings["tweenScoreTxt"]);
}

function bopScoreTxt(bop:Bool) {
    if (!bop) return;
    if(scoreTxtTween != null) scoreTxtTween.cancel();
    hudItems.members[0].scale.set(1.075, 1.075);
    scoreTxtTween = FlxTween.tween(hudItems.members[0].scale, {x: 1, y: 1}, 0.2, {onComplete: () -> scoreTxtTween = null});
}

function updateRatingCombo() {
    totalPlayed++;
    ratingPercent = Math.min(1, Math.max(0, totalNotesHit / totalPlayed));
    
    if(ratingPercent >= 1)
        ratingName = ratingStuff[ratingStuff.length-1][0];
    else {
        for (i in 0...ratingStuff.length-1)
            if(ratingPercent < ratingStuff[i][1]) {
                ratingName = ratingStuff[i][0];
                break;
            }
    }

    if (ratingsInt_2["sick"] > 0) ratingFC = "SFC";
    if (ratingsInt_2["good"] > 0) ratingFC = "GFC";
    if (ratingsInt_2["bad"] > 0 || ratingsInt_2["shit"] > 0) ratingFC = "FC";
    if (misses > 0 && misses < 10) ratingFC = "SDCB";
    else if (misses > 10) ratingFC = "Clear"; // die
}
    
function onRatingUpdate(_) {
    updateRatingCombo();
    var str:String = 'Score: ' + songScore + ' | Misses: ' + misses + ' | Rating: ' + ratingName + ' (' + CoolUtil.quantize(accuracy * 100, 100) + '%)' + ' - ' + ratingFC;
    hudItems.members[0].text = str;
}

function update(_) {
    var lerpVal = Math.max(0, Math.min(1, 1 - (_ * 9)));
    for (icons in [iconP1, iconP2]) {
        var mult:Float = CoolUtil.fpsLerp(1, icons.scale.x, lerpVal);
	    icons.scale.set(mult, mult);
	    icons.updateHitbox();
    }

    if (!startingSong && Settings["timeBarType"] != 'songName') {
        var fullStr:String = '';
        var timeTxt:FlxText = hudItems.members[3];

        if (Settings["timeBarType"] != 'all') {
            var songCalc:Float = Settings["timeBarType"] == 'timeLeft' ? (inst.length - Conductor.songPosition) : Conductor.songPosition;
            var secondsTotal:Int = Math.floor(songCalc / 1000);
            if(secondsTotal < 0) secondsTotal = 0;

            fullStr = FlxStringUtil.formatTime(secondsTotal, false);
        }
        else {

            var timeElapsed:Int = Math.floor(Conductor.songPosition / 1000);
            if (timeElapsed < 0) secondsTotal = 0;

            var timeElapsedStr:String = FlxStringUtil.formatTime(timeElapsed, false);
            fullStr = '$songName - ($timeElapsedStr / $lengthSong)';

            var timeBar:FlxSprite = hudItems.members[1];
            timeTxt.size = (fullStr.length / 2) * 1.5;
            timeTxt.y = (timeBar.y + (timeBar.height - timeTxt.height) / 2);
        }

        timeTxt.text = fullStr;
    }
}

function postUpdate()
    PlayState.instance.comboGroup.cameras = [fuckingcomboCamera];

function beatHit() for (i in [iconP1, iconP2]) {
    i.scale.set(1.2, 1.2);
    i.updateHitbox();
}