import flixel.text.FlxBitmapText;

var trickyLine:FlxBitmapText;
var tstatic:FlxSprite;
var lastStep:Int = 0;
var curID:Int;

var rendered:Bool = false;
var spawnOnDad:Bool = true;
var spawnOnMiss:Bool = true;

var probablyText:Map<String, Float> = [
    "Tricky/tricky-mask" => 1, "Tricky/tricky" => 20, 
    "Tricky/trickyH" => 45, "Tricky/trickyEx" => 60
];
var TrickyLinesArray:Array<Array<String>> = [
    ["SUFFER","INCORRECT", "INCOMPLETE", "INSUFFICIENT", "INVALID", "CORRECTION", "MISTAKE", "REDUCE", "ERROR", "ADJUSTING", "IMPROBABLE", "IMPLAUSIBLE", "MISJUDGED"],
    ["YOU AREN'T HANK", "WHERE IS HANK", "HANK???", "WHO ARE YOU", "WHERE AM I", "THIS ISN'T RIGHT", "MIDGET", "SYSTEM UNRESPONSIVE", "WHY CAN'T I KILL?????"],
    ["TERRIBLE", "WASTE", "MISS CALCULTED", "PREDICTED", "FAILURE", "DISGUSTING", "ABHORRENT", "FORESEEN", "CONTEMPTIBLE", "PROGNOSTICATE", "DISPICABLE", "REPREHENSIBLE"]
];

function postCreate() {
    var scaleSize:Float = switch(songName) {
        default: 1.6;
        case 'Expurgation': 2.5;
        case 'HELLCLOWN': 5;
    };

    trickyLine = new FlxBitmapText(0, 0, '', getBitmapFont('Impact'));
    trickyLine.color = FlxColor.RED;
    trickyLine.antialiasing = true;
    trickyLine.scale.set(scaleSize, scaleSize);
    trickyLine.updateHitbox();
    add(trickyLine);

    var scale:Float = curSong == 'hellclown' ? 12 : 8.3;
    tstatic = new FlxSprite().loadGraphic(Paths.image('TrickyStatic'), true, 320, 180);
    tstatic.antialiasing = true;
    tstatic.scrollFactor.set(0,0);
    tstatic.setGraphicSize(Std.int(tstatic.width * scale));
    tstatic.animation.add('static', [0, 1, 2], 24, true);
    tstatic.animation.play('static');
    tstatic.alpha = curStage == 'auditorHell' ? 0.1 : 0;
    if (curSong == 'hellclown' || curSong == 'expurgation') {
        tstatic.x += 600;
        tstatic.y += 300;
    }
    else if (curSong == 'accelerant')
        tstatic.x += 600;

    add(tstatic);
    curID = dad.curCharacter == 'exTricky' ? 1 : 0;

    if (curSong == 'accelerant')
        spawnOnDad = spawnOnMiss = false;
}

public function customLine(text:String, offX:Float, offY:Float) {
    lastStep = curStep;
    rendered = true;
    trickyLine.visible = true;

    playSound('staticSound');
    trickyLine.setPosition(offX, offY);
	trickyLine.text = text;
    tstatic.alpha = 0.5;
}

function createTrickyLine(text:String) if (!rendered) {
    lastStep = curStep;
    rendered = true;
    trickyLine.visible = true;

    playSound('staticSound');
    trickyLine.setPosition(FlxG.random.float(dad.x + 40, dad.x + 120), FlxG.random.float(dad.y + 200, dad.y + 300));
	trickyLine.text = text;
    tstatic.alpha = 0.5;
}

function stepHit() if (rendered && lastStep + 3 < curStep) {
    trickyLine.visible = false;
    rendered = false;
    tstatic.alpha = curStage == 'auditorHell' ? 0.1 : 0;
}

function update() if (rendered) {
    trickyLine.angle = FlxG.random.int(-5, 5);
    if (tstatic.alpha != 0) tstatic.alpha = FlxG.random.float(0.1,0.5);
}

function onDadHit(_) {
    if (_.character.curCharacter == boyfriend.curCharacter) return;
    if (!_.note.isSustainNote && spawnOnDad)
        if (FlxG.random.bool(probablyText[_.character.curCharacter]))
            createTrickyLine(TrickyLinesArray[curID][FlxG.random.int(0, TrickyLinesArray[curID].length - 1)]);
}

function onNoteMiss(_) if (!_.note.isSustainNote && spawnOnDad)
    if (FlxG.random.bool(dad.curCharacter == 'Tricky/tricky' ? 10 : 4))
        createTrickyLine(TrickyLinesArray[2][FlxG.random.int(0, TrickyLinesArray[2].length - 1)]);