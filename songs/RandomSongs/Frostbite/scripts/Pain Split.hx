var defPainSplitChance:Float = switch(getSaveData('Frostbite_MechsDiff')) {
    default: 0.5;
    case 'fucked' | 'hell': 100;
}
var defPainSplitCooldown:Float = switch(getSaveData('Frostbite_MechsDiff')) {
    default: 30;
    case 'fucked': 100;
    case 'hell': 80;
}

var curChance:Float = defPainSplitChance;
var curCooldown:Float = defPainSplitCooldown;
var biteAmt:Float = getSaveData('Frostbite_MechsDiff') == 'fucked' ? 0.75 : 0.5;

function beatHit() if (freakachu != null && freakachu.alpha == 1) {
    curChance += 0.1;
	curCooldown -= 1;

    if (FlxG.random.bool(curChance) && curCooldown <= 0 && health >= 1.25) {
        curChance = defPainSplitChance;
        curCooldown = defPainSplitCooldown;
        bite(biteAmt);
    }
}

function bite(amt:Float) if (freakachu != null && freakachu.alpha == 1) {
    freakachu.playAnim('pain');
    new FlxTimer().start(0.46, () -> {
        health *= (1 - amt);
        playModSound('Frostbite_bite');
        boyfriend.playAnim('singDOWNmiss');
    });
}