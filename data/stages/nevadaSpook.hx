// importScript('data/scripts/TrickyLines');

static function modPath(str:String)
    return getModImage(str);

var hank:FunkinSprite;

function create() {
    defaultCamZoom = 0.35; // 0.35
    dad.x -= 300; dad.y -= 600;
    gf.x += 180; boyfriend.x += 350;

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
}

function beatHit()
    hank.playAnim('dance');

var TrickyPoses:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var arr:Array<String> = ["Left", "Down", "Up", "Right"];

function postCreate() {
    insert(members.indexOf(dad) + 1, TrickyPoses);

    for (i in 0...arr.length) {
        var tricky:FunkinSprite = new FunkinSprite();
        tricky.loadSprite(Paths.image('characters/tricky/Hellclown/' + arr[i]));
        tricky.addAnim('anim', 'Proper ' + arr[i], 24, false);
        tricky.antialiasing = Options.antialiasing;
        tricky.alpha = 0.001;
        TrickyPoses.add(tricky);

        switch(i) {
            case 0: tricky.setPosition(dad.x - 1300, dad.y - 1300);
            case 1: tricky.setPosition(dad.x - 1300, dad.y - 900);
            case 2: tricky.setPosition(dad.x - 1500, dad.y - 800);
            case 3: tricky.setPosition(dad.x - 1300, dad.y - 1000);
        }
    }
}

var timerForIdle:FlxTimer = new FlxTimer();

function onDadHit(_) {
    dad.alpha = 0;
    camGame.shake(0.02,0.2);
    timerForIdle?.cancel();

    for (i in 0...TrickyPoses.members.length) TrickyPoses.members[i].alpha = 0;
    TrickyPoses.members[_.direction].alpha = 1;
    TrickyPoses.members[_.direction].playAnim('anim', _.note.isSustainNote);

    timerForIdle.start(0.5, () -> {
        for (i in 0...TrickyPoses.members.length)
            TrickyPoses.members[i].alpha = 0;
        dad.alpha = 1;
        dad.dance();
    });
}