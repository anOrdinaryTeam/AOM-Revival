var blockAnim:Bool = false;

function beatHit() switch(curBeat) {
    case 648:
        popup.alpha = 1;
        popup.playAnim('show', true);
    case 776:
        blockAnim = true;
        dad.playAnim('lastNOTE', true);
        dad.animation.finishCallback = () -> dad.visible = false;
    case 788:
        new FlxTimer().start(0.05, function(tmr:FlxTimer) {
			if (!paused)
				iconP2.alpha -= 0.15;

			if (iconP2.alpha > 0)
				tmr.reset(0.05);
			else
				iconP2.visible = false;
		});
    case 790:
		FlxG.camera.fade(FlxColor.BLACK, 0.7, false);
}

function onDadHit(e) if (blockAnim)
    e.cancelAnim();