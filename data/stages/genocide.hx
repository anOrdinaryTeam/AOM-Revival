import flixel.addons.effects.FlxTrail;

var aight_U_win_gweb:HudCamera;
camZooming = true;
@:bypassAccessor maxHealth = 3;
health = 2;

function create() {
    var siniFireBehind:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
    var siniFireFront:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();

    var genocideBG:FlxSprite = new FlxSprite(-600, -300, getModPath('stages/fire/wadsaaa'));
    genocideBG.antialiasing = Options.antialiasing;
    genocideBG.scrollFactor.set(0.9, 0.9);
    addSprite(genocideBG);

    for (i in 0...2) {
        var frameShit:Array<Int> = [];
        
        for (j in 0...84) {
            var ourI:Int = j + (i * 10);
            if (ourI > 84 - 1)  ourI = ourI - (84 - 1);
            frameShit.push(j);
        }

        var fire:FunkinSprite = new FunkinSprite(genocideBG.x + (720 + (((95 * 10) / 2) * i)), genocideBG.y + 180);
        fire.loadSprite(getModPath('stages/fire/fireglow'));
        fire.addAnim('fire', 'FireStage', "", 30, true, false, frameShit);
		fire.playAnim('fire', true);
        fire.antialiasing = Options.antialiasing;
        fire.scrollFactor.set(0.9, 0.9);
        fire.scale.set(0.4, 1);
        fire.y += 50;
        siniFireBehind.add(fire);
    }
    addSprite(siniFireBehind);

    var genocideBoard:FlxSprite = new FlxSprite(genocideBG.x, genocideBG.y, getModPath('stages/fire/boards'));
    genocideBoard.antialiasing = Options.antialiasing;
    genocideBoard.scrollFactor.set(0.9, 0.9);
    addSprite(genocideBoard);

    for (i in 0...4) {
        var fire:FunkinSprite = new FunkinSprite();
        fire.loadSprite(getModPath('stages/fire/fireglow'));
        fire.addAnim('fire', 'FireStage', 30, true);
		fire.playAnim('fire', true);
        fire.antialiasing = Options.antialiasing;
        fire.scrollFactor.set(0.9, 0.9);
        siniFireFront.add(fire);

        switch(i) {
            case 0:
                fire.setPosition(genocideBG.x + (-100), genocideBG.y + 889);
                fire.scale.set(2.5, 1.5);
                fire.y -= fire.height * 1.5;
                fire.flipX = true;
            case 1:
                fire.setPosition((siniFireFront.members[0].x + siniFireFront.members[0].width) - 80, genocideBG.y + 889);
                fire.y -= fire.height * 1;
            case 2:
                fire.setPosition((siniFireFront.members[1].x + siniFireFront.members[1].width) - 30, genocideBG.y + 889);
                fire.y -= fire.height * 1;
            case 3:
                fire.setPosition((siniFireFront.members[2].x + siniFireFront.members[2].width) - 10, genocideBG.y + 889);
                fire.scale.set(1.5, 1.5);
                fire.y -= fire.height * 1.5;
        }
    }
    addSprite(siniFireFront);

    var fuckYouFurniture:FlxSprite = new FlxSprite(genocideBG.x, genocideBG.y, getModPath('stages/fire/glowyfurniture'));
    fuckYouFurniture.antialiasing = Options.antialiasing;
    fuckYouFurniture.scrollFactor.set(0.9, 0.9);
    addSprite(fuckYouFurniture);

    var destBoombox:FlxSprite = new FlxSprite(400, 130, getModPath('stages/fire/Destroyed_boombox'));
    destBoombox.y += (destBoombox.height - 648) * -1;
    destBoombox.y += 150;
    destBoombox.x -= 110;
    destBoombox.scale.set(1.2, 1.2);
    addSprite(destBoombox);

    var sumsticks:FlxSprite = new FlxSprite(-600, -300, getModPath('stages/fire/overlayingsticks'));
    sumsticks.antialiasing = Options.antialiasing;
    sumsticks.scrollFactor.set(0.9, 0.9);
    add(sumsticks);

    var tabiTrail = new FlxTrail(dad, null, 4, 24, 0.6, 0.9);
	insert(members.indexOf(dad) - 1, tabiTrail);
}

var vignette:FlxSprite;

function postCreate() {
    aight_U_win_gweb = new HudCamera();
    aight_U_win_gweb.bgColor = 0x00000000;
    aight_U_win_gweb.downscroll = camHUD.downscroll;
    FlxG.cameras.add(aight_U_win_gweb, false);

    var fuckThisShit:FlxCamera = new FlxCamera();
    fuckThisShit.bgColor = 0x00000000;
    FlxG.cameras.add(fuckThisShit, false);

    vignette = new FlxSprite(0,0, getModPath('vignette'));
    vignette.camera = fuckThisShit;
    vignette.antialiasing = Options.antialiasing;
    add(vignette);

    cpu.camera = aight_U_win_gweb;
    player.camera = aight_U_win_gweb;
}

var screenDanced:Bool = false;

function screenDance() {
    if (!screenDanced) window.x += Std.int(window.width / 100);
    else window.x -= Std.int(window.width / 100);
    screenDanced = !screenDanced;
}

var iconOffset:Int = 26;
function postUpdate() {
    var p2ToUse:Float = healthBar.x + (healthBar.width * (FlxMath.remapToRange((health / 2 * 100), 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
	if (iconP2.x - iconP2.width / 2 < healthBar.x && iconP2.x > p2ToUse){
		healthBarBG.offset.x = iconP2.x - p2ToUse;
		healthBar.offset.x = iconP2.x - p2ToUse;
	}
    else {
		healthBarBG.offset.x = 0;
		healthBar.offset.x = 0;
	}
    iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange((health / 2 * 100), 0, 100, 100, 0) * 0.01) - iconOffset);
	iconP2.x = p2ToUse;
}

function update() vignette.alpha = 1 - (health / 3);
function onNoteCreation(e) e.noteSprite = "modNotes/Tabi/NOTE_assets";
function onStrumCreation(e) e.sprite = "modNotes/Tabi/NOTE_assets";
function onPlayerHit(e) e.healthGain = 0.035;
function beatHit() aight_U_win_gweb.shake(0.005, (60 / Conductor.bpm), null, true, FlxAxes.X);

function onDadHit(e) {
    camGame.shake(0.03, 0.02, null, true);
    if (health > 0.1) health -= e.note.isSustainNote ? 0.0005 : 0.042;
}
function onEvent(e) if (e.event.name == 'Camera Movement')
    if (e.event.params[0] == 0) FlxTween.tween(this, {defaultCamZoom: 0.65}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
    else if (e.event.params[0] == 1) FlxTween.tween(this, {defaultCamZoom: 0.8}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});