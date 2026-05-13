function LordXPath(str:String)
    return getModImage('lordXstage/$str');

function create() {
    defaultCamZoom = 0.8;

    var sky:FlxSprite = new FlxSprite(-1900, -1006, LordXPath('sky'));
    sky.setGraphicSize(Std.int(sky.width * .5));
    sky.antialiasing = Options.antialiasing;
    addSprite(sky);

    var hills1:FlxSprite = new FlxSprite(-1440, -606, LordXPath('hills1'));
	hills1.setGraphicSize(Std.int(hills1.width * .5));
	hills1.antialiasing = Options.antialiasing;
	hills1.scale.x = 0.6;
	addSprite(hills1);

    var floor:FlxSprite = new FlxSprite(-1400, -496, LordXPath('floor'));
	floor.setGraphicSize(Std.int(floor.width * .5));
	floor.scale.x = 1;
	floor.antialiasing = Options.antialiasing;
	addSprite(floor);

	var flower:FunkinSprite = new FunkinSprite(-400, 100, LordXPath('WeirdAssFlower_Assets'));
	flower.antialiasing = Options.antialiasing;
	flower.addAnim('idle', 'flower', 30, true);
	flower.playAnim('idle');
	flower.setGraphicSize(Std.int(flower.width * 0.8));
	addSprite(flower);

	var hands:FunkinSprite = new FunkinSprite(-200, -375, LordXPath('NotKnuckles_Assets'));
	hands.antialiasing = Options.antialiasing;
	hands.addAnim('idle', 'Notknuckles', 30, true);
	hands.playAnim('idle');
	hands.setGraphicSize(Std.int(hands.width * .5));
	addSprite(hands);

	var offs = {
		x: [-680, -250, 1200],
		y: [580, 420, 390]
	}
	for (i in 0...3) {
		var smallFlower:FlxSprite = new FlxSprite(offs.x[i], offs.y[i], LordXPath('smallFlower-opt'));
		smallFlower.antialiasing = Options.antialiasing;
		smallFlower.setGraphicSize(Std.int(smallFlower.width * .6));
		smallFlower.flipX = i == 2;
		addSprite(smallFlower);
	}

	var tree:FlxSprite = new FlxSprite(1000, -580, LordXPath('tree-opt'));
	tree.scale.set(0.7, 0.7);
	tree.antialiasing = Options.antialiasing;
	addSprite(tree);
}

function postCreate() {
	camGame.followLerp = 0.08;
	boyfriend.scale.set(1.2, 1.2);
}

function stepHit() switch(curStep) {
	case 320: defaultCamZoom = .9;
	case 1103: defaultCamZoom = .8;
}