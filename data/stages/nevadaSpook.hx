function modPath(str:String)
    return getModImage(str);

var hank:FunkinSprite;
var TrickyPoses:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var arr:Array<String> = ["Left", "Down", "Up", "Right"];
var timerForIdle:FlxTimer = new FlxTimer();

function create() {
    defaultCamZoom = 0.35;

    var bg:FlxSprite = new FlxSprite(-1000, -1000, modPath('stages/fourth/bg'));
    bg.antialiasing = Options.antialiasing;
    bg.scrollFactor.set(0.9, 0.9);
    bg.setGraphicSize(Std.int(bg.width * 5));
    addSprite(bg);

    var stageFront:FlxSprite = new FlxSprite(-1600, -400, modPath('stages/hellclwn/island_but_red'));
    stageFront.antialiasing = Options.antialiasing;
    stageFront.scrollFactor.set(0.9, 0.9);
    stageFront.setGraphicSize(Std.int(stageFront.width * 2.6));
    addSprite(stageFront);

    hank = new FunkinSprite(500, -150, modPath('stages/hellclwn/Hank'));
    hank.addAnim('dance','Hank', 24);
    hank.playAnim('dance');
    hank.scrollFactor.set(0.9, 0.9);
    hank.setGraphicSize(Std.int(hank.width * 1.55));
    hank.antialiasing = Options.antialiasing;
    addSprite(hank);

    for (anim in arr)
        graphicCache.cache(Paths.image('characters/tricky/Hellclown/$anim'));
}

function postCreate() {
    var offs:Array<Array<Float>> = [
        [dad.x - 1300, dad.y - 1300],
        [dad.x - 1300, dad.y - 900],
        [dad.x - 1500, dad.y - 800],
        [dad.x - 1300, dad.y - 1000]
    ];
    insert(members.indexOf(dad) + 1, TrickyPoses);

    for (i => anim in arr) {
        var tricky:FunkinSprite = new FunkinSprite(offs[i][0], offs[i][1], Paths.image('characters/tricky/Hellclown/$anim'));
        tricky.addAnim('anim', 'Proper $anim', 24, false);
        tricky.antialiasing = Options.antialiasing;
        TrickyPoses.add(tricky);
        tricky.alpha = 0.001;
    }
}

function onDadHit(_) {
    dad.alpha = 0;
    camGame.shake(0.02,0.2);
    timerForIdle?.cancel();

    TrickyPoses.forEachAlive(tricky -> tricky.alpha = 0.001);
    TrickyPoses.members[_.direction].alpha = 1;
    TrickyPoses.members[_.direction].playAnim('anim', true);

    timerForIdle.start(0.5, () -> {
        TrickyPoses.forEachAlive(tricky -> tricky.alpha = 0.001);
        dad.alpha = 1;
        dad.dance();
    });
}

function beatHit()
    hank.playAnim('dance');