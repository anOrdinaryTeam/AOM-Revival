import openfl.system.Capabilities;
import hxvlc.flixel.FlxVideoSprite;

var preloaded:Bool = false;

function preEnterSong(song) switch(song) {
    case 'Fatality':
    	#if !ARKOSE_PORT
        ORIGINAL_RES = [window.width, window.height];
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

            for (vid in videos) {
                var video:FlxVideoSprite = new FlxVideoSprite();
                video.load(Paths.video('SillyBilly/$vid'));
                video.alpha = 0.001;
                add(video);
                
                video.play();
                video.bitmap.onPlaying.add(() -> {
                    totalLoaded++;

                    if (totalLoaded >= 2) {
                        LOAD_SONG = true;
                        preloaded = true;
                        enterSong();
                        trace('Preloaded. Moving to Song');
                    }
                });
            }
        }
    case 'Looping The Rooms':
        if (!preloaded) {
            LOAD_SONG = false;
            trace('Preloading Videos..');

            var video:FlxVideoSprite = new FlxVideoSprite();
            video.load(Paths.video('LPR/loopingtherooms'));
            video.alpha = 0.001;
            add(video);

            video.play();
            video.bitmap.onPlaying.add(() -> {
                LOAD_SONG = true;
                preloaded = true;
                enterSong();
                trace('Preloaded. Moving to Song');
            });
        }
}