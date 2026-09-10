defaultCamZoom = 0.8;
introLength = 0;

public var fog:FlxSprite;
public var camOther:FlxCamera = new FlxCamera();

public function FrostPath(str:String)
    return getModImage('Frostbite/$str');

function create() {
    camMoveAmt = 10;
    camOther.bgColor = 0;
    FlxG.cameras.add(camOther, false);

    var background:FlxSprite = new FlxSprite(-800, -300, FrostPath('bg'));
	background.antialiasing = Options.antialiasing;
	background.scrollFactor.set(0.6, 0.6);
	background.active = false;
	addSprite(background);
	
	var charizard:FlxSprite = new FlxSprite(-50, -50, FrostPath('Charizard'));
	charizard.setGraphicSize(Std.int(charizard.width * 0.5));
	charizard.updateHitbox();
	charizard.antialiasing = Options.antialiasing;
	charizard.scrollFactor.set(0.7, 0.7);
	charizard.active = false;
	addSprite(charizard);

	var blastoise:FlxSprite = new FlxSprite(-400, 100, FrostPath('Blastoise'));
	blastoise.setGraphicSize(Std.int(blastoise.width * 0.4));
	blastoise.updateHitbox();
	blastoise.antialiasing = Options.antialiasing;
	blastoise.scrollFactor.set(0.8, 0.8);
	blastoise.active = false;
	addSprite(blastoise);

	var pokemons:FlxSprite = new FlxSprite(300, 200, FrostPath('Pokemons'));
	pokemons.setGraphicSize(Std.int(pokemons.width * 0.25));
	pokemons.updateHitbox();
	pokemons.antialiasing = Options.antialiasing;
	pokemons.scrollFactor.set(0.9, 0.9);
	pokemons.active = false;
	addSprite(pokemons);

    fog = new FlxSprite().loadGraphic(FrostPath('fog'));	
	fog.antialiasing = Options.antialiasing;
	fog.scrollFactor.set(0.0, 0.0);
    fog.camera = camOther;
	fog.screenCenter();
	fog.alpha = 0.25;
	add(fog);
}

function postCreate() {
    var playerPos:Array<Float> = [for (i in player) i.x];
    var cpuPos:Array<Float> = [for (i in cpu) i.x];

    for (i in 0...cpuPos.length) {
        player.members[i].x = cpuPos[i];
        cpu.members[i].x = playerPos[i];
    }

    healthBar.flipX = true;
    updateIconPositions = () -> {
        var iconOffset:Int = 26;
        var healthBarPercent:Float = ((2 - health) * 50);
        var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBarPercent, 0, 100, 1, 0);

		iconP1.health = 1 - (healthBarPercent / 100);
		iconP1.x = center - (iconP1.width - iconOffset);

		iconP2.x = center - iconOffset;
        iconP2.health = healthBarPercent / 100;
    }
}

function postUpdate() if (!forceCamPos) switch(strumLines.members[1].characters[0].animation.curAnim.name) {
    case "singLEFT", "singLEFT-alt": follow([-camMoveAmt, 0]);
    case "singDOWN", "singDOWN-alt": follow([0, camMoveAmt]);
    case "singUP", "singUP-alt": follow([0, -camMoveAmt]);
    case "singRIGHT", "singRIGHT-alt": follow([camMoveAmt, 0]);
}

function follow(offsets:Array<Float>) {
    camFollow.x += offsets[0];
    camFollow.y += offsets[1];
}

// function onPlayerHit(e)
//     e.showRating = false;