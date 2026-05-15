import openfl.system.Capabilities;
import hxvlc.flixel.FlxVideoSprite;

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
        var videos:Array<String> = ['open', 'SO_STAY_FINAL'];
        for (vid in videos) {
            var video:FlxVideoSprite = new FlxVideoSprite();
            video.load(Paths.video('SillyBilly/$vid'));
            add(video);

            video.play();
            video.stop();
        }
    case 'Looping The Rooms':
        var video:FlxVideoSprite = new FlxVideoSprite();
        video.load(Paths.video('LPR/loopingtherooms'));
        add(video);

        video.play();
        video.stop();
}