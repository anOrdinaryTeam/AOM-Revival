import flixel.text.FlxTextBorderStyle;

var curShit:Int = 0;
var stepShit:Array<Int> = [3, 18, 34, 51, 67, 83, 99, 108, 115, 119, 123, 128];
var shit:Array<Array<Dynamic>> = [
    ['set', 'Are we gonna have a problem?'],
    ['set', "You've got a bone to pick?"],
    ['set', "You've come so far. Why now"],
    ['sung', 'are you pulling on my D*ck!?'],
    ['set', "I'd normally slap your face off..."],
    ['sung', '..and everyone here could watch!'],
    ['set', "but I'm feeling nice,"],
    ['sung', "here's some advice:"],
    ['set', 'listen'],
    ['sung', 'UP'],
    ['set', 'BIATCH!!!'],
    ['set', '']
];

function stepHit() if (stepShit.contains(curStep)) {
    setLyric(shit[curShit][0], shit[curShit][1]);
    curShit++;
}

var lyric:FlxText = new FlxText(0, 0, 0, '', 30);
var otherLyric:FlxText = new FlxText(0, 0, 0, '', 30);
var camLyrics:FlxCamera = new FlxCamera();

function postCreate() {
    camLyrics.bgColor = 0;
    FlxG.cameras.add(camLyrics, false);

    lyric.font = Paths.font('cheri.ttf');
    lyric.camera = camLyrics;
    lyric.borderStyle = FlxTextBorderStyle.OUTLINE;
    lyric.borderColor = FlxColor.BLACK;
    lyric.borderSize = 2;
    lyric.screenCenter();
    lyric.y += 180;
    lyric.antialiasing = true;
    add(lyric);

    otherLyric.font = Paths.font('cheri.ttf');
    otherLyric.camera = camLyrics;
    otherLyric.borderColor = FlxColor.BLACK;
    otherLyric.borderStyle = FlxTextBorderStyle.OUTLINE;
    otherLyric.borderColor = FlxColor.BLACK;
    otherLyric.borderSize = 2;
    otherLyric.screenCenter();
    otherLyric.y += 180 + (30 + 10);
    otherLyric.antialiasing = true;
    add(otherLyric);
}

function setLyric(type:String, str:String) switch(type) {
    default:
        lyric.text = str;
        lyric.screenCenter(FlxAxes.X);
        otherLyric.text = '';
    case 'sung':
        otherLyric.text = str;
        otherLyric.screenCenter(FlxAxes.X);
}