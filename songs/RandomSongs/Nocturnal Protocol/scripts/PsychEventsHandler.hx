// Typedefs are not supported so
class PsychEvent
{
    public var strumTime:Float = 0;
    public var event:String = '';

    public var value1:String = '';
    public var value2:String = '';

    public function new(name:String, v1:String, v2:String, time:Float)
    {
        this.event = name;
        this.strumTime = time;

        this.value1 = v1;
        this.value2 = v2;
    }
}

// scripted events loading
var eventsNotFound:Array<String> = [];
var eventsLoaded:Array<String> = [];
var defaultEvents:Array<String> = [
    'Add Camera Zoom',
    'Play Animation',
    'Change Scroll Speed',
];

var Events:Array<PsychEvent> = [];
var doTestingTraces:Bool = true;

function create() {
    loadEvents('songs/$songName/PsychEvents');
    Events.sort(sortTy);

    if (doTestingTraces) {
        var totalEventsCount:Int = Events.length - 1;

        trace('- TOTAL EVENTS [$totalEventsCount]');
        if (eventsLoaded.length > 0) trace('- SCRIPTED EVENTS LOADED: $eventsLoaded');
        if (eventsNotFound.length > 0) trace('- SCRIPTED EVENTS NOT FOUND: $eventsNotFound');
    }
}

function loadEvents(file:String) {
    var data:Dynamic = CoolUtil.parseJson(Paths.file('$file.json')).events;

    if (data != null && data.length > 0) for (EventData in data) for (i in 0...EventData[1].length) {
        final name:String = EventData[1][i][0];
        final time:Float = EventData[0];
        final values:Array<String> = [EventData[1][i][1], EventData[1][i][2]];

        var event:PsychEvent = new PsychEvent(name, values[0], values[1], time);
        Events.push(event);
        loadScriptedEvent(event);
        scripts.call('onEventPushed', [name, values[0], values[1], time]);
    }
}

function loadScriptedEvent(event:PsychEvent) if (event != null) {
    var eventName:String = event.event;
    var exists:Bool = Assets.exists(Paths.script('songs/$songName/events/$eventName'));

    if ((!defaultEvents.contains(eventName) && !eventsLoaded.contains(eventName)) && exists) {
        importScript('songs/$songName/events/$eventName');
        eventsLoaded.push(eventName);
    }
    else if (!exists && !defaultEvents.contains(eventName) && !eventsNotFound.contains(eventName))
        eventsNotFound.push(eventName);
}

function postUpdate()
    checkEvents();

function checkEvents() if (Events.length > 0) {
    var event:PsychEvent = Events[0];
    var curTime:Float = event.strumTime;

    if (curTime <= Conductor.songPosition) {
        triggerEvent(event.event, event.value1, event.value2, 'EVENTS FILE');
        Events.shift();
    }
}

var songSpeedTween:FlxTween;

public function triggerEvent(name:String, value1:String, value2:String, ?from:String) {
    var fromNL:String = from ?? 'SCRIPTS'; // istg the fucking null

    var v1:String = value1;
    var v2:String = value2;

    var flv1:Null<Float> = Std.parseFloat(v1);
    var flv2:Null<Float> = Std.parseFloat(v2);
    if(Math.isNaN(flv1)) flv1 = null;
	if(Math.isNaN(flv2)) flv2 = null;

    if (doTestingTraces)
        trace('Executing Event ($fromNL): $name - [v1: $v1 - v2: $v2]');

    switch(name) {
        case 'Add Camera Zoom':
            if (Options.camZoomOnBeat && FlxG.camera.zoom < 1.35) {
                FlxG.camera.zoom += flv1 ?? 0.015;
				camHUD.zoom += flv2 ?? 0.03;
            }
        case 'Play Animation':
			var char:Character = dad;

			switch(v2.toLowerCase()) {
				case 'bf' | 'boyfriend': char = boyfriend;
				case 'gf' | 'girlfriend': char = gf;
				default:
					if(flv2 == null) flv2 = 0;
					switch(Math.round(flv2)) {
						case 1: char = boyfriend;
						case 2: char = gf;
					}
			}

			char?.playAnim(v1, true);
        
        case 'Change Scroll Speed':
            if (Math.isNaN(flv1)) flv1 = 1;
            if (Math.isNaN(flv2)) flv2 = 0;

            var newValue:Float = PlayState.SONG.scrollSpeed * flv1;
            if (flv2 <= 0)
                scrollSpeed = newValue;
            else
                songSpeedTween = FlxTween.tween(this, {scrollSpeed: newValue}, flv2, {ease: FlxEase.linear, onComplete: () -> songSpeedTween = null});
        default:
            scripts.call('onPsychEvent', [name, v1, v2]);
    }
}

// stealed from https://github.com/Stilic/FNF-LOVE/blob/main/funkin/backend/conductor.lua#L11 sorry
function sortTy(a, b) return a.strumTime < b.strumTime;