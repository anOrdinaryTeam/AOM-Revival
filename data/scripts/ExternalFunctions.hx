using StringTools;

public static var pathSuffix:String = 'Assets-';

public static function playModSound(str:String, vol:Float = 1)
    FlxG.sound.play(Paths.getPath(pathSuffix + '$currentMod/sounds/$str.ogg'), vol);

public static function playSound(str:String, vol:Float = 1)
    FlxG.sound.play(Paths.sound(str), vol);

public static function getImage(str:String)
    return Paths.image(str);

public static function getModPath(str:String)
    return Paths.getPath(pathSuffix + '$currentMod/images/$str.png');

public static function getModSongList(mod:String):Dynamic
{
    var data = {songs: [], icon: []}
    var isRandomSection:Bool = mod == 'RandomSongs';

    try {
        var _file:Array<String> = CoolUtil.coolTextFile(Paths.file(pathSuffix + '$mod/songList.txt'));
        var format:String = isRandomSection ? '::' : ':';
        
        for (raw in _file) {
            var info:Array<String> = raw.split(format);
            data.songs.push(info[0]);
            data.icon.push(info[1]);
        }

    }
    catch(e:Dynamic) {
        trace(e.toString());
        data.songs.push('ERROR');
        data.songs.icon('face');
    }

    return data;
}

public static function getSongPages(_song:String):Array<String> try {
    var song:String = _song;
    var pages:Array<String> = [];
    var file:Array<String> = CoolUtil.coolTextFile(Paths.file(pathSuffix + 'RandomSongs/songList.txt'));

    for (songs in file) {
        var vars:Array<String> = songs.split('::');
        var songInLoop:String = vars[0];

        if (song == songInLoop) {
            for (i => content in vars)
                if (i < 2)
                    continue;
                else
                    pages.push(content);

            break;
        }
    }

    return pages;
}
catch(e:String)
    trace(e.toString());

public static function getPageIcon(_url:String):String {
    var urlName:String = getWebName(_url);
    var icon:String = switch(urlName) {
        case 'github': 'GH';
        case 'gamejolt': 'GJ';
        case 'gamebanana': 'GB';
        case 'youtube' | 'youtu' | 'm': 'YT';
        default: 'missing-icon';
    };

    // trace('Web: $urlName - Icon: $icon');
    return icon;
}

function getWebName(url:String):String {
    var noProtocol:String = url.split('://')[1];
    var host:String = noProtocol.split('/')[0];

    if (host.startsWith('www.'))
        host.subtr(4);

    var result:String = host.split('.')[0];
    return result;
}

// preventive
public function findModSong(song:String) {
    var getModsList:Array<String> = loadModFolders();
    var modResult:String = '';

    for (mod in getModsList) {
        var songList:Array<String> = CoolUtil.coolTextFile(Paths.file(pathSuffix + '$mod/songList.txt'));

        for (i in 0...songList.length) {
            var name:String = songList[i].split(':')[0];

            if (name.toLowerCase() == song.toLowerCase()) {
                modResult = mod;
                trace('Found Mod From Song: $mod');
                break;
            }
        }
    }

    if (modResult != '')
        currentMod = modResult;
    else
        trace('Mod Not Found');
}

// Functions from https://discord.com/channels/860561967383445535/1490173810585108622
public static function getColorValue(color:Int, rgb:String):Int
    return switch (rgb)
    {
        default: (Std.int(color) >> 16) & 0xFF;
        case "g": (Std.int(color) >> 8) & 0xFF;
        case "b": Std.int(color) & 0xFF;
    }

public static function getColorArray(color:Int):Array<Float>
    return [
        getColorValue(color, "r") / 255,
        getColorValue(color, "g") / 255,
        getColorValue(color, "b") / 255
    ];