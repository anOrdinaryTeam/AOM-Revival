import haxe.format.JsonPrinter;

// ease's position of the camera, more tough but more easy for characters with custom skins
public var playerCam:FlxPoint = FlxPoint.get(900, 600);
public var opponentCam:FlxPoint = FlxPoint.get(300, 600);

var fileExists:Bool = false;
var metaSongExists:Bool = false;
public var stageName:String = PlayState.SONG.stage;

function create() {
    fileExists = Assets.exists(Paths.json('stagesData/$stageName'));
    metaSongExists = Assets.exists(Paths.getPath('songs/$songName/meta.json'));
    scripts.call('preStageLoad');

    if (!fileExists) {
        trace('$stageName.json doesnt exists-');
        return;
    }

    var raw:Dynamic = CoolUtil.parseJson(Paths.json('stagesData/$stageName'));

    if (raw.startCamPos != null) {
        var offs:Array<Float> = raw.startCamPos.copy();
        camFollow.setPosition(offs[0], offs[1]);
    }

    // player shit
    if (raw.playerPos != null) {
        var offs:Array<Float> = raw.playerPos.copy();
        boyfriend.setPosition(offs[0], offs[1]);
    }

    if (raw.playerCamPos != null) {
        var offs:Array<Float> = raw.playerCamPos.copy();
        playerCam.set(offs[0], offs[1]);
    }

    // opponent shit
    if (raw.opponentPos != null) {
        var offs:Array<Float> = raw.opponentPos.copy();
        dad.setPosition(offs[0], offs[1]);
    }

    if (raw.opponentCamPos != null) {
        var offs:Array<Float> = raw.opponentCamPos.copy();
        opponentCam.set(offs[0], offs[1]);
    }

    // gf shit
    if (raw.gfPos != null) {
        var offs:Array<Float> = raw.gfPos.copy();
        gf.setPosition(offs[0], offs[1]);
    }
}

function postCreate() {
    if (!fileExists && CREATE_FILE_FEATURE) {
        trace('Creating automatically StageMetaData File..');
        try {
            var content:Dynamic = {
                "startCamPos": [600, 600],
                "gfPos": [gf.x, gf.y],

                "playerPos": [boyfriend.x, boyfriend.y],
                "playerCamPos": [boyfriend.getMidpoint().x, boyfriend.getMidpoint().y],

                "opponentPos": [dad.x, dad.y],
                "opponentCamPos": [dad.getMidpoint().x, dad.getMidpoint().y],
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
    if (!metaSongExists && CREATE_FILE_FEATURE) {
        trace('Creating automatically meta.json File..');
        try {
            var content = {
                "bpm": PlayState.SONG.meta.bpm ?? 150,
                "icon": dad.icon ?? "face",
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

function onCameraMove(_) {
    var newPoint:FlxPoint = curCameraTarget == 0 ? opponentCam : playerCam;
    _.position.set(newPoint.x, newPoint.y);
}