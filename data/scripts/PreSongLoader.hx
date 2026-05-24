import openfl.system.Capabilities;
import hxvlc.flixel.FlxVideoSprite;

var preloaded:Bool = false;
var bgLoading:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
var loadingText:FlxText = new FlxText(0, 0, 0, 'Loading Videos..', 50);

function preEnterSong(song) switch(song) {
    case 'Fatality':
    	#if !ARKOSE_PORT
        var determineScale:Float = switch(Capabilities.screenResolutionY) {
            default: 0.9;
            case 768 | 1080: 0.75;
            case 720: 0.6;
        }
        windowShit(960, 720, determineScale);
        window.resizable = false;
        #end
    case 'Silly Billy':
        if (!preloaded) {
            var videos:Array<String> = ['open', 'SO_STAY_FINAL'];
            var totalLoaded:Int = 0;
            createLoadingScreen(2);

            for (vid in videos) {
                var video:FlxVideoSprite = new FlxVideoSprite();
                video.load(Paths.video('SillyBilly/$vid'));
                video.alpha = 0.001;
                add(video);
                
                video.play();
                video.bitmap.onPlaying.add(() -> {
                    if (totalLoaded < 2)
                        totalLoaded++;
                    else
                        allowSongLoading();
                });
            }
        }
    case 'Looping The Rooms':
        if (!preloaded) {
            LOAD_SONG = false;
            createLoadingScreen(1);

            var video:FlxVideoSprite = new FlxVideoSprite();
            video.load(Paths.video('LPR/loopingtherooms'));
            video.alpha = 0.001;
            add(video);

            video.play();
            video.bitmap.onPlaying.add(allowSongLoading);
        }
}

function allowSongLoading() {
    trace('Preloaded. Moving to Song');
    LOAD_SONG = true;
    preloaded = true;

    enterSong();
    removeLoadingScreen();
}

function createLoadingScreen(totalVids:Int) {
    trace('Preloading Videos..');
    bgLoading.alpha = 0.5;
    add(bgLoading);

    loadingText.text += ' - [$totalVids]';
    loadingText.antialiasing = true;
    loadingText.screenCenter();
    add(loadingText);
}

function removeLoadingScreen() {
    remove(bgLoading, true);
    remove(loadingText, true);
}