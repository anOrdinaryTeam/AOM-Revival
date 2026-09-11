import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;

var bar:FlxBar;
var typhState:FunkinSprite;
var theromometer:FunkinSprite;

var coldness:Float = 0.0;
public var coldnessRate:Float = 0.0;
var coldnessMult:Float = 1;
var coldnessDisplay:Float = 0.0;
var typhlosionUses:Int = 10;

function postCreate() {
    bar = new FlxBar(1161 + 36 - 1134, 172 + 60, FlxBarFillDirection.BOTTOM_TO_TOP, 16, 325, null, null, 0, 1);
	bar.createFilledBar(0xFF133551, 0xFFAAD6FF);
	bar.camera = camHUD;
	add(bar);

    typhState = new FunkinSprite(1164 - 1134, 550, FrostPath('UI/TyphlosionVit'));
    for (i in 1...6) typhState.addAnim('stage$i', 'Typh$i', 24, true);
    typhState.playAnim('stage1');
	typhState.antialiasing = Options.antialiasing;
	typhState.camera = camHUD;
	add(typhState);

	theromometer = new FunkinSprite(1161 - 1134, 172, FrostPath('UI/Thermometer'));
    for (i in 1...4) theromometer.addAnim('stage$i', 'Therm$i', 24, true);
    theromometer.playAnim('stage1');
	theromometer.antialiasing = Options.antialiasing;
	theromometer.camera = camHUD;
	add(theromometer);

    coldnessMult = switch(getSaveData('Frostbite_MechsDiff')) {
        default: 1;
        case 'fucked': 1.35;
        case 'hell': 1.5;
    }
    typhlosionUses = switch(getSaveData('Frostbite_MechsDiff')) {
        default: 10;
        case 'fucked': 8;
        case 'hell': 6;
    }
}

function update(dt:Float) {
    if (coldness < 0.0)
        coldness = 0.0;

    if (coldness != 0.0 && camHUD.alpha == 1.0)
        health -= (coldness * 0.00300) * ((dt) * 120);

    coldnessDisplay = lerp(coldnessDisplay, coldness, (dt / (1 / 120)) * 0.03);
    bar.value = coldnessDisplay;
    bar.updateBar();

    var TheromometerAnim:String = '';
    if (coldnessDisplay < 0.33) TheromometerAnim = 'stage1';
    if (coldnessDisplay >= 0.33) TheromometerAnim = 'stage2';
    if (coldnessDisplay >= 0.66) TheromometerAnim = 'stage3';

    if (theromometer.animation.curAnim.name != TheromometerAnim)
        theromometer.playAnim(TheromometerAnim);

    if (fog.visible)
        fog.alpha = 0.25 + (coldnessDisplay * 0.75);

    if (typhlosionUses >= 1 && FlxG.keys.justPressed.SPACE)
        warm();
}

function beatHit() if (coldness < 1.0)
    coldness += coldnessRate * coldnessMult;

function warm() {
    typhlosionUses -= 1;
    coldness -= (0.35 * (typhlosionUses * 0.075)) + 0.20;

    switch(typhlosionUses) {
		case 8: typhState.playAnim('stage2');
		case 6: typhState.playAnim('stage3');
		case 4: typhState.playAnim('stage4');
		case 2: typhState.playAnim('stage5');
	}

    if (typhlosionUses == 0) {
        playModSound('TyphlosionUse');
        new FlxTimer().start(0.85, () -> {
            playModSound('TyphlosionDeath');

            if (typhlosion != null) {
                typhlosion.playAnim('fire', true, 'LOCK');
                typhlosion.animation.onFinish.add((Anim) -> if (Anim == 'fire') typhlosion.animation.curAnim.pause());
                FlxTween.tween(typhlosion, {y: typhlosion.y + 500}, 1.5, {ease: FlxEase.quadInOut});
            }
        });
    }
    else {
        if (typhlosion != null) typhlosion.playAnim('fire', true);
        playModSound('TyphlosionUse');
    }
}