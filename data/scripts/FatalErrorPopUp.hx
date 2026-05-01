import flixel.math.FlxRandom;
import funkin.backend.MusicBeatGroup;

class FatalError extends MusicBeatGroup
{
    public var windowSpr:FunkinSprite;
    public var graphicDetector:FlxSprite;

    public var clickDetected:Bool = false;
    public var canDestroy:Bool = false;

    public function new(type:Int = 2) {
        super();
        var scale:Float = 1.75;

        if (type == 2) {
            type = 1;
            scale *= 1.2;
        }
        else if (type == 3) {
            type = 1;
            scale *= 1.5;
        }

        if (type == 1) {
            windowSpr = new FunkinSprite(0,0, getModImage('Fatality/error_popups'));
            windowSpr.addAnim('show', 'idle', 24, false);
            windowSpr.playAnim('show');
            windowSpr.setGraphicSize(Std.int(windowSpr.width * scale));
			windowSpr.updateHitbox();
            add(windowSpr);

            graphicDetector = new FlxSprite((88 + 34) * scale, (75 + 46) * scale);
            graphicDetector.makeSolid(Std.int(32 * scale), Std.int(16 * scale), -1);
            graphicDetector.alpha = 0.01;
            add(graphicDetector);
        }
    }

    public function closeWindow() {
        graphicDetector = null;
        clickDetected = true;

        windowSpr.animation.reverse();
        windowSpr.animation.callback = function(anim:String, frame:Int, idx:Int) {
            if ((frame + 1) <= 0)
                canDestroy = true;
        }
    }
}

var canSpawn:Bool = true;
var limiter:Bool = false;
var xy:FlxRandom = new FlxRandom(666);
var currentErrors:Array<FatalError> = [];
var camOther:FlxCamera = new FlxCamera();

function postCreate() {
    camOther.bgColor = 0;
    #if ARKOSE_PORT 
    camOther.width = 960;
    camOther.x += 160;
    #end
    FlxG.cameras.add(camOther, false);
}

function spawnPopUp(?amount:Int = 1, ?type:Int = 2) if (getSaveData('Fatality_SpawnPopUps')) {
    var finalAmount:Int = amount;

    if (getSaveData('Fatality_PopUpsLimiter')) {
        if (currentErrors.length == 5) finalAmount = 0;
        else finalAmount = finalAmount;
    }

    for (i in 0...finalAmount)
    {
        var error:FatalError = new FatalError(type);
        var cam:Dynamic = #if !ARKOSE_PORT FlxG; #else camHUD; #end
        var offset = [xy.int(0, Std.int(cam.width - error.width)), xy.int(0, Std.int(cam.height - error.height))];
        error.setPosition(offset[0], offset[1]);
        error.camera = camOther;
        add(error);
        currentErrors.push(error);
    }
}

public function clearPopUps() if (currentErrors.length > 0) {
    for (i in 0...currentErrors.length) {
        var window = currentErrors[i];
        window.closeWindow();
        new FlxTimer().start(0.2, function() {
            currentErrors.remove(window);
            remove(window);
        });
    }
}

function onEvent(_) {
    if (_.event.name == 'Spawn Error') {
        var amount:Int = _.event.params[0];
        var sizeType:Int = _.event.params[1];

        spawnPopUp(amount, sizeType);
    }

    if (_.event.name == 'Clear Error')
        clearPopUps();
}

function update(_) if (currentErrors.length > 0) for (i in 0...currentErrors.length) {
    var window = currentErrors[i];

    if (!window.clickDetected && FlxG.mouse.justPressed && window.graphicDetector.overlapsPoint(FlxG.mouse.getWorldPosition(camOther, window.graphicDetector._point), true, camOther)) {
        window.closeWindow();
        new FlxTimer().start(0.2, function() {
            currentErrors.remove(window);
            remove(window);
        });
    }
}