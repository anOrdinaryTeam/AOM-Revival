import flixel.ui.FlxBarFillDirection;
import flixel.ui.FlxBar;
import flixel.text.FlxTextBorderStyle;

var spr:String = downscroll ? '_down' : '_up';
var poisonStacks:Int = 0;
var healthDrainPoison:Float = 0.037500000000000006;
var hud:Map<String, Dynamic> = [];

function postCreate() {
    var opacity:Float = getSaveData('Psych_HudOpacity');
    healthBar.visible = false;
    healthBarBG.visible = false;

    var Y:Float = downscroll ? -50 : -15;
    var newBar:FlxBar = new FlxBar(healthBarBG.x, healthBarBG.y + Y, FlxBarFillDirection.RIGHT_TO_LEFT, Std.int(healthBarBG.width), Std.int(healthBarBG.height), this, 'health', 0, 2);
    newBar.scrollFactor.set();
    newBar.antialiasing = Options.antialiasing;
    newBar.createImageEmptyBar(modPath('HealthBar_Placeholder_Red'), FlxColor.WHITE);
    newBar.createImageFilledBar(modPath('HealthBar_Placeholder_Corrupt'), FlxColor.WHITE);
    newBar.numDivisions = 10000;
    newBar.camera = camHUD;
    newBar.alpha = opacity;
    insert(members.indexOf(healthBar), newBar);

    var bgAcid:FlxSprite = new FlxSprite(iconP1.x + 100, iconP1.y - 10, modPath('Health_Splat_Corrupt'));
    bgAcid.scale.set(0.2, 0.2);
    bgAcid.updateHitbox();
    bgAcid.antialiasing = Options.antialiasing;
    bgAcid.camera = camHUD;
    bgAcid.alpha = opacity;
    insert(members.indexOf(iconP1), bgAcid);

    var textAcid:FunkinText = new FunkinText(bgAcid.x + 45, bgAcid.y + 55, 0, '0', 21);
    textAcid.borderStyle = FlxTextBorderStyle.OUTLINE;
    textAcid.color = FlxColor.BLACK;
    textAcid.camera = camHUD;
    textAcid.alpha = opacity;
    insert(members.indexOf(bgAcid) + 1, textAcid);

    hud["bg"] = bgAcid;
    hud["text"] = textAcid;
}

function update(_) {
    hud["bg"].x = iconP1.x + 100;
    hud["text"].x = hud["bg"].x + 45;

    if (health > 0.01) {
        if (healthDrainPoison * poisonStacks * _ > health) 
            health = 0.01;
        else
            health -= healthDrainPoison * poisonStacks * _;
    }
}

function onNoteCreation(_) if (_.noteType == 'poison') {
    _.noteSprite = 'modNotes/Corruptro/PoisonNotes$spr';
    _.note.forceIsOnScreen = true;
    _.note.earlyPressWindow = 0.1;
	_.note.latePressWindow = 0.2;
	setColorSwapShader(_.note, 180, 0, 0);
    if (_.strumLineID <= 0) _.note.wasGoodHit = true;
}

function onPostNoteCreation(_) if (_.noteType == 'poison')
	if (downscroll) _.note.frameOffset.y += 20;
    else _.note.frameOffset.y -= 50;

function onPlayerHit(_) if (_.noteType == 'poison') {
    _.animCancelled = true;
    poisonStacks++;
    hud["text"].text = Std.string(poisonStacks);
    playModSound('acid');
}

function onPlayerMiss(_) if (_.noteType == 'poison') {
    _.cancel();
    deleteNote(_.note);
}