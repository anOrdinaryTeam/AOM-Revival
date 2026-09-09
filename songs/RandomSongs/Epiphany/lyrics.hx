import flixel.text.FlxTextBorderStyle;

var wasBeated:Bool = false;
var lyics:FlxText;
var lyricData:Array<Dynamic> = [];

function postCreate() {
    lyrics = new FlxText();
    lyrics.setFormat(Paths.font('GoNotoCurrent.ttf'), 32, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    lyrics.y = (FlxG.height * 0.72);
    lyrics.screenCenter(FlxAxes.X);

    lyrics.fieldWidth = FlxG.width;
    lyrics.borderSize = 1.25;

    lyrics.camera = camHUD;
    lyrics.antialiasing = Options.antialiasing;
    add(lyrics);

    var lyricFile = CoolUtil.coolTextFile(Paths.file('songs/Epiphany/lyrics.txt'));
    for (lyric in lyricFile) {
        var data:Array<String> = lyric.split('::');
        lyricData.push([Std.parseInt(data[0]), data[1]]);
    }
}

function stepHit() {
    for (i in 0...lyricData.length) {
        if (curStep == lyricData[i][0]) {
            lyrics.text = lyricData[i][1];
            lyrics.screenCenter(FlxAxes.X);
        }
	}
}

function beatHit() {
    switch(curBeat) {
        case 783:
            dad.playAnim('lastNOTE_end', true, false, 0, 'LOCK');
            dad.animation.finishCallback = function(name:String) {
                if (name == 'lastNOTE_end')
                    dad.visible = false;
            }
        case 788:
            for (i in cpu) FlxTween.tween(i, {alpha: 0}, 0.25, {ease: FlxEase.sineOut});
    }
}