public static var pathSuffix:String = 'Assets-';

public static function playModSound(str:String, vol:Float = 1)
    FlxG.sound.play(Paths.getPath('$pathSuffix' + '$currentMod/sounds/$str.ogg'), vol);

public static function playSound(str:String, vol:Float = 1)
    FlxG.sound.play(Paths.sound(str), vol);

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

// preventive
public function setManualPath(song:String) currentMod = switch(song) {
    case 'Screenplay' | 'Parasite' | 'A.G.O.T.I': 'Agoti';
    case 'Dream Of Peace' | 'Diagraphephobia' | 'Post Mortal' | 'Plaything' | 'System Failure': 'Eteled';
    case 'Wocky' | 'Beathoven' | 'Hairball' | 'Nyaw' | 'Flatzone': 'Kapi';
    case 'Wife Forever' | 'Sky' | 'Manifest': 'Sky';
    case 'My Battle' | 'Last Chance' | 'Genocide': 'Tabi';
    case 'Lo-Fight' | 'Overhead' | 'Ballistic' | 'Ballistic-OLD': 'Whitty';
    case 'Overwrite' | 'Inking Mistake' | 'Relighted': 'xEvent';
    default: 'RandomSongs';
}