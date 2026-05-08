var fakerTransform:FunkinSprite;

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
	useCamMov = true;

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