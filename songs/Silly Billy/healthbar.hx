import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;

var bar:FlxSprite;
public var iconOpp:FlxSprite;
var iconP:FlxSprite;
var barFill:FlxSprite;
var actualBar:FlxBar;
var evilBar:FlxBar;

public var items = [];

var evilHealth:Float = 1;

function postCreate() {
    var i:Int = members.indexOf(scoreTxt);

    bar = new FlxSprite().loadGraphic(BillyPath("hud/Silly_Healthbar"));
    bar.camera = camHUD;
    bar.scale.set(0.5, 0.5);
    bar.updateHitbox();
    bar.screenCenter();
    bar.x -= 250;
    bar.y = (healthBar.y - (bar.height / 2)) - 15;
    bar.antialiasing = Options.antialiasing;

    actualBar = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 327.805, 28, this, 'health', 0, 2);
    actualBar.camera = camHUD;
    actualBar.createGradientBar([0xFF000000, 0xFF000000], [0xFF1565C0, 0xFFFFFFFF], 1, 90);
    actualBar.setPosition(420, 615.8);

    evilBar = new FlxBar(0, 0, FlxBarFillDirection.RIGHT_TO_LEFT, 330.805, 36);
    evilBar.camera = camHUD;
    evilBar.createGradientBar([0xFF000000, 0xFF000000], [0xFF8A0101, 0xFF000000], 1, 90);
    evilBar.setPosition(405 - evilBar.width - 25, 615.8);

    insert(i, evilBar);
    insert(members.indexOf(evilBar) + 1, actualBar);
    insert(members.indexOf(actualBar) + 1, bar);

    iconP = new FlxSprite().loadGraphic(BillyPath("hud/bficon"), true, Math.floor(300 / 2), Math.floor(150));
    iconP.animation.add('bf', [0, 1], 0, false, true);
    iconP.animation.play('bf');
    iconP.camera = camHUD;
    iconP.setPosition(400, (bar.y + (bar.height / 2) - (iconP.height / 2)));
    iconP.flipX = true;
    iconP.antialiasing = Options.antialiasing;
    insert(members.indexOf(bar) + 1, iconP);

    iconOpp = new FlxSprite().loadGraphic(BillyPath('hud/billyicon'), true, Math.floor(773 / 5), Math.floor(129));
    iconOpp.animation.add('0', [0], 0, false, false);
    iconOpp.animation.add('1', [1], 0, false, false);
    iconOpp.animation.add('2', [2], 0, false, false);
    iconOpp.animation.add('3', [3], 0, false, false);
    iconOpp.animation.add('4', [4], 0, false, false);
    iconOpp.animation.play('1');
    iconOpp.camera = camHUD;
    iconOpp.setPosition(405 - iconOpp.width, (bar.y + (bar.height / 2) - (iconOpp.height / 2)));
    iconOpp.antialiasing = Options.antialiasing;
    insert(members.indexOf(iconP) + 1, iconOpp);

    iconOpp.centerOffsets();
    iconP.centerOffsets();

    accuracyTxt.setPosition(accuracyTxt.x - 250, accuracyTxt.y - 110);
    missesTxt.setPosition(missesTxt.x - 250, missesTxt.y - 110);
    scoreTxt.setPosition(scoreTxt.x - 250, scoreTxt.y - 110);

    for (i in [bar, actualBar, evilBar, iconP, iconOpp])
        items.push(i);
}

function update() {
    evilBar.percent = 100 - healthBar.percent;
    iconP.animation.curAnim.curFrame = health.percent < 20 ? 1 : 0;
}

function onDadHit(_)
    if (_.character.curCharacter == dad.curCharacter && health > 0.1) health -= 0.023 * .6;