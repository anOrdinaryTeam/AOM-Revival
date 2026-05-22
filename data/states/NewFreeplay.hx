import funkin.backend.chart.Chart;
importScript('data/scripts/PreSongLoader');

public var LOAD_SONG:Bool = true;

var songsList:Array<SongData> = [];
var grpSongs:FlxTypedGroup<Alphabet> = new FlxTypedGroup();
var grpIcons:FlxTypedGroup<HealthIcon> = new FlxTypedGroup();

var scoreTxt:FunkinText;
var difficultyTxt:FunkinText;

var curSelected:Int = 0;
var curDiff:Int = 1;
var allowInput:Bool = true;

function create() {
    CoolUtil.playMenuSong();
    changeToDefaultRPC('In The Freeplay - [$currentMod]');

    var bg:FlxSprite = new FlxSprite().loadGraphic(getModPath('menuBG'));
    bg.setGraphicSize(FlxG.width, FlxG.height);
    bg.updateHitbox();
    bg.screenCenter();
    bg.antialiasing = Options.antialiasing;
    add(bg);

    add(grpSongs);
    add(grpIcons);

    var iconsList:Array<String> = getModSongList(currentMod).icon.copy();
    for (song in getModSongList(currentMod).songs) {
        var metaData:SongData = new SongData(song, Chart.loadChartMeta(song).difficulties);
        songsList.push(metaData);
    }

    for (i => song in songsList) {
        var item:Alphabet = new Alphabet(0, 0, song.name, 'bold');
        item.isMenuItem = true;
        item.ID = i;
        item.antialiasing = Options.antialiasing;
        grpSongs.add(item);

        var icon:HealthIcon = new HealthIcon(iconsList[i]);
        icon.sprTracker = item;
        icon.ID = i;
        icon.antialiasing = Options.antialiasing;
        grpIcons.add(icon);
    }

    if (lastModSelected_Str == currentMod) {
        curSelected = lastSongSelected;
        curDiff = lastDiffSelected;
    }
    else {
        lastSongSelected = 0;
        lastDiffSelected = 0;
        lastModSelected_Str = currentMod;
    }

    var graphic:FlxSprite = new FlxSprite().makeSolid(350, 80, FlxColor.BLACK);
    graphic.x = (FlxG.width - graphic.width);
    graphic.alpha = 0.5;
    add(graphic);

    difficultyTxt = new FunkinText(0, 0, FlxG.width, '[? ? ?]', 27);
    difficultyTxt.alignment = 'center';
    difficultyTxt.x += 470;
    difficultyTxt.y += 40;
    difficultyTxt.antialiasing = true;
    add(difficultyTxt);

    scroll(0, true);
    #if ARKOSE_PORT
	addMobilePad("LEFT_FULL", "A_B");
	#end
}

function scroll(i:Int = 0, f:Bool = false) {
    if (i == 0 && !f) return;
    CoolUtil.playMenuSFX(0, 0.5);

    curSelected = FlxMath.wrap(curSelected + i, 0, songsList.length - 1);
    lastSongSelected = curSelected;
    updateDifficulties();

    var alphaUnselected:Float = 0.6;
    for (i => item in grpSongs.members) {
        var curIcon:HealthIcon = grpIcons.members[i];
        curIcon.alpha = curIcon.ID == curSelected ? 1 : alphaUnselected;

        item.alpha = item.ID == curSelected ? 1 : alphaUnselected;
        item.targetY = i - curSelected;
    }
}

function updateDifficulties(i:Int = 0) {
    var curSong:String = songsList[curSelected].name;
    var curSongDiffs:Array<String> = songsList[curSelected].difficulties.copy();

    curDiff = FlxMath.wrap(curDiff + i, 0, curSongDiffs.length - 1);
    lastDiffSelected = curDiff;
    difficultyTxt.text = '[${curSongDiffs[curDiff].toUpperCase()}]';
}

public function enterSong() {
    var songName:String = songsList[curSelected].name;
    var diff:String = songsList[curSelected].difficulties[curDiff];
    allowInput = false;
        
    Options.freeplayLastSong = songName;
	Options.freeplayLastDifficulty = diff;

    stateScripts.call('preEnterSong', [songName]);

    if (LOAD_SONG) {
        trace('Selected Song: $songName - ${diff.toUpperCase()}');
        PlayState.loadSong(songName, diff);
        FlxG.switchState(new PlayState());
    }
}

function update(dt) {
    if (FlxG.sound.music.volume < 0.8)
		FlxG.sound.music.volume += 0.5 * dt;

    if (allowInput) {
        scroll((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);

        if (controls.LEFT_P || controls.RIGHT_P)
            updateDifficulties((controls.LEFT_P ? -1 : 0) + (controls.RIGHT_P ? 1 : 0));

        if (controls.BACK) {
            allowInput = false;
            FlxG.switchState(new ModState('ModSelectorNew'));
        }

        if (controls.ACCEPT)
            enterSong();
    }
}

class SongData
{
    public var name:String = '';
    public var difficulties:Array<String> = [];

    public function new(name:String, difficulties:Array<String>) {
        this.name = name;
        this.difficulties = difficulties.copy();
    }
}