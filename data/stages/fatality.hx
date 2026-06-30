import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxStringUtil;
import openfl.system.Capabilities;
importScript('data/scripts/FatalErrorPopUp');

function onEvent(_) if (_.event.name == 'Camera Movement')
    if (_.event.params[0] == 0) defaultCamZoom = 0.5;
    else if (_.event.params[0] == 1) defaultCamZoom = 0.75;

var launchBase:FunkinSprite = new FunkinSprite(-200, 100);
var launchBaseCorrupted:FunkinSprite = new FunkinSprite(100, 200);
var glitchedCrowd:FunkinSprite = new FunkinSprite(100, 200);
var trueFatal:FunkinSprite = new FunkinSprite(250, 200);
var sonicHUD:FlxTypedGroup<Dynamic> = new FlxTypedGroup();

var IsWindowMoving:Bool = false;
var windowX:Float = 0;
var windowY:Float = 0;
var Xamount:Float = 0;
var Yamount:Float = 0;

PauseSubState.script = 'data/scripts/ReziseWindow';

function create() {
    defaultCamZoom = 0.5;
    
    #if ARKOSE_PORT
    camGame.width = 960;
    camGame.x += 160;
    camHUD.width = 960;
    camHUD.x += 160;
    #end
    
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
    #if !ARKOSE_PORT
    healthBar.x += 150;
    healthBarBG.x += 150;
    #end
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
    
    #if ARKOSE_PORT
    for (i => notes in cpuStrums.members) notes.x = 15 + 115 * i;
    for (i => notes in player.members) {
    	var off:Float = (cpu.members[3].x + cpu.members[3].width) + 35;
    	notes.x = off + 115 * i;
    }
    #end
}

function onRatingUpdate(_) if (sonicHUD != null) {
    sonicHUD.members[3].text = songScore;
    sonicHUD.members[5].text = misses;
}

function update(_) {
	#if !ARKOSE_PORT
    if (getSaveData('Fatality_MoveWindow') && IsWindowMoving) {
        var thisX:Float = FlxMath.fastSin(Xamount * (Xamount)) * 100;
		var thisY:Float = FlxMath.fastSin(Yamount * (Yamount)) * 100;
		var yVal:Int = Std.int(windowY + thisY);
		var xVal:Int = Std.int(windowX + thisX);

        window.move(xVal, yVal);
        Yamount += 0.0015;
		Xamount += 0.00075;
    }
    #end

    if (sonicHUD != null) {
        var songCalc:Float = Conductor.songPosition;
        var secondsTotal:Int = Math.floor(songCalc / 1000);
	    if(secondsTotal < 0) secondsTotal = 0;

        sonicHUD.members[4].text = FlxStringUtil.formatTime(secondsTotal, false);
    }
}

function onStrumCreation(event) {
    if (event.player == 1 && usingSkins) return; 
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
    if (event.strumLineID == 1 && usingSkins) return; 
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
    note.splash = 'EXE/blood';
}

function stepHit() switch(curStep) {
    case 2240, 2560:
        IsWindowMoving = !IsWindowMoving;
    case 2530, 2535, 2540, 2545, 2550, 2555:
        shakeWindow();

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

        windowX = window.x;
		windowY = window.y;
        Xamount += 2;
		Yamount += 2;

        for (hide in cpuStrums) hide.x -= 1000;
        for (strum in playerStrums) strum.x -= 200;

        launchBaseCorrupted.visible = false;
        glitchedCrowd.visible = false;
        trueFatal.visible = true;

        var newFatalX:Float = dad.x + 770;
        var newFatalY:Float = dad.y - 80;
        changeCharacter(0, 'fatality/true-fatal');
        dad.setPosition(newFatalX, newFatalY);
        opponentCam.x = 620;
        opponentCam.y += 150;

        var newBfX:Float = boyfriend.x - 250;
        var newBfY:Float = boyfriend.y + 135;
        changeCharacter(1, 'fatality/bf-fatal-small');
        boyfriend.setPosition(newBfX, newBfY);
        playerCam.x = 620;
        playerCam.y += 50;
    case 2230:
		shakeWindow();
		camGame.shake(0.02, 0.8);
		camHUD.shake(0.02, 0.8);
    case 2528:
        shakeWindow();
        camGame.shake(0.02, 2);
		camHUD.shake(0.02, 2);
        Yamount += 3;
		Xamount += 3;
}

function shakeWindow() if (getSaveData('Fatality_MoveWindow')) new FlxTimer().start(0.01, () -> {
    window.move(window.x + FlxG.random.int(-10, 10), window.y + FlxG.random.int(-8, 8));
}, 50);


function onSongEnd() {
    #if !ARKOSE_PORT
    var determineScale:Float = switch(Capabilities.screenResolutionY) {
        default: 0.9;
        case 768 | 1080: 0.75;
        case 720: 0.6;
    }
    matense(1280, 720, determineScale);
    window.resizable = true;
    #end
}

function onCountdown(e) if (e.swagCounter != 4) {
    var a:String = ['intro3', 'intro2', 'intro1', 'introGo'][e.swagCounter];
    e.soundPath = 'fatalCountdown/$a';

    switch(e.swagCounter) {
        case 1: e.spritePath = 'modCountdowns/Fatality/fatal_2';
        case 2: e.spritePath = 'modCountdowns/Fatality/fatal_1';
        case 3: e.spritePath = 'modCountdowns/Fatality/fatal_go';
    }
    e.scale = 6.1;
}