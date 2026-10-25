var spr:String = downscroll ? 'SpectreNoteDownscroll' : 'SpectreNote';
var noteFadeTime:Float = 0.0010;
var noteOpacity:Float = 0.5;
var spectreHit:Bool = false;
var enemySpectreHit:Bool = false;

function update(_) {
    var elapsed:Float = _;
    
    player.notes.forEach(function(note) {
        if (note.noteType == 'spectre')
            return;

        if (!spectreHit)
            if (noteFadeTime * elapsed > noteOpacity) noteOpacity = 0;
            else noteOpacity -= noteFadeTime * elapsed;
        else
            if (noteOpacity > 1) {
                noteOpacity = 1;
                spectreHit = false;
            }
            else
                noteOpacity += elapsed;
    
        var boundNoteOpacity = Math.max(0, Math.min(1, noteOpacity));
        note.alpha = boundNoteOpacity;
    });
}

function onNoteCreation(_) if (_.noteType == 'spectre') {
    _.note.alpha = 1;
    _.noteSprite = 'modNotes/Corruptro/$spr';
    _.note.forceIsOnScreen = true;
    // _.note.earlyPressWindow = 0.5;
	// _.note.latePressWindow = 0.5;
    // if (_.strumLineID <= 0) _.note.wasGoodHit = true;
}

function onPostNoteCreation(_) if (_.noteType == 'spectre')
	if (downscroll) _.note.frameOffset.y += 40;
    else _.note.frameOffset.y -= 20;

function onPlayerHit(_) if (_.noteType == 'spectre') {
    _.animCancelled = true;
    _.showSplash = false;
    playModSound('SpectreArrow');
    spectreHit = true;
    if (_.strumLineID == 0) FlxTween.tween(_.note, {alpha: 1}, 0.5);
    showSpectreEffect(_.direction, !_.player);
}

function onDadHit(_) if (_.noteType == 'spectre') {
    _.animCancelled = true;
    playModSound('SpectreArrow');
    showSpectreEffect(_.direction, !_.player);
}

function onPlayerMiss(_) if (_.noteType == 'spectre') {
    _.cancel();
    deleteNote(_.note);
}

function showSpectreEffect(id:Int, isOpp:Bool) {
    var idx:Int = (members.indexOf(strumLines) + 1);
    var spr:SpectreHitEffect = new SpectreHitEffect(id, isOpp);
    spr.camera = camHUD;
    insert(idx, spr);
}

class SpectreHitEffect extends FunkinSprite
{
    private var _reOffX:Float = -71.5;
    private var _reOffY:Float = PlayState.downscroll ? -50 : -64;
    private var sc:Float = 0.7;

    public function new(strumID:Int, isOpp:Bool)
    {
        super(_getX(strumID, isOpp) + _reOffX, _getY(strumID, isOpp) + _reOffY, getModImage('SpectreHit'));
        scale.set(sc, sc);
        updateHitbox();

        addAnim('anim', _getAnim(strumID), 24, false);
        playAnim('anim', true);
        this.animation.onFinish.add(function() {
            this.active = false;
            PlayState.instance.remove(this);
        });
    }

    private function _getAnim(id:Int) {
        var suffix:String = switch(id) {
            default: 'left';
            case 1: 'down';
            case 2: 'up';
            case 3: 'right';
        }
        return 'SpectreHit $suffix';
    }

    private function _getX(id:Int, isOpp:Bool)
        return !isOpp ? PlayState.instance.player.members[id].x : PlayState.instance.cpu.members[id].x;

    private function _getY(id:Int, isOpp:Bool)
        return !isOpp ? PlayState.instance.player.members[id].y : PlayState.instance.cpu.members[id].y;
}