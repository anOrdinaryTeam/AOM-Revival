function onNoteCreation(e) e.noteSprite = "modNotes/X/NOTE_assets";
function onStrumCreation(e) e.sprite = "modNotes/X/NOTE_assets";

function postCreate() {
    var randomScale = 0.4 + Math.random() * 1;
    var spr:String = PlayState.SONG.meta.name == 'inking Mistake' ? 'InkingMistake/particle' : 'particle'; 

    for (i in 0...30){
        var part:FlxSprite = new FlxSprite(-1200 + 150 * i, 1500, getModPath(spr));
        part.antialiasing = Options.antialiasing;
        part.scrollFactor.set(0.92, 0.92);
        add(part);
        
        var nose:Float = part.x;
        part.scale.set(randomScale, randomScale);
        FlxTween.tween(part, {y: part.y - 2000, alpha: 0}, (Math.random() * 5 + 3), {ease: FlxEase.quadInOut, type: 2, onUpdate: function(twn:FlxTween){
                part.x = nose + Math.sin(8 * twn.scale + randomScale) * 120;
            }
        });
    }
}