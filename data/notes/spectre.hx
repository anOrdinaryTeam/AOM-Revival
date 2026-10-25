var spr:String = downscroll ? 'SpectreNoteDownscroll' : 'SpectreNote';
var noteFadeTime:Float = 0.0010;
var noteOpacity:Float = 0.5;
var spectreHit:Bool = false;
var enemySpectreHit:Bool = false;

var elapsed:Float = 0;
function postCreate() player.onNoteUpdate.add(SpectreAlpha);
function update(_:Float) elapsed = _;

function SpectreAlpha(event:NoteUpdateEvent) {
    var note:Note = event.note;

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

    var boundNoteOpacity:Float = Math.max(0, Math.min(1, noteOpacity));
    note.alpha = boundNoteOpacity;
}    

function onNoteCreation(_) if (_.noteType == 'spectre') {
    _.noteSprite = 'modNotes/Corruptro/$spr';
    _.note.alpha = 1;
}

function onPostNoteCreation(_) if (_.noteType == 'spectre')
    _.note.frameOffset.y += downscroll ? 40 : -20;

function onPlayerHit(_) if (_.noteType == 'spectre') {
    _.animCancelled = true;
    _.showSplash = false;
    spectreHit = true;
    playModSound('SpectreArrow');
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
    private var sc:Float = 0.7;
    private var _reOffX:Float = -71.5;
    private var _reOffY:Float = PlayState.downscroll ? -50 : -64;

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