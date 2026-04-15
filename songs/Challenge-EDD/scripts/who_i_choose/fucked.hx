function create() {
    for (f in ['bf-tord', 'edd-tord', 'matt-tord', 'tomRunsIn', 'tordBot', 'tordGlass', 'tordBG', 'tordHelicopter', 'tordFlails', 'bf-lookup'])
        { graphicCache.cache(getModImage('Challenge-EDD/fucked/$f')); }
    precacheCharacter(0, 'tord');
    tordEntrance(); tordFall();
    // camHUD.alpha = 0;
}

var should:Bool = true;
function onCameraMove(_) {
    if (should && !_.cancelled) _.position.set(950, 450);
}

var mattTord:FunkinSprite;
var eddTord:FunkinSprite;
var bfTord:FunkinSprite;
var bfDude:FlxSprite;
var tomRush:FunkinSprite;
var tomHarpoon:FunkinSprite;

function tordEntrance() {
    mattTord = new FunkinSprite(115, 240).loadSprite(getModImage('Challenge-EDD/fucked/matt-tord'));
    mattTord.antialiasing = true;
    mattTord.scale.set(1.7, 1.7);

    mattTord.addAnim('dafuk', 'mattReactionTord', 12, false);
    mattTord.addAnim('look', 'mattLookUp', 12, false);
    mattTord.addAnim('fiu', 'mattHarpoonBit', 12, false);
    
    mattTord.playAnim('dafuk');
    add(mattTord);

    eddTord = new FunkinSprite(190, 195).loadSprite(getModImage('Challenge-EDD/fucked/edd-tord'));
    eddTord.antialiasing = true;

    eddTord.addAnim('shaking', 'EddGroundShaking', 12, false);
    eddTord.addAnim('tord', 'EddTurnToTord', 12, false);
    eddTord.addAnim('look', 'EddLookingUp', 12, false);

    eddTord.playAnim('shaking');
    // eddTord.playAnim('tord'); edd2.y += 30;
    // eddTord.playAnim('look'); edd2.x += 135;
    // add(eddTord);

    bfTord = new FunkinSprite(1160, 450).loadSprite(getModImage('Challenge-EDD/fucked/bf-tord'));
    bfTord.antialiasing = true;

    bfTord.addAnim('shaking', 'BF Ground Shaking', 12, false);
    bfTord.addAnim('tord', 'BF Look At Tord', 12, false);
    
    bfTord.playAnim('tord');
    // bfTord.playAnim('tord'); bfTord.x += 10; bfTord.y -= 8;
    // add(bfTord);

    tomRush = new FunkinSprite(1315, 425).loadSprite(getModImage('Challenge-EDD/fucked/tomRUnsIn'));
    tomRush.antialiasing = true;
    tomRush.scale.set(1.7, 1.7);

    tomRush.addAnim('run', 'Tom Running In', 12, false);
    tomRush.playAnim('run');
    // add(tomRush);
}

function tordFall() {
    mattTord.y += 40;
    mattTord.playAnim('look');
    new FlxTimer().start(3, () -> mattTord.playAnim('fiu'));

    bfDude = new FlxSprite(1220, 450, getModImage('Challenge-EDD/fucked/bf-lookup'));
    bfDude.antialiasing = true;
    // add(bfDude);

    // new FlxTimer().start(0.15, () -> mattTord.playAnim('punch'));
    tomHarpoon = new FunkinSprite(765, 365).loadSprite(getModImage('Challenge-EDD/fucked/tomHarpoon'));
    tomHarpoon.antialiasing = true;
    tomHarpoon.addAnim('idle', 'TomHarpoonIdle', 12, false);
    tomHarpoon.addAnim('line', 'TomHarpoonLine', 12, true);
    tomHarpoon.addAnim('harp', 'TomHarpoonHarpoon', 24, false);

    tomHarpoon.playAnim('idle');
    
    add(tomHarpoon);

    new FlxTimer().start(2, () -> tomHarpoon.playAnim('line'));
    new FlxTimer().start(4, () -> tomHarpoon.playAnim('harp'));

}