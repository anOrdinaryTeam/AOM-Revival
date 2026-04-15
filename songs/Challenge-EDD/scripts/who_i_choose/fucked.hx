function create() {
    for (f in ['bf-tord', 'edd-tord', 'matt-tord', 'tomRunsIn', 'tordBot', 'tordGlass', 'tordBG', 'tordHelicopter', 'tordFlails', 'bf-lookup'])
        { graphicCache.cache(getModImage('Challenge-EDD/fucked/$f')); }
    precacheCharacter(0, 'tord');
    tordEntrance();
    camHUD.alpha = 0;
}

var should:Bool = true;
function onCameraMove(_) {
    if (should && !_.cancelled) _.position.set(950, 450);
}

var bfTord:FunkinSprite;
var eddTord:FunkinSprite;
var mattTord:FunkinSprite;

function tordEntrance() {
    eddTord = new FunkinSprite(190, 195).loadSprite(getModImage('Challenge-EDD/fucked/edd-tord'));
    eddTord.antialiasing = true;
    eddTord.addAnim('shaking', 'EddGroundShaking', 12, false);
    eddTord.addAnim('tord?', 'EddTurnToTord', 12, false);
    eddTord.addAnim('look', 'EddLookingUp', 12, false);

    eddTord.playAnim('shaking');
    // eddTord.playAnim('tord?'); edd2.y += 30;
    // eddTord.playAnim('look'); edd2.x += 135;
    add(eddTord);

    bfTord = new FunkinSprite(1160, 450).loadSprite(getModImage('Challenge-EDD/fucked/bf-tord'));
    bfTord.antialiasing = true;
    bfTord.addAnim('shaking', 'BF Ground Shaking', 12, false);
    bfTord.addAnim('tord?', 'BF Look At Tord', 12, false);
    
    bfTord.playAnim('shaking');
    // bfTord.playAnim('tord?'); bfTord.x += 10; bfTord.y -= 8;
    add(bfTord);

    mattTord = new FunkinSprite(190, 195).loadSprite(getModImage('Challenge-EDD/fucked/edd-tord'));
    mattTord.antialiasing = true;
    mattTord.addAnim('mattReactionTord', 'EddGroundShaking', 12, false);
    mattTord.addAnim('look', 'mattLookUp', 12, false);
    mattTord.addAnim('fiu', 'mattHarpoonBit', 12, false);
}