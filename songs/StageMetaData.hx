// ease's position of the camera, more tough but more easy for characters with custom skins
public var playerCam:FlxPoint = FlxPoint.get(900, 600);
public var opponentCam:FlxPoint = FlxPoint.get(300, 600);

function create() {
    var stageName:String = CoolUtil.parseJson(Paths.getPath('songs/$songName/charts/$curDiff.json')).song.stage;
    if (!Assets.exists(Paths.json('stagesData/$stageName'))) {
        trace('$stageName.json doesnt exists');
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

function onCameraMove(_) {
    var newPoint:FlxPoint = curCameraTarget == 0 ? opponentCam : playerCam;
    _.position.set(newPoint.x, newPoint.y);
}