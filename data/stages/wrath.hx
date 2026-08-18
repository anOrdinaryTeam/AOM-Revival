import openfl.display.BlendMode;

var corruptroSprites:Map<String, Dynamic> = [];
var crystalsMap:Map<String, FlxSprite> = [];
var backgroundLevel:Int = getSaveData('Corruptro_levelBG');
var hide:Float = 0.001;
var an:Bool = Options.antialiasing;
var x:Float = 0; // fr?
var y:Float = -128;
var defaultZoom:Float;
var runesCanGlow:Bool = false;

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

static function modPath(str:String)
    return getModImage('Corruptro/$str');

function postCreate() {
    loadHud('PsychEngine');
    gf.visible = false;

    var overlay:FlxSprite = new FlxSprite(0,0, modPath('wrath_overlay'));
    overlay.screenCenter();
    overlay.scrollFactor.set(0.6, 0.6);
    overlay.blend = BlendMode.SCREEN;
    overlay.y += -128;
    setColorSwapShader(overlay, 180, -40);
    add(overlay);

    var black:FlxSprite = new FlxSprite(-1000, -1500).makeSolid(1280 * 3, 720 * 3, 0xFF000000);
    black.screenCenter();
    black.scrollFactor.set();
    add(black);
    corruptroSprites['black'] = black;
}

var nose:Int = 0;
function insertSprite(spr:FlxSprite, name:String) if (spr != null) {
    insert(nose++, spr);
    corruptroSprites.set(name, spr);
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
var oppSkin:String = "modNotes/Corruptro/NOTE_assets_corruptro";

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
        var sky:FlxSprite = new FlxSprite(0, 0, modPath('wrath_sky'));
        sky.scrollFactor.set(0.5, 0.5);
        sky.screenCenter();
        sky.y += y + 250;
        sky.active = false;
        sky.antialiasing = an;
        setColorSwapShader(sky, 180, -40);
        insertSprite(sky, 'sky');

        if (backgroundLevel > 1) {
            var vortex:FunkinSprite = new FunkinSprite(-100, -750, modPath('Vortex'));
            vortex.addAnim('speeen', 'Vortex', 24, true);
            vortex.playAnim('speeen', true);
            vortex.scale.set(1 / 0.5, 1 / 0.5);
            vortex.updateHitbox();
            vortex.scrollFactor.set(0.5, 0.5);
            vortex.alpha = hide;
            vortex.antialiasing = an;
            setColorSwapShader(vortex, 160, 25);
            insertSprite(vortex, 'vortex');
        }

        var gates:FlxSprite = new FlxSprite(0,0, modPath('wrath_gates_corrupt'));
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
            var rocks:FlxSprite = new FlxSprite(0,0, modPath('wrath_backrocks_0' + i + '_corrupt'));
            rocks.screenCenter();
            rocks.scrollFactor.set(0.6, 0.6);
            rocks.active = false;
            rocks.antialiasing = an;
            switch(i) {
                case 1:
                    rocks.x += x - 1350;
                    rocks.y += y + 80;
                case 2:
                    rocks.x += x + 725;
                    rocks.y += y + 65;
            }
            insertSprite(rocks, 'rocks' + i);

            var gems:FunkinSprite = new FunkinSprite().loadSprite(modPath('gem$i'));
            gems.addAnim('green', 'green', 0, false);
            gems.addAnim('cyan', 'cyan', 0, false);
            gems.antialiasing = an;
            gems.playAnim('green');
            gems.screenCenter();
            switch(i) {
                case 1:
                    gems.scrollFactor.set(0.6, 0.6);
                    gems.x += x - 600 - 410;
                    gems.y += y - 500 - 30;
                case 2:
                    gems.scrollFactor.set(0.7, 0.7);
                    gems.x += x - 200 - 630;
                    gems.y += y - 150 - 150;
            }
            setColorSwapShader(gems, 180, -40);
            insertSprite(gems, 'gems' + i);
        }

        if (backgroundLevel > 1) {
            var flames:FunkinSprite = new FunkinSprite().loadSprite(modPath('flames_colorchange'));
            flames.addAnim("greenFlame", "Symbol 1 Instanz 1", 24, true);
            flames.playAnim('greenFlame');
            flames.scale.set(1.6, 1.5);
            flames.scrollFactor.set(0.7, 0.7);
            flames.x += x - 250;
            flames.y += y + 1200;
            flames.antialiasing = an;
            flames.alpha = hide;
            setColorSwapShader(flames, 180, -40);
            insertSprite(flames, 'flames');
        }

        var caveL:FlxSprite = new FlxSprite(0,0, modPath('runes/cave-left_corrupt'));
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

            var runesL:FlxSprite = new FlxSprite(0,0, modPath('runes/runes-left'));
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
            setColorSwapShader(runesL, 180, 0);

            for (i in 1...3) {
                var glowL:FlxSprite = new FlxSprite(0,0, modPath('runes/runeGlow-left'));
                glowL.screenCenter();
                glowL.scrollFactor.set(0.8, 0.8);
                glowL.flipX = true;
                glowL.active = false;
                glowL.antialiasing = an;
                glowL.x += x - 686;
                glowL.y += y + 450;
                glowL.scale.set(0.53, 0.53);
                glowL.updateHitbox();
                setColorSwapShader(glowL, 180,  0);
                insertSprite(glowL, 'glowL' + i);
            }
        }

        var caveLGoop:FlxSprite = new FlxSprite(0,0, modPath('wrath_cave_corruptgoop'));
        caveLGoop.screenCenter();
        caveLGoop.scrollFactor.set(0.8, 0.8);
        caveLGoop.x += x - 317;
        caveLGoop.y += y + 81;
        caveLGoop.flipX = true;
        caveLGoop.active = false;
        caveLGoop.antialiasing = an;
        insertSprite(caveLGoop, 'caveLGoop');

        var caveR:FlxSprite = new FlxSprite(0,0, modPath('runes/cave-right_corrupt'));
        caveR.screenCenter();
        caveR.scrollFactor.set(0.8, 0.8);
        caveR.antialiasing = an;
        caveR.x += x + 126 - 1.5;
        caveR.y += y + 25;
        insertSprite(caveR, 'caveR');

        if (backgroundLevel > 1) {
            var runesR:FlxSprite = new FlxSprite(0,0, modPath('runes/runes-right'));
            runesR.screenCenter();
            runesR.scrollFactor.set(0.8, 0.8);
            runesR.x += x + 1246 + 115;
            runesR.y += y + -120 + 325;
            runesR.scale.set(0.65, 0.65);
            runesR.updateHitbox();
            insertSprite(runesR, 'runesR');
            setColorSwapShader(runesR, 180, 0);

            for (i in 1...3) {
                var glowR:FlxSprite = new FlxSprite(0,0, modPath('runes/runeGlow-right'));
                glowR.screenCenter();
                glowR.scrollFactor.set(0.8, 0.8);
                glowR.active = false;
                glowR.antialiasing = an;
                glowR.x += x + 1246 + 115;
                glowR.y += y + -120 + 325;
                glowR.scale.set(0.65, 0.65);
                glowR.updateHitbox();
                setColorSwapShader(glowR, 180,  0);
                insertSprite(glowR, 'glowR' + i);
            }
        }

        var caveRGoop:FlxSprite = new FlxSprite(0,0, modPath('wrath_cave_corruptgoop'));
        caveRGoop.scale.set(2818/2376, 1726/1455);
        caveRGoop.screenCenter();
        caveRGoop.scrollFactor.set(0.8, 0.8);
        caveRGoop.x += x + 126 - 1.5;
        caveRGoop.y += y + 25;
        caveRGoop.active = false;
        caveRGoop.antialiasing = an;
        insertSprite(caveRGoop, 'caveRGoop');

        if (backgroundLevel > 1) for (i in 0...8) {
            var crystal:FunkinSprite = new FunkinSprite().loadSprite(modPath('Crystals'));
            crystal.addAnim('idle', 'Crystal$i', 24, true);
            crystal.playAnim('idle');
            crystal.scrollFactor.set(0.9, 0.9);
            crystal.x = crystalPos[i][0];
            crystal.y = crystalPos[i][1];
            crystal.y += 1500;
            crystal.alpha = hide;
            crystal.antialiasing = an;
            setColorSwapShader(crystal, 180, -40);
            crystalsMap.set('crystal$i', crystal);
            insert(nose++, crystal);
        }

        var ground:FunkinSprite = new FunkinSprite().loadSprite(modPath('ground_corrupt'));
        ground.addAnim('green', 'green', 0, false);
        ground.addAnim('cyan', 'cyan', 0, false);
        ground.playAnim('green');
        ground.screenCenter();
        ground.antialiasing = an;
        ground.x += x;
        ground.y += y + 678;
        insertSprite(ground, 'ground');

        var crack:FunkinSprite = new FunkinSprite().loadSprite(modPath('HellCrack'));
        crack.addAnim('appear', 'HellcrackAppear', 24, false);
        crack.addAnim('bop', 'HellcrackBop', 24, false);
        crack.screenCenter();
        crack.active = false;
        crack.antialiasing = an;
        crack.x += 70-50;
        crack.y += 375+30;
        setColorSwapShader(crack, 180, -40);
        insertSprite(crack, "crack");

        for (i in 0...2) {
            var rock:FunkinSprite = new FunkinSprite().loadSprite(modPath('frontRocks_' + i + '_corrupt'));
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
            corruptroSprites.set('rockFront_$i', rock);
        }
    }
}

function onDadHit() FlxG.camera.shake(0.010, 0.02);
function onSongStart() FlxTween.tween(corruptroSprites["black"], {alpha: 0.4}, 13);

var isCrackVisible:Bool = false;
var stageTransformed:Bool = false;
var secondCorruptRoar:Bool = false;
var canBop:Bool = true;
var moveCrystals:Bool = false;
var rockColor:Bool = false;

function glowRune(str:String) {
    var spr:String = corruptroSprites.get(str);
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

function stepHit() {
    if (curStep == 144) {
        FlxTween.cancelTweensOf(corruptroSprites["black"]);
        corruptroSprites["black"].alpha = 0;
        camGame.flash(0xFFFFFFFF, 0.5);
    }
    
    if (!secondCorruptRoar && curStep >= 1824) {
        secondCorruptRoar = !secondCorruptRoar;
        moveCrystals = !moveCrystals;
        camGame.flash(0xFFFFFFFF, 0.5);
    }

    if (curStep == 864)
        defaultCamZoom += 0.2;
    if (curStep == 912)
        FlxG.camera.zoom = defaultCamZoom = defaultZoom;
}

function beatHit() {
    if (curBeat >= 616 && curBeat <= 808) {
        camHUD.zoom += 0.04;
        FlxG.camera.zoom += 0.03;
    }

    if (!stageTransformed && curBeat >= 228) {
        stageTransformed = !stageTransformed;
        isCrackVisible = !isCrackVisible;

        camGame.flash(0xFFFFFFFF, 0.5);

        if (corruptroSprites.exists('flames')) {
            corruptroSprites["flames"].alpha = 1;
            corruptroSprites["flames"].y -= 1000;
        }

        if (backgroundLevel > 1) {
            if (corruptroSprites.exists('crack')) {
                corruptroSprites["crack"].active = true;
                corruptroSprites["crack"].playAnim('appear');
            }
            
            if (corruptroSprites.exists('vortex'))
                corruptroSprites["vortex"].alpha = 1;

            for (i in 0...8 - 1) if (crystalsMap.exists('crystal$i')) {
                crystalsMap['crystal$i'].alpha = 1;
                crystalsMap['crystal$i'].y -= 1500;
            }
        }
    }
    if (curBeat > 808)
        canBop = false;

    if (canBop && curBeat % 2 == 0) {
        if (corruptroSprites.exists('crack')) {
            corruptroSprites["crack"].active = isCrackVisible;
            corruptroSprites["crack"].playAnim('bop');
        }

        if (runesCanGlow) for (i in ['glowL1', 'glowL2', 'glowR1', 'glowR2']) if (corruptroSprites.exists(i))
            glowRune(i);
    }

    if (getSaveData('FlashingLights')) if (backgroundLevel > 0)
        if (curStep >= 145 && curBeat <= 808 && curStep % 8 == 0) {
            rockColor = !rockColor;
            var color:String = rockColor ? 'cyan' : 'green';

            if (corruptroSprites.exists('ground')) corruptroSprites["ground"].playAnim(color);

            if (corruptroSprites.exists('rockFront_0') && corruptroSprites.exists('rockFront_1')) {
                corruptroSprites["rockFront_0"].playAnim(color);
                corruptroSprites["rockFront_1"].playAnim(color);
            }

            if (corruptroSprites.exists('gems1') && corruptroSprites.exists('gems2')) {
                corruptroSprites["gems1"].playAnim(color);
                corruptroSprites["gems2"].playAnim(color);
            }
        }
}