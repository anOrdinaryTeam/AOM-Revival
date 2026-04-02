import flixel.addons.display.FlxBackdrop;

static function DokiPath(str:String)
    return getModImage('Epiphany/$str');

public var popup:FunkinSprite = new FunkinSprite(312, 432);

function create() {
    var posX:Float = -250;
    var posY:Float = -167;
	defaultCamZoom = 0.8;

    var space:FlxBackdrop = new FlxBackdrop(DokiPath('Sky'), 0.1, 0.1);
    space.antialiasing = Options.antialiasing;
	space.velocity.set(-10, 0);
    addSprite(space);

    var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(DokiPath('BG'));
	bg.antialiasing = Options.antialiasing;
	bg.scrollFactor.set(0.4, 0.6);
	addSprite(bg);

    var stageFront:FlxSprite = new FlxSprite(-332, -77).loadGraphic(DokiPath('FG'));
	stageFront.antialiasing = Options.antialiasing;
	stageFront.scrollFactor.set(1, 1);
	addSprite(stageFront);
}

function postCreate() {
    loadHud('KadeEngine', 'no me acuerdo');
    iconP1.setIcon('bf');
    healthBar.createColoredFilledBar(FlxColor.fromString('#31B0D1'));
    healthBar.updateBar();

    popup.loadSprite(DokiPath('bigika_delete'));
    popup.addAnim('show', 'PopUpAnim', 24, false);
	popup.antialiasing = Options.antialiasing;
    popup.alpha = 0.001;
    add(popup);
}

function onStrumCreation(_)
    _.sprite = "modNotes/Epiphany/default";
function onNoteCreation(_) {
    _.noteSprite = "modNotes/Epiphany/default";
    _.note.splash = 'doki';
}