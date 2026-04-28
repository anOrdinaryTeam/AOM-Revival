import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxStringUtil;
importScript('data/scripts/FatalErrorPopUp');

function onEvent(_) if (_.event.name == 'Camera Movement')
    if (_.event.params[0] == 0) defaultCamZoom = 0.5;
    else if (_.event.params[0] == 1) defaultCamZoom = 0.75;

var launchBase:FunkinSprite = new FunkinSprite(-200, 100);
var launchBaseCorrupted:FunkinSprite = new FunkinSprite(100, 200);
var glitchedCrowd:FunkinSprite = new FunkinSprite(100, 200);
var trueFatal:FunkinSprite = new FunkinSprite(250, 200);

var sonicHUD:FlxTypedGroup<Dynamic> = new FlxTypedGroup();
PauseSubState.script = 'data/scripts/ReziseWindow';

function create() {
    defaultCamZoom = 0.5;
    useCamMov = true;
    camMoveAmt = 20;

    launchBase.loadSprite(getModImage('Fatality/launchbase'));
    launchBase.animation.addByIndices('base', 'idle', [0, 1, 2, 3, 4, 5, 6, 8, 9], "", 12, true);
    launchBase.playAnim('base');
    launchBase.scale.x = 5;
	launchBase.scale.y = 5;
    launchBase.scrollFactor.set(1, 1);
    addSprite(launchBase);
    launchBase.antialiasing = false;

    launchBaseCorrupted.loadSprite(getModImage('Fatality/domain2'));
    launchBaseCorrupted.animation.addByIndices('theand', 'idle', [0, 1, 2, 3, 4, 5, 6, 8, 9], "", 12, true);
    launchBaseCorrupted.playAnim('theand');
    launchBaseCorrupted.scale.x = 4;
	launchBaseCorrupted.scale.y = 4;
    addSprite(launchBaseCorrupted);
    launchBaseCorrupted.antialiasing = false;
    launchBaseCorrupted.scrollFactor.set(1, 1);
    launchBaseCorrupted.visible = false;

    glitchedCrowd.loadSprite(getModImage('Fatality/domain'));
    glitchedCrowd.animation.addByIndices('begin', 'idle', [0, 1, 2, 3, 4], "", 12, true);
    glitchedCrowd.playAnim('begin');
    glitchedCrowd.scale.x = 4;
	glitchedCrowd.scale.y = 4;
    addSprite(glitchedCrowd);
    glitchedCrowd.antialiasing = false;
    glitchedCrowd.scrollFactor.set(1, 1);
    glitchedCrowd.visible = false;

    trueFatal.loadSprite(getModImage('Fatality/truefatalstage'));
    trueFatal.animation.addByIndices('piss', 'idle', [0, 1, 2, 3], "", 12, true);
    trueFatal.playAnim('piss');
    trueFatal.scale.set(4, 4);
    trueFatal.antialiasing = false;
    addSprite(trueFatal);
    trueFatal.visible = false;

    precacheCharacter(0, 'fatality/fatal-glitched');
    precacheCharacter(1, 'fatality/bf-fatal-small');
    graphicCache.cache(getModImage('Fatality/statix'));
}

function postCreate() if (getSaveData('allowCustomHud')) {
    for (i in [scoreTxt, accuracyTxt, missesTxt]) i.visible = false;
    healthBar.x += 150;
    healthBarBG.x += 150;
    sonicHUD.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, sonicHUD);

    for (i in 0...6) {
        var text:FlxText = new FlxText(20, 540 + (50 * i), FlxG.width, '', 45);
        text.font = Paths.font('Sonic3.otf');
        text.borderStyle = FlxTextBorderStyle.OUTLINE;
        text.borderSize = 1;
        text.borderColor = FlxColor.BLACK;
        sonicHUD.add(text);

        switch(i) {
            case 0,1,2: text.color = FlxColor.YELLOW;
            case 3,4,5:
                text.color = FlxColor.WHITE;
                text.alignment = 'right';
        }
        switch(i) {
            case 0: text.text = 'SCORE';
            case 1: text.text = 'TIME';
            case 2: text.text = 'MISSES';
            case 3,4,5: text.text = '0';
        }
    }

    var xScreen:Float = -FlxG.width;
    sonicHUD.members[3].setPosition(xScreen + 290, sonicHUD.members[0].y);
    sonicHUD.members[4].setPosition(xScreen + 250, sonicHUD.members[1].y);
    sonicHUD.members[5].setPosition(xScreen + 260, sonicHUD.members[2].y);
}

function onRatingUpdate(_) if (sonicHUD != null) {
    sonicHUD.members[3].text = songScore;
    sonicHUD.members[5].text = misses;
}

function update(_) if (sonicHUD != null) {
    var songCalc:Float = Conductor.songPosition;
    var secondsTotal:Int = Math.floor(songCalc / 1000);
	if(secondsTotal < 0) secondsTotal = 0;

    sonicHUD.members[4].text = FlxStringUtil.formatTime(secondsTotal, false);
}

function onStrumCreation(event)  {
    event.cancel();

    var spr:String = event.player == 0 ? 'fatal' : 'arrow';
    var strum = event.strum;
    strum.loadGraphic(Paths.image('modNotes/$spr-pixels'), true, 17, 17);
    strum.animation.add("static", [event.strumID]);
    strum.animation.add("pressed", [4 + event.strumID, 8 + event.strumID], 12, false);
    strum.animation.add("confirm", [12 + event.strumID, 16 + event.strumID], 24, false);
    strum.scale.set(6, 6);
    strum.updateHitbox();
}

function onNoteCreation(event) {
    event.cancel();

    var note = event.note;
    var spr:String = event.strumLineID == 0 ? 'fatal' : 'arrow';

    if (note.isSustainNote) {
        note.loadGraphic(Paths.image('modNotes/$spr' + 'Ends'), true, 7, 6);
        note.animation.add("hold", [event.strumID]);
        note.animation.add("holdend", [4 + event.strumID]);
    } else {
        note.loadGraphic(Paths.image('modNotes/$spr-pixels'), true, 17, 17);
        note.animation.add("scroll", [4 + event.strumID]);
    }
    note.scale.set(6, 6);
    note.updateHitbox();
    note.splash = 'pixel-default';
}

function stepHit() switch(curStep) {
    case 255, 1983:
		var daStatic = new FunkinSprite(0,0, getModImage('Fatality/statix'));
        daStatic.addAnim('a', 'statixx', 24, false);
        daStatic.playAnim('a', true);
        daStatic.screenCenter();
        daStatic.setGraphicSize(FlxG.width, FlxG.height);
        daStatic.camera = camHUD;
        add(daStatic);

        playModSound('staticBUZZ');
        new FlxTimer().start(0.20, () -> remove(daStatic));
    case 256:
		launchBase.visible = false;
		launchBaseCorrupted.visible = true;
		glitchedCrowd.visible = true;
    case 1151: changeCharacter(0, 'fatality/fatal-glitched');
    case 1984:
        clearPopUps();
        for (hide in cpuStrums) 
            hide.x -= 1000;
        for (strum in playerStrums)
            strum.x -= 225;

        launchBaseCorrupted.visible = false;
        glitchedCrowd.visible = false;
        trueFatal.visible = true;

        var newFatalX:Float = dad.x + 740;
        var newFatalY:Float = dad.y - 240;
        changeCharacter(0, 'fatality/true-fatal');
        dad.setPosition(newFatalX, newFatalY);
        opponentCam.x = 620;
        opponentCam.y += 50;

        var newBfX:Float = boyfriend.x - 250;
        var newBfY:Float = boyfriend.y + 135;
        changeCharacter(1, 'fatality/bf-fatal-small');
        boyfriend.setPosition(newBfX, newBfY);
        playerCam.x = 620;
        playerCam.y += 50;
}

function onSongEnd() {
    windowShit(1280, 720);
    window.resizable = true;
}