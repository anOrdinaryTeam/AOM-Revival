import AomText;

public var hudItems:FlxTypedGroup<Dynamic> = new FlxTypedGroup();
var npsTimes:Array<Float> = [];

function onHudLoad(hud) if (hud == "Mic'dUpEngine") {
    hudItems.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, hudItems);

    for (icon in iconArray) {
        icon.bump = () -> {
            icon.setGraphicSize(Std.int(icon.width + 30));
	        icon.updateHitbox();
        };

        icon.updateBump = () -> {
            icon.setGraphicSize(Std.int(lerp(icon.width, 150, 0.09 / (Options.framerate / 60))));
            icon.updateHitbox();
        }
    }

    var strs:String = ['NPS: 0', 'Accuracy: N/A', 'Misses: 0', 'Score: 0'];
    for (i => str in strs) {
        var txt:AomText = new AomText(healthBarBG.x - healthBarBG.width / 2, healthBarBG.y - 26 * (3 - i), str, 0.26);
        txt.setFormat(-1, 'left', 'OUTLINE', 7, FlxColor.BLACK);
        txt.scrollFactor.set();
        hudItems.add(txt);
    }
}

function update(_) {
    while (npsTimes.length > 0 && Conductor.songPosition - npsTimes[0] > 1000)
        npsTimes.shift();

    hudItems.members[0].text = 'NPS: ' + npsTimes.length;
}

function onPlayerHit(_) if (_.player && !_.note.isSustainNote)
    npsTimes.push(Conductor.songPosition);

function onRatingUpdate(_) {
    hudItems.members[1].text = 'Accuracy: ' + CoolUtil.quantize(accuracy * 100, 100) + '%';
    hudItems.members[2].text = 'Misses: ' + misses;
    hudItems.members[3].text = 'Score: ' + songScore;
}