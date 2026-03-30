public static var pathSuffix:String = 'Assets-';

public static function playModSound(str:String, vol:Float = 1)
    FlxG.sound.play(Paths.getPath('$pathSuffix' + '$currentMod/sounds/$str.ogg'), vol);

public static function getImage(str:String)
    return Paths.image(str);

public static function getModPath(str:String)
    return Paths.getPath('$pathSuffix' + '$currentMod/images/$str.png');

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

/* deprecated
public static function getModSongList(forMod:String):Dynamic {
    var finalList = {
        songs: [],
        icon: [],
        color: []
    }

    try {
        var raw:Dynamic = CoolUtil.parseJson(Paths.json('modsData/$forMod/songList'));

        for (data in raw.songs) {
            finalList.songs.push(data[0]);
            finalList.icon.push(data[1]);
            finalList.color.push(data[1]);
        }

        return finalList;
    }
    catch(e:Dynamic)
        trace(e.toString());
}
*/

// preventive
public function setManualPath(curSong:String) currentMod = switch(curSong) {
    case 'Wife Forever' | 'Sky' | 'Manifest': 'Sky';
    case 'Foolhardy' | 'Bushwhack': 'Zardy';
    case 'Screenplay' | 'Parasite' | 'A.G.O.T.I': 'Agoti';
    case 'Overwrite' | 'Inking Mistake' | 'Relighted': 'xEvent';
    default: 'RS';
}