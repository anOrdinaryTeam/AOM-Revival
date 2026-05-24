import haxe.format.JsonPrinter;

public var playerCam:FlxPoint = FlxPoint.get(900, 600);
public var opponentCam:FlxPoint = FlxPoint.get(300, 600);
public var forceCamPos:Bool = false;
public var rawJson:Dynamic = null;

var fileExists:Bool = false;
var metaSongExists:Bool = false;
public var stageName:String = PlayState.SONG.stage;
public var useStageData:Bool = true;

function create() {
    fileExists = Assets.exists(Paths.json('stagesData/$stageName'));
    metaSongExists = Assets.exists(Paths.getPath('songs/$songName/meta.json'));
    scripts.call('preStageLoad');

    if (!useStageData)
        return;

    if (!fileExists) {
        trace('$stageName.json doesnt exists-');
        return;
    }

    rawJson = CoolUtil.parseJson(Paths.json('stagesData/$stageName'));

    if (rawJson.startCamPos != null) {
        var offs:Array<Float> = rawJson.startCamPos.copy();
        camFollow?.setPosition(offs[0], offs[1]);
    }

    // player shit
    if (rawJson.playerPos != null) {
        var offs:Array<Float> = rawJson.playerPos.copy();
        boyfriend?.setPosition(offs[0], offs[1]);
    }

    if (rawJson.playerCamPos != null) {
        var offs:Array<Float> = rawJson.playerCamPos.copy();
        playerCam?.set(offs[0], offs[1]);
    }

    // opponent shit
    if (rawJson.opponentPos != null) {
        var offs:Array<Float> = rawJson.opponentPos.copy();
        dad?.setPosition(offs[0], offs[1]);
    }

    if (rawJson.opponentCamPos != null) {
        var offs:Array<Float> = rawJson.opponentCamPos.copy();
        opponentCam?.set(offs[0], offs[1]);
    }

    // gf shit
    if (rawJson.gfPos != null) {
        var offs:Array<Float> = rawJson.gfPos.copy();
        gf?.setPosition(offs[0], offs[1]);
    }
}

function postCreate() if (CREATE_FILE_FEATURE) {
    if (!fileExists) {
        trace('Creating automatically StageMetaData File..');
        try {
            var content:Dynamic = {
                "startCamPos": [600, 600],
                "gfPos": [gf?.x, gf?.y],

                "playerPos": [boyfriend?.x, boyfriend?.y],
                "playerCamPos": [boyfriend?.getMidpoint().x, boyfriend?.getMidpoint().y],

                "opponentPos": [dad?.x, dad?.y],
                "opponentCamPos": [dad?.getMidpoint().x, dad?.getMidpoint().y],
            };
            var _file:String = JsonPrinter.print(content, null, '\t');

            CoolUtil.safeSaveFile(
                '${Paths.getAssetsRoot()}/data/stagesData/$stageName.json',
                _file
            );

            trace('Created! [$stageName.json]');
        }
        catch(e:Dynamic)
            trace(e.toString());
    }

    // extra step in case this chart has been/is gonna be converted into a cne chart
    if (!metaSongExists) {
        trace('Creating automatically meta.json File..');
        try {
            var content = {
                "bpm": PlayState.SONG.meta.bpm ?? 150,
                "icon": dad.getIcon(),
            };
            var _file:String = JsonPrinter.print(content, null, '\t');

            CoolUtil.safeSaveFile(
                '${Paths.getAssetsRoot()}/songs/$songName/meta.json',
                _file
            );
            trace('Created! [meta.json]');
        }
        catch(e:Dynamic)
            trace(e.toString());
    } 
}

public function setCamPos(?x:Float, ?y:Float) {
    forceCamPos = !forceCamPos;
    if (x != null && y != null) camFollow.setPosition(x, y);
}

function onCameraMove(_) {
    if (!forceCamPos && useStageData) {
        var newPoint:FlxPoint = curCameraTarget == 0 ? opponentCam : playerCam;
        _.position.set(newPoint.x, newPoint.y);
    }
    else if (forceCamPos && !_.cancelled) {
        _.position.set(camFollow.x, camFollow.y);
    }
}