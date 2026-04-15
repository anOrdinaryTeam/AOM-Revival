var grabbedInput:Bool = false;
var cancelAnimations:Bool = false;
var misc = [0.7, 150, 150, -60];

var notesToHit:FlxTypedGroup<FunkinSprite> = new FlxTypedGroup();
var notes:Array<String> = ['Left', 'Down', 'Up', 'Right'];
var notesToHit_Input:Array<String> = [];

var vineSpr:FunkinSprite;
var curVine:Int = 0;

function create() {
    vineSpr = new FunkinSprite(dad.x + 500, dad.y + 430, getModImage('maze/vines'));
    vineSpr.addAnim('catch', 'Vine Whip instance 1', 24, false);
    vineSpr.scale.set(0.8, 0.8);
    vineSpr.updateHitbox();
    vineSpr.alpha = 0.001;
    insert(members.indexOf(dad), vineSpr);

    add(notesToHit);
}

function GRAB() {
    notesToHit_Input = [];
    notesToHit.clear();
    
    vineSpr.alpha = 1;
    vineSpr.playAnim('catch');

    new FlxTimer().start(1.45, function() {
        cancelAnimations = true;

        playModSound('bf_grabbed_by_vine');
        boyfriend.playAnim('catch');
        boyfriend.animation.finishCallback = function() {
            boyfriend.playAnim('catch-loop');
        }

        for (i in 0...notes.length) {
            var selectNote:String = notes[FlxG.random.int(0, notes.length - 1)];
            notesToHit_Input.push(selectNote);

            var NOTE:FunkinSprite = new FunkinSprite((boyfriend.x + misc[3]) + (misc[1] * i), boyfriend.y + misc[2]);
            NOTE.loadSprite(getModImage('maze/notes'));
            NOTE.scale.set(misc[0], misc[0]);
            NOTE.updateHitbox();
            NOTE.addAnim(selectNote, selectNote, 0, false);
            NOTE.playAnim(selectNote);
            NOTE.antialiasing = Options.antialiasing;
            NOTE.alpha = 0.001;
            notesToHit.add(NOTE);

            FlxTween.tween(NOTE, {alpha: 1}, 0.3, {onComplete: () -> grabbedInput = true});
        }
    });
}

function onInputUpdate(_) if (grabbedInput)
    _.cancel();

function checkWhichPressed(key:String) {
    if (curVine != 4 && notesToHit_Input[curVine] == key) {
        FlxTween.tween(notesToHit.members[curVine], {alpha: 0}, 0.3);
        curVine += 1;
    }

    if (curVine == 4) {
        grabbedInput = false;
        curVine = 0;

        playModSound('bf_vine_defeat');
        boyfriend.playAnim('get free');
        boyfriend.animation.finishCallback = function(name:String) {
            if (name == 'get free') {
                cancelAnimations = false;
                playModSound('bf_axe_chop');
                boyfriend.dance();
            }
        }
        new FlxTimer().start(0.050, () -> vineSpr.playAnim('catch', false, true));
        vineSpr.animation.finishCallback = function() {
            if (!grabbedInput)
                vineSpr.alpha = 0;
        }
        trace('free');
    }
}

function onPlayerMiss(_) _.animCancelled = cancelAnimations;
function onPlayerHit(_) _.animCancelled = cancelAnimations;

function stepHit() switch(curStep) {
    case 383, 768, 1151, 1536, 1905, 2466, 2767, 3071, 4143:
        GRAB();
}

function update(_) if (grabbedInput) {
    if (controls.NOTE_LEFT_P) checkWhichPressed('Left');
    if (controls.NOTE_DOWN_P) checkWhichPressed('Down');
    if (controls.NOTE_UP_P) checkWhichPressed('Up');
    if (controls.NOTE_RIGHT_P) checkWhichPressed('Right');
}