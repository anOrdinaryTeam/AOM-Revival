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
    var data = {
        songs: [],
        icon: [],
        color: []
    }

    try {
        var _file:Array<String> = CoolUtil.coolTextFile(Paths.file(pathSuffix + '$mod/songList.txt'));
        
        for (raw in _file) {
            var info:Array<String> = raw.split(':');
            data.songs.push(info[0]);
            data.icon.push(info[1]);
        }

        return data;
    }
    catch(e:Dynamic)
        trace(e.toString());
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
}