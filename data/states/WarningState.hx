import funkin.backend.system.macros.GitCommitMacro;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import funkin.backend.MusicBeatState;

var commit:String = GitCommitMacro.commitHash;

function postCreate() {
    FlxG.camera.flash(0xFF000000, .3);

    disclaimer.text = '*anOrdinaryModpack* is a recompilation of the Golden Era of \n#Friday Night\' Funkin.#\n\nFor the mod to work properly, use the latest Nightly Build version of CodenameEngine.\n\nPlease report any bug in the GitHub/Gamebanana page.\n\n_Press ENTER to continue._';
    disclaimer.applyMarkup(disclaimer.text, [
        new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF0000), '*'),
        new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF3FAC), '#'),
        new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFF00), '_')
    ]);
    disclaimer.y -= 45;
    titleAlphabet.y -= 100;

    var warnImage:FlxSprite = new FlxSprite(900, 200, getImage('Menu/warning/12-12-2025'));
    warnImage.setGraphicSize(Std.int(warnImage.width * 1.75));
    warnImage.alpha = 0;
    insert(0, warnImage);

    FlxTween.tween(warnImage, {alpha: .04}, 20, {startDelay: 5});

    if (commit == '9757b00') {
        var IMSOFUKINGANGRY:FunkinText = new FunkinText(16, 0, FlxG.width - 32, '', 32);
        IMSOFUKINGANGRY.y = disclaimer.y + 300;
        IMSOFUKINGANGRY.text = 'YOU\'RE NOT USING THE NIGHTLY BUILD\n\nPRESS *ESC* TO GO TO THE CNE PAGE AND DOWNLOAD THE\n#EXPERIMENTAL VERSION#';
        IMSOFUKINGANGRY.applyMarkup(IMSOFUKINGANGRY.text, [
            new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFF00), '*'),
            new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF0000), '#')
        ]);
        IMSOFUKINGANGRY.font = Paths.font('vcr.ttf');
        IMSOFUKINGANGRY.alignment = 'center';

        IMSOFUKINGANGRY.scale.set(.75, .75);
        IMSOFUKINGANGRY.alpha = .5;
        add(IMSOFUKINGANGRY);
    }
}

function update() {
    if (controls.BACK && commit == '9757b00')
        CoolUtil.openURL('https://codename-engine.com/');
}