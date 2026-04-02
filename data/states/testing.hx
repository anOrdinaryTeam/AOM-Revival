importScript('data/shaders');

function create() {
    var ugh:String = 'Assets-Tabi/images/stages/normal';
    FlxG.camera.zoom = 0.7;

    var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.file('$ugh/normal_stage.png'));
    bg.screenCenter();
    add(bg);

    var bf:Character = new Character(0, 0, 'boyfriend');
    bf.screenCenter();
    bf.y -= 200;
    add(bf);

    // bf.shader = applyVignette(2, 3);
    // FlxG.camera.addShader(applyVignette(0.6, 1));
}