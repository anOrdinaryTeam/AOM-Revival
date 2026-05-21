var preArray:Array<String> = [];
var precachedChars:Array<String> = [];

function onEventPushed(name, v1, v2) if (name == 'Change Character') {
    var newChar:String = v2;
    var characterExists:Bool = Assets.exists(Paths.xml('characters/NP/$newChar'));
    var strumInt:Int = switch(StringTools.trim(v1).toLowerCase()) {
        default: 1;
        case '1' | 'dad' | 'opponent': 0;
        case '2' | 'gf' | 'girlfriend': 2;
    }

    if (characterExists && newChar != strumLines.members[strumInt].characters[0].curCharacter && !precachedChars.contains(newChar)) {
        precacheCharacter(strumInt, 'NP/$newChar');
        precachedChars.push(newChar);
    }
}

function postCreate() if (precachedChars.length > 0)
    trace('CHANGE CHARACTER - Precached Characters: $precachedChars');

function onPsychEvent(name, v1, v2) if (name == 'Change Character') {
    var strum:Int = switch(StringTools.trim(v1).toLowerCase()) {
        default: 1;
        case '1' | 'dad' | 'opponent': 0;
        case '2' | 'speaker' | 'gf' | 'girlfriend': 2;
    }
        
    changeCharacter(strum, 'NP/$v2');
}