import openfl.display.BlendMode;

public var stageSprites:Map<String, Dynamic> = [];
public var crystalsMap:Map<String, FlxSprite> = [];

public var isCorruptro:Bool = PlayState.SONG.meta.displayName == 'Corruptro';
public var backgroundLevel:Int = 0;

var hide:Float = 0.001;
var an:Bool = Options.antialiasing;
var x:Float = 0; // fr?
var y:Float = -128;
public var defaultZoom:Float;
public var runesCanGlow:Bool = false;

public var isCrackVisible:Bool = false;
public var stageTransformed:Bool = false;
public var secondCorruptRoar:Bool = false;
public var canBop:Bool = true;
public var moveCrystals:Bool = false;
public var rockColor:Bool = false;

var crystalPos:Array<Array<Float>> = [
    [1600, 200], [1200, -100], [1400, -500],
	[800, -150], [-900, 0], [550, -200],
	[-300, -300], [100, -200]
];
var crystalFloatData:Array<Array<Float>> = [
    [1500, 1], [2000, 0], [1000, 2],
    [2500, 1.5], [3000, 4], [1000, 3],
    [2500, 6], [2000, 2.5]
];

function postCreate() {
    loadHud('PsychEngine');
    gf?.visible = false;

    var overlay:FlxSprite = new FlxSprite(0,0, getModImage('wrath_overlay'));
    overlay.screenCenter();
    overlay.scrollFactor.set(0.6, 0.6);
    overlay.blend = BlendMode.SCREEN;
    overlay.y += -128;
    if (isCorruptro) setColorSwapShader(overlay, 180, -40);
    add(overlay);

    if (isCorruptro) {
        var black:FlxSprite = new FlxSprite(-1000, -1500).makeSolid(1280 * 3, 720 * 3, 0xFF000000);
        black.screenCenter();
        black.scrollFactor.set();
        add(black);
        stageSprites['black'] = black;
    }

    if (!isCorruptro) {
        boyfriend.x += 50;
        boyfriend.y += 40;
    }
}

var nose:Int = 0;
function insertSprite(spr:FlxSprite, name:String) if (spr != null) {
    insert(nose++, spr);
    stageSprites.set(name, spr);
}

public function setColorSwapShader(spr:FlxSprite, hue:Float = 0, sat:Float = 0, bri:Float = 0) if (spr != null) {
    var colorSwap:CustomShader = new CustomShader('colorSwap');
    colorSwap.uHsv = [0,0,0];
    colorSwap.uHsv[0] = hue / 360;
    colorSwap.uHsv[1] = sat / 100;
    colorSwap.uHsv[2] = bri / 100;

    spr.shader = colorSwap;
}

var skin:String = 'modNotes/Corruptro/NOTE_assets_retrobf';
var oppSkinPrefix:String = isCorruptro ? 'NOTE_assets_corruptro' : 'NOTE_assets_retro';
var oppSkin:String = 'modNotes/Corruptro/$oppSkinPrefix';

function onNoteCreation(_) {
	if (_.strumLineID == 1 && usingSkins) return;
	_.noteSprite = _.strumLineID == 1 ? skin : oppSkin;
	if (_.strumLineID == 1) _.note.splash = 'retrospecter';
}

function onStrumCreation(_) {
    if (_.player == 1 && usingSkins) return;
    _.sprite = _.player == 1 ? skin : oppSkin;
}

function create() {
    defaultCamZoom = 0.525;
    defaultZoom = defaultCamZoom;
    useCamMov = true;
    camMoveAmt = 30;

    if (backgroundLevel > 0) {
        var sky:FlxSprite = new FlxSprite(0, 0, getModImage('wrath_sky'));
        sky.scrollFactor.set(0.5, 0.5);
        sky.screenCenter();
        sky.y += y + 250;
        sky.active = false;
        sky.antialiasing = an;
        if (isCorruptro) setColorSwapShader(sky, 180, -40);
        insertSprite(sky, 'sky');

        if (backgroundLevel > 1) {
            var vortex:FunkinSprite = new FunkinSprite(-100, -750, getModImage('Vortex'));
            vortex.addAnim('speeen', 'Vortex', 24, true);
            vortex.playAnim('speeen', true);
            vortex.scale.set(1 / 0.5, 1 / 0.5);
            vortex.updateHitbox();
            vortex.scrollFactor.set(0.5, 0.5);
            if (isCorruptro) vortex.alpha = hide;
            vortex.antialiasing = an;
            if (isCorruptro) setColorSwapShader(vortex, 160, 25);
            insertSprite(vortex, 'vortex');
        }

        var str:String = isCorruptro ? 'wrath_gates_corrupt' : 'wrath_gates';
        var gates:FlxSprite = new FlxSprite(0,0, getModImage(str));
        gates.screenCenter();
        gates.scrollFactor.set(0.55, 0.55);
        gates.scale.set(1.5,1.5);
        gates.updateHitbox();
        gates.x += x - 555;
        gates.y += y - 150 - 305;
        gates.active = false;
        gates.antialiasing = an;
        insertSprite(gates, 'gates');

        for (i in 1...3) {
            var str:String = isCorruptro ? 'wrath_backrocks_0' + i + '_corrupt' : 'wrath_backrocks_0$i';
            var rocks:FlxSprite = new FlxSprite(0,0, getModImage(str));
            rocks.screenCenter();
            rocks.scrollFactor.set(0.6, 0.6);
            rocks.active = false;
            rocks.antialiasing = an;
            rocks.x += i == 1 ? (x - 1350) : (x + 725);
            rocks.y += i == 1 ? (y + 80) : (y + 65);
            insertSprite(rocks, 'rocks$i');

            var scrf:Float = i == 1 ? 0.6 : 0.7;
            var gems:FunkinSprite = new FunkinSprite().loadSprite(getModImage('gem$i'));
            gems.addAnim('green', 'green', 0, false);
            gems.addAnim('cyan', 'cyan', 0, false);
            gems.antialiasing = an;
            gems.playAnim('green');
            gems.screenCenter();
            gems.scrollFactor.set(scrf, scrf);
            gems.x += i == 1 ? (x - 600 - 410) : (x - 200 - 630);
            gems.y += i == 1 ? (y - 500 - 30) : (y - 150 - 150);
            if (isCorruptro) setColorSwapShader(gems, 180, -40);
            insertSprite(gems, 'gems$i');
        }

        if (backgroundLevel > 1) {
            var flames:FunkinSprite = new FunkinSprite().loadSprite(getModImage('flames_colorchange'));
            flames.addAnim("greenFlame", "Symbol 1 Instanz 1", 24, true);
            flames.playAnim('greenFlame');
            flames.scale.set(1.6, 1.5);
            flames.scrollFactor.set(0.7, 0.7);
            flames.x += x - 250;
            if (isCorruptro) flames.y += y + 1200;
            flames.antialiasing = an;
            if (isCorruptro) flames.alpha = hide;
            if (isCorruptro) setColorSwapShader(flames, 180, -40);
            insertSprite(flames, 'flames');
        }

        var str:String = isCorruptro ? 'cave-left_corrupt' : 'cave-left';
        var caveL:FlxSprite = new FlxSprite(0,0, getModImage('runes/$str'));
        caveL.screenCenter();
        caveL.scrollFactor.set(0.8, 0.8);
        caveL.x += x - 317;
        caveL.y += y + 81;
        caveL.flipX = true;
        caveL.active = false;
        caveL.antialiasing = an;
        insertSprite(caveL, 'caveL');

        if (backgroundLevel > 1) {
            runesCanGlow = true;

            var runesL:FlxSprite = new FlxSprite(0,0, getModImage('runes/runes-left'));
            runesL.screenCenter();
            runesL.scrollFactor.set(0.8, 0.8);
            runesL.scale.set(0.53, 0.53);
            runesL.updateHitbox();
            runesL.x += x - 686;
            runesL.y += y + 450;
            runesL.flipX = true;
            runesL.active = false;
            runesL.antialiasing = an;
            insertSprite(runesL, 'runesL');
            if (isCorruptro) setColorSwapShader(runesL, 180, 0);

            for (i in 1...3) {
                var glowL:FlxSprite = new FlxSprite(0,0, getModImage('runes/runeGlow-left'));
                glowL.screenCenter();
                glowL.scrollFactor.set(0.8, 0.8);
                glowL.flipX = true;
                glowL.active = false;
                glowL.antialiasing = an;
                glowL.x += x - 686;
                glowL.y += y + 450;
                glowL.scale.set(0.53, 0.53);
                glowL.updateHitbox();
                if (isCorruptro) setColorSwapShader(glowL, 180,  0);
                insertSprite(glowL, 'glowL' + i);
            }
        }

        if (isCorruptro) {
            var caveLGoop:FlxSprite = new FlxSprite(0,0, getModImage('wrath_cave_corruptgoop'));
            caveLGoop.screenCenter();
            caveLGoop.scrollFactor.set(0.8, 0.8);
            caveLGoop.x += x - 317;
            caveLGoop.y += y + 81;
            caveLGoop.flipX = true;
            caveLGoop.active = false;
            caveLGoop.antialiasing = an;
            insertSprite(caveLGoop, 'caveLGoop');
        }

        var str:String = isCorruptro ? 'cave-right_corrupt' : 'cave-right';
        var caveR:FlxSprite = new FlxSprite(0,0, getModImage('runes/$str'));
        caveR.screenCenter();
        caveR.scrollFactor.set(0.8, 0.8);
        caveR.antialiasing = an;
        caveR.x += x + 126 - 1.5;
        caveR.y += y + 25;
        insertSprite(caveR, 'caveR');

        if (backgroundLevel > 1) {
            var runesR:FlxSprite = new FlxSprite(0,0, getModImage('runes/runes-right'));
            runesR.screenCenter();
            runesR.scrollFactor.set(0.8, 0.8);
            runesR.x += x + 1246 + 115;
            runesR.y += y + -120 + 325;
            runesR.scale.set(0.65, 0.65);
            runesR.updateHitbox();
            insertSprite(runesR, 'runesR');
            if (isCorruptro) setColorSwapShader(runesR, 180, 0);

            for (i in 1...3) {
                var glowR:FlxSprite = new FlxSprite(0,0, getModImage('runes/runeGlow-right'));
                glowR.screenCenter();
                glowR.scrollFactor.set(0.8, 0.8);
                glowR.active = false;
                glowR.antialiasing = an;
                glowR.x += x + 1246 + 115;
                glowR.y += y + -120 + 325;
                glowR.scale.set(0.65, 0.65);
                glowR.updateHitbox();
                if (isCorruptro) setColorSwapShader(glowR, 180,  0);
                insertSprite(glowR, 'glowR' + i);
            }
        }

        if (isCorruptro) {
            var caveRGoop:FlxSprite = new FlxSprite(0,0, getModImage('wrath_cave_corruptgoop'));
            caveRGoop.scale.set(2818/2376, 1726/1455);
            caveRGoop.screenCenter();
            caveRGoop.scrollFactor.set(0.8, 0.8);
            caveRGoop.x += x + 126 - 1.5;
            caveRGoop.y += y + 25;
            caveRGoop.active = false;
            caveRGoop.antialiasing = an;
            insertSprite(caveRGoop, 'caveRGoop');
        }

        if (backgroundLevel > 1) for (i in 0...8) {
            var crystal:FunkinSprite = new FunkinSprite().loadSprite(getModImage('Crystals'));
            crystal.addAnim('idle', 'Crystal$i', 24, true);
            crystal.playAnim('idle');
            crystal.scrollFactor.set(0.9, 0.9);
            crystal.x = crystalPos[i][0];
            crystal.y = crystalPos[i][1];
            crystal.y += 1500;
            crystal.alpha = hide;
            crystal.antialiasing = an;
            if (isCorruptro) setColorSwapShader(crystal, 180, -40);
            crystalsMap.set('crystal$i', crystal);
            insert(nose++, crystal);
        }

        var str:String = isCorruptro ? 'ground_corrupt' : 'ground';
        var ground:FunkinSprite = new FunkinSprite().loadSprite(getModImage(str));
        ground.addAnim('green', 'green', 0, false);
        ground.addAnim('cyan', 'cyan', 0, false);
        ground.playAnim('green');
        ground.screenCenter();
        ground.antialiasing = an;
        ground.x += x;
        ground.y += y + 678;
        insertSprite(ground, 'ground');

        var crack:FunkinSprite = new FunkinSprite().loadSprite(getModImage('HellCrack'));
        crack.addAnim('appear', 'HellcrackAppear', 24, false);
        crack.addAnim('bop', 'HellcrackBop', 24, false);
        crack.screenCenter();
        crack.playAnim('bop');
        crack.active = false;
        crack.antialiasing = an;
        crack.x += 70-50;
        crack.y += 375+30;
        if (isCorruptro) setColorSwapShader(crack, 180, -40);
        insertSprite(crack, "crack");

        for (i in 0...2) {
            var str:String = isCorruptro ? 'frontRocks_' + i + '_corrupt' : 'frontRocks_$i';
            var rock:FunkinSprite = new FunkinSprite().loadSprite(getModImage(str));
            rock.addAnim('green', 'green', 0, false);
            rock.addAnim('cyan', 'cyan', 0, false);
            rock.playAnim('green');
            rock.antialiasing = an;
            rock.screenCenter();
            rock.scrollFactor.set(1.1, 1.1);
            rock.scale.set(1.1, 1.1);
            rock.x += x + 25;
            rock.y += y + 175;
            insert(members.indexOf(boyfriend) + 1, rock);
            stageSprites.set('rockFront_$i', rock);
        }
    }
}

function onDadHit() FlxG.camera.shake(0.010, 0.02);

function glowRune(str:String) {
    var spr:String = stageSprites.get(str);
    spr.alpha = 1;
    FlxTween.cancelTweensOf(spr);
    FlxTween.tween(spr, {alpha: 0}, 13/24);
}

function update(_) if (backgroundLevel > 1) {
    var songPos:Float = Conductor.songPosition / 1000;

    for (i in 0...8) if (crystalsMap.exists('crystal$i')) {
        var spr:FlxSprite = crystalsMap.get('crystal$i');
        spr.y += 50 * Math.sin((songPos) + crystalFloatData[i][1]) * _;
        
        if (moveCrystals) {
            spr.x += -crystalFloatData[i][0] * _;
            if (spr.x <= -1000) spr.x = 2500;
        }
    }
}

function beatHit() {
    if (canBop && curBeat % 2 == 0) {
        if (stageSprites.exists('crack')) {
            stageSprites["crack"].active = isCrackVisible;
            stageSprites["crack"].playAnim('bop');
        }

        if (runesCanGlow) for (i in ['glowL1', 'glowL2', 'glowR1', 'glowR2']) if (stageSprites.exists(i))
            glowRune(i);
    }
}