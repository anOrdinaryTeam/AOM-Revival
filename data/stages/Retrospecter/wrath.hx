// Functions
function makeSprite(im:String, ?x:Float, ?y:Float) {
    x ??= 0; y ??= 0;

    var suffix:String = (isCorruptro && Assets.exists(getModImage('wrath/$im' + '_corrupt'))) ? (im + '_corrupt') : im;
    var finalpath:String = getModImage('wrath/$suffix');

    var obj:FlxSprite = new FlxSprite(x, y, finalpath);
    obj.antialiasing = Options.antialiasing;
    obj.active = false;
    return obj;
}

function makeAnimSprite(im:String, ?x:Float, ?y:Float) {
    x ??= 0; y ??= 0;

    var suffix:String = (isCorruptro && Assets.exists(getModImage('wrath/$im' + '_corrupt'))) ? (im + '_corrupt') : im;
    var finalpath:String = getModImage('wrath/$suffix');

    var obj:FunkinSprite = new FunkinSprite(x, y, finalpath);
    obj.antialiasing = Options.antialiasing;
    return obj;
}

function addSpr(spr:Dynamic, tag:String) {
    if (spr == null) return;
    stageSprites.set(tag, spr);
    addSprite(spr);
}

public function setColorSwapShader(spr:FlxSprite, hue:Float = 0, sat:Float = 0, bri:Float = 0) if (spr != null) {
    var colorSwap:FunkinShader = FunkinShader.fromFile('colorSwap');
    colorSwap.uHsv = [0,0,0];
    colorSwap.uHsv[0] = hue / 360;
    colorSwap.uHsv[1] = sat / 100;
    colorSwap.uHsv[2] = bri / 100;

    spr.shader = colorSwap;
}

// Floats/Ints
public var HIDDEN:Float = 0.0000000001;
public var backgroundLevel:Int = getSaveData('Retro_levelBG');

// Booleans
public var isCorruptro:Bool = PlayState.SONG.meta.displayName == 'Corruptro';
public var isSpectral:Bool = PlayState.SONG.meta.displayName == 'Spectral';
public var isEctospasm:Bool = PlayState.SONG.meta.displayName == 'Ectospasm';
public var isSpectspasm:Bool = (isSpectral || isEctospasm) || isCorruptro;

public var flashingLights:Bool = getSaveData('FlashingLights');
var optimize:Bool = getSaveData('Retro_optimize');
var motion:Bool = getSaveData('Retro_motion');

var runesCanGlow:Bool = false;
var isCrackVisible:Bool = !isCorruptro;

// Sprites Map
public var stageSprites:Map<String, Dynamic> = [];

// Crystals
public var crystals:Array<FunkinSprite> = [];
var crystalPos:Array<Dynamic> = [
	[1600, 200],
	[1200, -100],
	[1400, -500],
	[800, -150],
	[-900, 0],
	[550, -200],
	[-300, -300],
	[100, -200]
];

var crystalFloatData:Array<Dynamic> = [
	[1500, 1],
	[2000, 0],
	[1000, 2],
	[2500, 1.5],
	[3000, 4],
	[1000, 3],
	[2500, 6],
	[2000, 2.5]
];

defaultCamZoom = 0.525;

function create()
{
    if (PlayState.SONG.meta.displayName == 'Satisfracture')
        defaultCamZoom += 0.215;

    if (!optimize && backgroundLevel > 0) {
        var wrathXAdjust:Float = 0;
        var wrathYAdjust:Float = -128;

        var sky:FlxSprite = makeSprite('wrath_sky');
        sky.screenCenter();
        sky.scrollFactor.set(0.5, 0.5);
        sky.x += wrathXAdjust;
        sky.y += (wrathYAdjust + 250);
        addSprite(sky);
        if (isCorruptro) setColorSwapShader(sky, 180, -40);

        if (backgroundLevel > 1 && isSpectspasm) {
            var vortex:FunkinSprite = makeAnimSprite('Vortex');
            vortex.scale.set(1/0.5, 1/0.5);
            vortex.updateHitbox();
            vortex.scrollFactor.set(0.5, 0.5);
            vortex.addAnim("speeen", "Vortex", 24, true);
            vortex.x += -100;
            vortex.y += -750;
            if (isCorruptro) vortex.alpha = HIDDEN;
            vortex.playAnim('speeen', true);
            if (!motion) vortex.animation.stop();
            addSpr(vortex, 'vortex');
            if (isCorruptro) setColorSwapShader(vortex, 160, 25);
        }

        var gates:FlxSprite = makeSprite('wrath_gates');
        gates.screenCenter();
        gates.scrollFactor(0.55, 0.55);
        gates.scale.set(1.5,1.5);
        gates.updateHitbox();
        gates.x += (wrathXAdjust - 555);
        gates.y += (wrathYAdjust - 150 - 305);
        addSprite(gates);

        // Backrocks
        for (i in 1...3) {
            var bRocks:FlxSprite = makeSprite('wrath_backrocks_0$i');
            bRocks.screenCenter();
            bRocks.scrollFactor.set(0.6, 0.6);
            bRocks.x += (i == 1) ? (wrathXAdjust - 1350) : (wrathXAdjust + 725);
            bRocks.y += (i == 1) ? (wrathYAdjust + 80) : (wrathYAdjust + 65);
            addSprite(bRocks);
        }

        // Gems
        for (i in 1...3) {
            var gem:FlxSprite = makeAnimSprite('gem$i');
            gem.scrollFactor.set(0.6, 0.6);
            gem.addAnim('green', 'green', 0, false);
            gem.addAnim('cyan', 'cyan', 0, false);
            gem.screenCenter();
            gem.active = false;
            gem.x += (i == 1) ? (wrathXAdjust - 600 - 410) : (wrathXAdjust - 200 - 630);
            gem.y += (i == 1) ? (wrathYAdjust - 500 - 30) : (wrathYAdjust - 150 - 150);
            gem.playAnim('green');
            if (isCorruptro) setColorSwapShader(gem, 180, -40);
            addSpr(gem, i == 0 ? 'gem1' : 'gem');
        }

        if (isSpectspasm) {
            // una screen negro idk

            if (backgroundLevel > 1) {
                var flames:FunkinSprite = makeAnimSprite('flames_colorchange');
                flames.addAnim('greenFlame', "Symbol 1 Instanz 1", 24, true);
                flames.screenCenter();
                flames.scale.set(1.6, 1.5);
                flames.scrollFactor.set(0.7, 0.7);
                flames.x += (wrathXAdjust - 250);
                flames.y += isCorruptro ? (wrathYAdjust + 1200) : (wrathYAdjust + 200);
                if (isCorruptro) flames.alpha = HIDDEN;
                flames.playAnim('greenFlame');
                addSpr(flames, 'flames');
                if (isCorruptro) setColorSwapShader(flames, 180, -40);

                if (flashingLights) {
                    var flamesChange:FunkinSprite = makeAnimSprite('flames_colorchange');
                    flamesChange.addAnim('blueFlame', "Symbol 2 Instanz 1", 24, true);
                    flamesChange.screenCenter();
                    flamesChange.scale.set(1.6, 1.5);
                    flamesChange.scrollFactor.set(0.7, 0.7);
                    flamesChange.x += (wrathXAdjust - 250);
                    flamesChange.y += (wrathYAdjust + 200);
                    flamesChange.alpha = HIDDEN;
                    flamesChange.playAnim('blueFlame');
                    addSpr(flamesChange, 'flamesChange');
                    if (isCorruptro) setColorSwapShader(flamesChange, 180, -40);
                }
            }

            if (isSpectspasm && !isCorruptro) {
                var sakuBop:FunkinSprite = makeAnimSprite('SakuBop');
                sakuBop.addAnim('bop', 'SakuBop', 24, false);
                sakuBop.screenCenter();
                sakuBop.x += (690 - 30);
                sakuBop.y += (-70 + 5);
                if (isSpectral) sakuBop.alpha = HIDDEN;
                sakuBop.scrollFactor.set(0.8, 0.8);
                addSpr(sakuBop, 'sakuBop');
            }
        }

        var caveL:FlxSprite = makeSprite(isSpectspasm ? 'runes/cave-left' : 'wrath_cave');
        caveL.screenCenter();
        caveL.scrollFactor.set(0.8, 0.8);
        caveL.x += (wrathXAdjust - 317);
        caveL.y += (wrathYAdjust + 81);
        caveL.flipX = true;
        addSprite(caveL);

        if (isSpectspasm && backgroundLevel > 1) {
            runesCanGlow = true;

            var runesL:FlxSprite = makeSprite('runes/runes-left');
            runesL.screenCenter();
            runesL.scrollFactor.set(0.8, 0.8);
            runesL.flipX = true;
            runesL.x += (wrathXAdjust - 686);
            runesL.y += (wrathYAdjust + 450);
            runesL.scale.set(0.53, 0.53);
            runesL.updateHitbox();
            addSprite(runesL);
            if (isCorruptro) setColorSwapShader(runesL, 180, 0);

            for (i in 1...3) {
                var id:String = 'glowL$i';
                var glow:FunkinSprite = makeAnimSprite('runes/runeGlow-left');
                glow.screenCenter();
                glow.scrollFactor.set(0.8, 0.8);
                glow.flipX = true;
                glow.x += (wrathXAdjust - 686);
                glow.y += (wrathYAdjust + 450);
                glow.scale.set(0.53, 0.53);
                glow.updateHitbox();
                addSpr(glow, id);
                if (isCorruptro) setColorSwapShader(glow, 180,  0);
            }
        }

        if (isCorruptro) {
            var caveLGoop:FlxSprite = makeSprite('wrath_cave_corruptgoop');
            caveLGoop.screenCenter();
            caveLGoop.scrollFactor.set(0.8, 0.8);
            caveLGoop.x += (wrathXAdjust - 317);
            caveLGoop.y += (wrathYAdjust + 81);
            caveLGoop.flipX = true;
            addSprite(caveLGoop);
        }

        var caveR:FlxSprite = makeSprite(isSpectspasm ? 'runes/cave-right' : 'wrath_cave');
        if (!isSpectspasm) {
            caveR.scale.x = 1.24558452481;
            caveR.scale.y = 1.24558452481;
        }
        caveR.screenCenter();
        caveR.scrollFactor.set(0.8, 0.8);
        caveR.x += (wrathXAdjust + 126 - 1.5);
        caveR.y += (wrathYAdjust + 25);
        addSprite(caveR);

        if (isSpectspasm && backgroundLevel > 1) {
            var runesR:FlxSprite = makeSprite('runes/runes-right');
            runesR.screenCenter();
            runesR.scrollFactor.set(0.8, 0.8);
            runesR.x += (wrathXAdjust + 1246 + 115);
            runesR.y += (wrathYAdjust + -120 + 325);
            runesR.scale.set(0.65, 0.65);
            runesR.updateHitbox();
            addSprite(runesR);
            if (isCorruptro) setColorSwapShader(runesR, 180, 0);

            for (i in 1...3) {
                var id:String = 'glowR$i';
                var glow:FunkinSprite = makeAnimSprite('runes/runeGlow-right');
                glow.screenCenter();
                glow.scrollFactor.set(0.8, 0.8);
                glow.x += (wrathXAdjust + 1246 + 115);
                glow.y += (wrathYAdjust + -120 + 325);
                glow.scale.set(0.65, 0.65);
                glow.updateHitbox();
                addSpr(glow, id);
                if (isCorruptro) setColorSwapShader(glow, 180,  0);
            }
        }

        if (isCorruptro) {
            var caveRGoop:FlxSprite = makeSprite('wrath_cave_corruptgoop');
            caveRGoop.scale.set(2818/2376, 1726/1455);
            caveRGoop.screenCenter();
            caveRGoop.scrollFactor.set(0.8, 0.8);
            caveRGoop.x += (wrathXAdjust + 126 - 1.5);
            caveRGoop.y += (wrathYAdjust + 25);
            addSprite(caveRGoop);
        }

        if (flashingLights && isSpectral) {
            var bgFlash:FlxSprite = new FlxSprite(-1250, -100).makeSolid(3000, 1000, -1);
            bgFlash.active = false;
            bgFlash.visible = false;
            addSpr(bgFlash, 'bgFlash');
        }

        if (backgroundLevel > 1 && isSpectspasm) for (i in 0...8) {
            var id:String = 'crystal$i';
            var crystal:FunkinSprite = makeAnimSprite('Crystals');
            crystal.addAnim('idle', 'Crystal$i', 24, true);
            crystal.x = crystalPos[i][0];
            crystal.y = crystalPos[i][1];
            crystal.scrollFactor.set(0.9, 0.9);
            crystal.playAnim('idle');
            if (isCorruptro) {
                crystal.y = 1500;
                crystal.alpha = HIDDEN;
                setColorSwapShader(crystal, 180, -40);
            }
            addSprite(crystal);
            crystals.push(crystal);
        }

        var ground:FlxSprite = makeAnimSprite('ground');
        ground.addAnim("green", "green", 0, false);
        ground.addAnim("cyan", "cyan", 0, false);
        ground.screenCenter();
        ground.active = false;
        ground.y += (wrathYAdjust + 678);
        ground.playAnim('green');
        addSpr(ground, 'ground');

        if (isSpectspasm) {
            var crack:FunkinSprite = makeAnimSprite('HellCrack');
            crack.addAnim('appear', 'HellcrackAppear', 24, false);
            crack.addAnim('bop', 'HellcrackBop', 24, false);
            crack.screenCenter();
            crack.active = false;
            crack.x += (70 - 50);
            crack.y += (375 + 30);
            if (isCorruptro) setColorSwapShader(crack, 180, -40);
            stageSprites.set('crack', crack);
            insert(members.indexOf(dad), crack);
        }

        for (i in 0...2) {
            var fRocks:FunkinSprite = makeAnimSprite(i == 0 ? 'frontRocks_1' : 'frontRocks_0');
            fRocks.addAnim('green', 'green', 0, false);
            fRocks.addAnim('cyan', 'cyan', 0, false);
            fRocks.screenCenter();
            fRocks.scrollFactor.set(1.1, 1.1);
            fRocks.active = false;
            fRocks.x += (wrathXAdjust + 25);
            fRocks.y += (wrathYAdjust + 175);
            fRocks.playAnim('green');
            stageSprites.set(i == 0 ? 'rocks' : 'rocksLeft', fRocks);
            insert(members.indexOf(boyfriend) + 1, fRocks);
        }
    }
}

function postCreate() if (!optimize) {
    var overlay:FlxSprite = makeSprite('wrath_overlay');
    overlay.screenCenter();
    overlay.scrollFactor.set(0.6, 0.6);
    overlay.blend = BlendMode.SCREEN;
    overlay.y += 128;
    if (isCorruptro) setColorSwapShader(overlay, 180, -40);
    add(overlay);
}

function postUpdate(dt) if (backgroundLevel > 1 && motion) {
    var songPos:Float = Conductor.songPosition / 1000;
    for (i => crystal in crystals) {
        crystal.y += 50 * Math.sin((songPos) + crystalFloatData[i][1]) * dt;

        if ((!isCorruptro && curStep >= 1536) || (isCorruptro && curStep >= 1824)) {
            crystal.x += -crystalFloatData[i][0] * dt;

            if (crystal.x <= -1000)
                crystal.x = 2500;
        }
    }
}

var rockColor:Bool = false;
function changeColor(id:String)
    stageSprites.get(id)?.playAnim(rockColor ? 'cyan' : 'green');

var didSakuFadeIn:Bool = false;
var didDarkFadeIn:Bool = false;
var flashCounter:Int = 0;

var stageTransformed:Bool = false;
var secondCorruptRoar:Bool = false;
var canBop:Bool = true;

function colorChangeStuff() {
    rockColor = !rockColor;

    for (str in ['ground', 'rocks', 'rocksLeft', 'gem1', 'gem2'])
        changeColor(str);

    if (isEctospasm || (isCorruptro && stageTransformed && curBeat >= 220) && backgroundLevel > 1) {
        var flamesChange:FunkinSprite = stageSprites.get('flamesChange');
        flamesChange?.alpha = 1;
        
        if (flamesChange != null) {
            FlxTween.cancelTweensOf(flamesChange);
            FlxTween.tween(flamesChange, {alpha: 0}, 0.5);
        }
    }
}

function stepHit(step) {
    if ((isEctospasm && flashingLights && !optimize) && backgroundLevel > 0)
        if (step >= 128 && step % 8 == 0)
            colorChangeStuff();

    if (isCorruptro) {
        if (curBeat > 808)
            canBop = false;

        if ((flashingLights && !optimize) && backgroundLevel > 0)
            if (step >= 145 && curBeat <= 808 && step % 8 == 0)
                colorChangeStuff();
    }

    if (isSpectral) {
        if (step >= 1024 && !didSakuFadeIn) {
            FlxTween.tween(stageSprites.get('sakuBop'), {alpha: 1}, 1);
            didDarkFadeIn = true;
        }

        // fade black

        if (flashingLights) {
            if (step >= 640 && flashCounter == 0) {
                camGame.flash(-1, 0.25, true);
                flashCounter++;
            }
            if (step >= 1024 && flashCounter == 1) {
                camGame.flash(-1, 0.25, true);
                flashCounter++;
            }
            if (step >= 1536 && flashCounter == 2) {
                camGame.flash(-1, 0.25, true);
                flashCounter++;
            }
            if (step >= 1856 && flashCounter == 3) {
                camGame.flash(-1, 0.25, true);
                flashCounter++;
            }
        }
    }

    if ((isCorruptro && !stageTransformed) && curBeat >= 228) {
        StageTransform();
        camGame.flash(-1, 0.5, true);
		stageTransformed = true;
        isCrackVisible = true;
    }

    if ((isCorruptro && !secondCorruptRoar) && step >= 1824) {
        camGame.flash(-1, 0.5, true);
        secondCorruptRoar = true;
    }
}

function beatHit(beat) if (canBop && beat % 2 == 0) {
    stageSprites.get('sakuBop')?.playAnim('bop', true);

    stageSprites.get('crack')?.active = isCrackVisible;
    stageSprites.get('crack')?.playAnim('bop', true);

    if (runesCanGlow) {
        var glowL1:FunkinSprite = stageSprites.get('glowL1');
        glowL1?.alpha = 1;
        if (glowL1 != null) {
            FlxTween.cancelTweensOf(glowL1);
            FlxTween.tween(glowL1, {alpha: 0}, 13/24);
        }

        var glowL2:FunkinSprite = stageSprites.get('glowL2');
        glowL2?.alpha = 1;
        if (glowL2 != null) {
            FlxTween.cancelTweensOf(glowL2);
            FlxTween.tween(glowL2, {alpha: 0}, 13/24);
        }

        var glowR1:FunkinSprite = stageSprites.get('glowR1');
        glowR1?.alpha = 1;
        if (glowR1 != null) {
            FlxTween.cancelTweensOf(glowR1);
            FlxTween.tween(glowR1, {alpha: 0}, 13/24);
        }

        var glowR2:FunkinSprite = stageSprites.get('glowL2');
        glowR2?.alpha = 1;
        if (glowR2 != null) {
            FlxTween.cancelTweensOf(glowR2);
            FlxTween.tween(glowR2, {alpha: 0}, 13/24);
        }
    }
}

function onDadHit() if (isSpectral || isEctospasm || isCorruptro)
    camGame.shake(0.006, 0.05);