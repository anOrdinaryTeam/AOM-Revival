import flixel.addons.effects.FlxTrail;
importScript('data/scripts/pixelate');
static function senpaiPath(str:String)
    return getModImage('TreacherousThorns/$str');

var filter:FlxSprite;
var spiritChar:Character = new Character(0, 0, 'TreacherousThorns/spiritCrazy');
var spiritTrail:FlxTrail;

var bgLayer1:FlxTypedGroup<Dynamic> = new FlxTypedGroup();
var bgLayer2:FlxTypedGroup<Dynamic> = new FlxTypedGroup();

// var senpaiCamPoint:FlxPoint = FlxPoint.get(470, 550);
// var corruptCamPoint:FlxPoint = FlxPoint.get(950, 650);

function create() {
    var xPos:Float = -300;
    var pixelZoom:Float = 6.5;
    defaultCamZoom = 1;

    insert(1, bgLayer1);
    insert(2, bgLayer2);

    // [ first layer ]

    // I feel the scroll factor its not making effect 
    var sky:FlxSprite = new FlxSprite(xPos, 0, senpaiPath('Sky'));
    sky.scrollFactor.set(0.1, 0.1);
    bgLayer1.add(sky);

    var school:FlxSprite = new FlxSprite(xPos, 0, senpaiPath('School'));
    school.scrollFactor.set(0.95, 0.95);
    bgLayer1.add(school);

    var street:FlxSprite = new FlxSprite(xPos, 0, senpaiPath('Street'));
    street.scrollFactor.set(0.95, 0.95);
    bgLayer1.add(street);

    var backTrees:FlxSprite = new FlxSprite(xPos, 0, senpaiPath('TreesBack'));
    backTrees.scrollFactor.set(0.9, 0.9);
    bgLayer1.add(backTrees);

    var trees:FlxSprite = new FunkinSprite(xPos, 0, senpaiPath('Trees'));
    trees.addAnim('idle', 'Tress', 12, true);
    trees.playAnim('idle');
    trees.scrollFactor.set(0.85, 0.85);
    bgLayer1.add(trees);

    var treeLeaves:FlxSprite = new FunkinSprite(xPos, 0, senpaiPath('petalsThorns'));
    treeLeaves.addAnim('idle', 'PETALS ALL', 24, true);
    treeLeaves.playAnim('idle');
    treeLeaves.scrollFactor.set(0.85, 0.85);
    bgLayer1.add(treeLeaves);

    // [ first layer ]


    // [ second layer ]

    var sky:FlxSprite = new FlxSprite(xPos, 0, senpaiPath('SkyEvil'));
    sky.scrollFactor.set(0.1, 0.1);
    bgLayer2.add(sky);

    var school:FlxSprite = new FlxSprite(xPos, 0, senpaiPath('SchoolEvil'));
    school.scrollFactor.set(0.95, 0.95);
    bgLayer2.add(school);

    var street:FlxSprite = new FlxSprite(xPos, 0, senpaiPath('StreetEvil'));
    street.scrollFactor.set(0.95, 0.95);
    bgLayer2.add(street);

    var backTrees:FlxSprite = new FlxSprite(xPos, 0, senpaiPath('TreesBackEvil'));
    backTrees.scrollFactor.set(0.9, 0.9);
    bgLayer2.add(backTrees);

    // [ second layer ]

    var resize:Float = Std.int(sky.width * pixelZoom);
    for (stage in bgLayer1) {
        stage.antialiasing = false;
        stage.setGraphicSize(resize);
        stage.updateHitbox();
    }
    for (stage in bgLayer2) {
        stage.antialiasing = false;
        stage.setGraphicSize(resize);
        stage.updateHitbox();
    }
}

function postCreate() {
    loadHud('Vanilla');
    spiritChar.setPosition(dad.x, dad.y);
    insert(members.indexOf(dad), spiritChar);

    spiritTrail = new FlxTrail(spiritChar, null, 4, 24, 0.3, 0.069);
    insert(members.indexOf(spiritChar), spiritTrail);

    filter = new FlxSprite(0, 0, senpaiPath('MargeD3'));
    filter.camera = camHUD;
    insert(1, filter);

    healthBarBG.loadGraphic(senpaiPath('healthBar'));
    PlayState.instance.comboGroup.y += 200;

    stageSwitch(0);
}

function onDadHit(_)
    spiritChar.playSingAnim(_.direction);

public function stageSwitch(t:Int) {
    var toEvil:Bool = t == 1;

    for (school in bgLayer1) school.alpha = toEvil ? 0 : 1;
    for (evil in bgLayer2) evil.alpha = toEvil ? 1 : 0;
    filter.alpha = toEvil ? 0 : 1;
    spiritChar.alpha = toEvil ? 1 : 0;
    spiritTrail.alpha = toEvil ? 0.3 : 0;
    dad.alpha = toEvil ? 0 : 1;
    gf.alpha = toEvil ? 0 : 1;
}