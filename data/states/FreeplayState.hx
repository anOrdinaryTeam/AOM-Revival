/*
    DO NOT DELETE
    IN CASE SOMETHING GOES WRONG
    THIS WILL BE THE FALLBACK
*/

import funkin.backend.chart.Chart;

function create() {
    var newSongList:Array<ChartMetaData> = [];

    for (newSongs in getModSongList(currentMod).songs)
        newSongList.push(Chart.loadChartMeta(newSongs));
    songs = newSongList;
}

function postCreate() {
    var newIcons:Array<HealthIcon> = [];

    for (i => str in getModSongList(currentMod).icon) {
        var icon:HealthIcon = new HealthIcon(str);
		icon.sprTracker = grpSongs.members[i];
		if (Math.max(icon.width, icon.height) > 150) icon.setUnstretchedGraphicSize(150, 150);
        add(icon);
        newIcons.push(icon);
    }

    if (currentMod != 'RandomSongs') {        
        final newBG:FlxSprite = new FlxSprite().loadGraphic(getModPath('menuBG'));
        newBG.setGraphicSize(1280, 720);
        newBG.updateHitbox();
        newBG.screenCenter();
        insert(members.indexOf(bg), newBG);
    }
    bg.visible = currentMod == 'RandomSongs';

    for (oldIcons in iconArray) oldIcons.visible = false;
    iconArray = newIcons;
    changeSelection(lastSongSelected);
}

function onChangeSelection(e)
    lastSongSelected = e.value;