// Made by @pharaotis in discord
import flixel.text.FlxTextBorderStyle;

var currentTimingShown:FunkinText = new FunkinText(0, 0, 0, "0ms", 20);
var tween:FlxTween = null;

function postCreate() 
{
    currentTimingShown.setFormat(null, 20, FlxColor.WHITE, null, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    currentTimingShown.setPosition(FlxG.width / 1.75, FlxG.height / 2.5); // change this to something else this was just a placeholder   
    currentTimingShown.alpha = 0;

    currentTimingShown.camera = camHUD;
    add(currentTimingShown);
}

function onNoteHit(e:NoteHitEvent)
{
    if (e.player && !e.note.isSustainNote)
    {
        var colors:Map<String, FlxColor> = [
            'shit' => FlxColor.RED,
            'bad' => FlxColor.RED,
            'good' => FlxColor.GREEN,
            'sick' => FlxColor.CYAN
        ];

        var msTiming = trunucateFloat(-(e.note.strumTime - Conductor.songPosition), 0);

        currentTimingShown.alpha = 1;
        currentTimingShown.color = colors[e.rating];
        currentTimingShown.text = msTiming + "ms";

        if (tween != null)
            tween.cancel();

		tween = FlxTween.tween(currentTimingShown, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001,
			onComplete: () -> {
                tween = null;
			}
		});
    }
}

function trunucateFloat(number:Float, precision:Int):Float
{
    var num = number;
    num = num * Math.pow(10, precision);
    num = Math.round(num) / Math.pow(10, precision);
    return num;
}