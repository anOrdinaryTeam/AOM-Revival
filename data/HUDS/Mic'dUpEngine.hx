import flixel.text.FlxTextBorderStyle;
public var hudItems:FlxTypedGroup<Dynamic> = new FlxTypedGroup();
doIconBop = false;
var npsTimes:Array<Float> = [];

function onHudLoad(hud) if (hud == "Mic'dUpEngine") {
    hudItems.camera = camHUD;
    insert(members.indexOf(iconP2) + 1, hudItems);

    for (i in 0...4) {
        var txt:FunkinText = new FunkinText(healthBarBG.x - healthBarBG.width / 2, healthBarBG.y - 26 * (3 - i), 0, 20);
        txt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 3, 1);
        txt.scrollFactor.set();
        hudItems.add(txt);

        switch(i) {
            case 0: txt.text = 'NPS: 0';
            case 1: txt.text = 'Accuracy: N/A';
            case 2: txt.text = 'Misses: 0';
            case 3: txt.text = 'Score: 0';
        }
    }
}

function update(_) {
    iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.width, 150, 0.09 / (Options.framerate / 60))));
    iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, 150, 0.09 / (Options.framerate / 60))));

    iconP1.updateHitbox();
    iconP2.updateHitbox();

    while (npsTimes.length > 0 && Conductor.songPosition - npsTimes[0] > 1000)
        npsTimes.shift();

    hudItems.members[0].text = 'NPS: ' + npsTimes.length;
}

function onPlayerHit(_) if (_.player && !_.note.isSustainNote)
    npsTimes.push(Conductor.songPosition);

function beatHit() {
    iconP1.setGraphicSize(Std.int(iconP1.width + 30));
    iconP2.setGraphicSize(Std.int(iconP2.width + 30));

    iconP1.updateHitbox();
    iconP2.updateHitbox();
}

function onRatingUpdate(_) {
    hudItems.members[1].text = 'Accuracy: ' + CoolUtil.quantize(accuracy * 100, 100) + '%';
    hudItems.members[2].text = 'Misses: ' + misses;
    hudItems.members[3].text = 'Score: ' + songScore;
}