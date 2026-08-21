import AomText;

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
    ['remove', '']
];

function stepHit() if (stepShit.contains(curStep)) {
    setLyric(shit[curShit][0], shit[curShit][1]);
    curShit++;
}

var size:Float = 0.4;
var borSize:Int = 5;

var lyric:AomText = new AomText(0, 0, '', size, 'Cherri');
var otherLyric:AomText = new AomText(0, 0, '', size, 'Cherri');
var camLyrics:FlxCamera = new FlxCamera();

function postCreate() {
    camLyrics.bgColor = 0;
    FlxG.cameras.add(camLyrics, false);

    lyric.setFormat(-1, 'center', 'outline', borSize, FlxColor.BLACK);
    lyric.camera = camLyrics;
    lyric.screenCenter();
    lyric.y += 180;
    add(lyric);

    otherLyric.setFormat(-1, 'center', 'outline', borSize, FlxColor.BLACK);
    otherLyric.camera = camLyrics;
    otherLyric.screenCenter();
    otherLyric.y += 180 + (30 + 10);
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
    case 'remove':
        remove(lyric);
        remove(otherLyric);
}