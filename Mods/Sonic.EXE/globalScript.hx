var camIntro:FlxCamera = new FlxCamera();
var blackIntro:FlxSprite = new FlxSprite().makeSolid(1280, 720, FlxColor.BLACK);
var circle:FlxSprite = new FlxSprite();
var text:FlxSprite = new FlxSprite();

var doIntro:Bool = false;
var isSunky:Bool = false;
introLength = 0;

function create() {
    var let:Bool = switch(songName) {
        default: true;
        case 'Black Sun' | 'Chaos' | 'Sunshine': false;
    }

    if (let) {
        doIntro = true;
        isSunky = songName == 'Milk';

        camIntro.bgColor = 0;
        FlxG.cameras.add(camIntro, false);

        blackIntro.camera = camIntro;
        add(blackIntro);

        var circleDir:String = isSunky ? 'startScreens/Milk' : 'startScreens/$songName/Circle';
        circle.loadGraphic(getModImage(circleDir));
        circle.antialiasing = Options.antialiasing;
        circle.camera = camIntro;
        circle.x += isSunky ? 55 : 777;
        if (isSunky) circle.scale.x = 0;
        add(circle);

        if (!isSunky) {
            text.loadGraphic(getModImage('startScreens/$songName/Text'));
            text.antialiasing = Options.antialiasing;
            text.camera = camIntro;
            text.x -= 1200;
            add(text);
        }
    }
}

function postCreate() {
    useCamMov = true;
    loadHud('KadeEngine', '1.5.4');
    setRatingPrefix('EXE');
}

var startSong:Bool = false;
function onStartCountdown(e) if (doIntro) {
    if (!startSong) {
        e.cancel();
        startSong = true;
    }

    if (!isSunky) {
        new FlxTimer().start(0.6, () -> {
		    FlxTween.tween(circle, {x: 0}, 0.5);
			FlxTween.tween(text, {x: 0}, 0.5);
		});

		new FlxTimer().start(1.9, () -> {
			FlxTween.tween(circle, {alpha: 0}, 1);
			FlxTween.tween(text, {alpha: 0}, 1);
			FlxTween.tween(blackIntro, {alpha: 0}, 1, {onComplete: destroyIntroSprites});

            startCountdown();
		});
    }
    else {
        new FlxTimer().start(0.6, () -> {
            playModSound('flatBONK');
		    FlxTween.tween(circle.scale, {x: 1}, 0.2, {ease: FlxEase.elasticOut});
		});
        
        new FlxTimer().start(1.9, () -> {
			FlxTween.tween(circle, {alpha: 0}, 1);
			FlxTween.tween(blackIntro, {alpha: 0}, 1, {onComplete: destroyIntroSprites});

            startCountdown();
		});
    }
}

function destroyIntroSprites() {
    remove(circle, true);
    if (text != null) remove(text, true);
    remove(blackIntro, true);
}

function onNoteCreation(_) if (songName != 'Endless')
    _.note.splash = 'EXE/blood';