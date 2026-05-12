var fakerTransform:Character;
var daStatic:FunkinSprite = new FunkinSprite();
var camOther:FlxCamera = new FlxCamera();

function Faker(str:String)
    return getModImage('fakerBG/$str');

function addF(obj:Dynamic) if (obj != null) {
	obj.antialiasing = Options.antialiasing;
	obj.scale.set(.9, .9);
	addSprite(obj);
}

function create() {
	var eX:Float = -631.8;
	var eY:Float = -340;

    defaultCamZoom = 0.95;

	camOther.bgColor = 0;
	FlxG.cameras.add(camOther, false);

    var sky:FlxSprite = new FlxSprite(eX, eY, Faker('sky'));
	addF(sky);
    sky.scrollFactor.x = 1.2;

    var mountains:FlxSprite = new FlxSprite(eX, eY, Faker('mountains'));
	addF(mountains);

	var grass:FlxSprite = new FlxSprite(eX, eY, Faker('grass'));
	addF(grass);

	var tree:FlxSprite = new FlxSprite(900, eY + 310, Faker('tree-opt'));
	addF(tree);
	tree.flipX = true;

	var pillar:FlxSprite = new FlxSprite(1000, eY + 170, Faker('pillar2-opt'));
	addF(pillar);

	var plant:FlxSprite = new FlxSprite(350, 500, Faker('plant-opt'));
	addF(plant);

	var tree2:FlxSprite = new FlxSprite(150, eY + 260, Faker('tree-opt'));
	addF(tree2);

	var pillar2:FlxSprite = new FlxSprite(-200, eY + 170, Faker('pillar1-opt'));
	addF(pillar2);

	var flower:FlxSprite = new FlxSprite(-430, 500, Faker('flower-opt'));
	addF(flower);

	var flower2:FlxSprite = new FlxSprite(1500, 500, Faker('flower-opt'));
	addF(flower2);
	flower2.flipX = true;
}

function postCreate() {
	fakerTransform = new Character(dad.x - 70, dad.y - 190, 'EXE/Faker-Cutscene');
	fakerTransform.antialiasing = Options.antialiasing;
	fakerTransform.danceOnBeat = false;
	fakerTransform.alpha = 0.001;
	setObjectOrder(fakerTransform, getObjectOrder(dad) + 1);
	fakerTransform.playAnim('1', true);

	daStatic.loadSprite(getModImage('daSTAT'));
    daStatic.addAnim('static', 'staticFLASH', 24, false);
    daStatic.playAnim('static');
	daStatic.animation.finishCallback = (_) -> daStatic.visible = false;
    daStatic.camera = camOther;
    daStatic.setGraphicSize(FlxG.width, FlxG.height);
    daStatic.screenCenter();
    daStatic.alpha = 0.0001;
    add(daStatic);
}

var switchAnim:Int = 1;

function stepHit() {
	if (curStep > 858 && curStep < 884)
		singleStatic();

	switch(curStep) {
		case 787, 795, 902, 800, 811, 819, 823, 827, 832, 835, 839, 847, 847:
			singleStatic();
		case 768:
			FlxTween.tween(camHUD, {alpha: 0}, 1);
		case 801, 824, 836, 848:
			if (switchAnim == 4)
				opponentCam.x += 40;

			dad.alpha = 0;
			fakerTransform.alpha = 1;
			fakerTransform.playAnim(switchAnim, true);
			switchAnim++;
		case 884:
			camGame.visible = false;
			camHUD.visible = false;
	}
}

function singleStatic() {
    daStatic.visible = true;
    daStatic.playAnim('static');
    daStatic.alpha = 1;
    playModSound('staticBUZZ');
}