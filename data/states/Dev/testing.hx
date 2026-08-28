function ChaosPath(str:String)
    return getModPath('chamber/$str');

function create() {
    currentMod = 'Sonic.EXE';
    FlxG.camera.zoom = 0.2;

    var wall:FunkinSprite = new FunkinSprite(-2379.05, -1211.1, ChaosPath('Wall'));
    wall.antialiasing = Options.antialiasing;
    wall.addAnim('a', 'Wall instance 1');
	wall.playAnim('a');
    wall.scrollFactor.set(1.1, 1.1);
    add(wall);

    var floor:FunkinSprite = new FunkinSprite(-2349, 921.25, ChaosPath('Floor'));
    floor.antialiasing = Options.antialiasing;
    floor.addAnim('a', 'normal');
    floor.addAnim('b', 'yellow');
	floor.playAnim('a');
    floor.scrollFactor.set(1.1, 1.1);
    add(floor);

    var bgA:FunkinSprite = new FunkinSprite(-2629.05, -1344.05, ChaosPath('BGblue'));
    bgA.antialiasing = Options.antialiasing;
    bgA.addAnim('a', 'BGblue');
    bgA.playAnim('a');
    bgA.scrollFactor.x = 1.1;
    add(bgA);

    var emeraldbeam:FunkinSprite = new FunkinSprite(0, -1576.95, ChaosPath('Emerald Beam'));
	emeraldbeam.antialiasing = Options.antialiasing;
	emeraldbeam.addAnim('a', 'Emerald Beam instance 1', 24, true);
	emeraldbeam.playAnim('a');
	emeraldbeam.scrollFactor.x = 1.1;
	add(emeraldbeam);

    var emeralds:FunkinSprite = new FunkinSprite(326.6, -191.75, ChaosPath('Emeralds'));
	emeralds.antialiasing = Options.antialiasing;
	emeralds.addAnim('a', 'TheEmeralds instance 1', 24, true);
	emeralds.playAnim('a');
	emeralds.scrollFactor.x = 1.1;
	add(emeralds);

    var chamber:FunkinSprite = new FunkinSprite(0, 0, ChaosPath('theChamber'));
    chamber.antialiasing = Options.antialiasing;
    chamber.addAnim('a', 'Chamber Sonic Fall', 24, false);
    chamber.scrollFactor.x = 1.1;
    add(chamber);

    var pebles:FunkinSprite = new FunkinSprite(-462.15, 1043.3, ChaosPath('pebles'));
    pebles.antialiasing = Options.antialiasing;
    pebles.addAnim('a', 'pebles instance 1');
    pebles.addAnim('b', 'pebles instance 2');
	pebles.playAnim('a');
    pebles.scrollFactor.set(1.1, 1.1);
    add(pebles);

    var porker:FunkinSprite = new FunkinSprite(2880.15, -762.8, ChaosPath('porker'));
	porker.antialiasing = Options.antialiasing;
	porker.addAnim('porkerbop', 'Porker FG', 24, true);
    porker.playAnim('porkerbop');
	porker.scrollFactor.x = 1.4;
    add(porker);

    new FlxTimer().start(1.5, () -> chamber.playAnim('a'));
}

var mult:Float = 2 * 10;

function update() {
    if (FlxG.keys.pressed.Q) FlxG.camera.zoom += 0.01;
    if (FlxG.keys.pressed.E) FlxG.camera.zoom -= 0.01;

    if (controls.LEFT) FlxG.camera.scroll.x -= mult;
    if (controls.RIGHT) FlxG.camera.scroll.x += mult;

    if (controls.UP) FlxG.camera.scroll.y -= mult;
    if (controls.DOWN) FlxG.camera.scroll.y += mult;

    if (controls.BACK)
        FlxG.switchState(new ModState('NewMenu'));
}