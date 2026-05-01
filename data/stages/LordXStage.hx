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
	floor.scrollFactor.x = 1.5;
	addSprite(floor);
}