import AnOrdinaryDialogue;

var dialogue:AnOrdinaryDialogue;

var startCutscene:Bool = false;
var agotiMicless:FlxSprite;
var agotiCutscene:FlxSprite;

function destroy() dialogue.musicBG.destroy();
function create() {
    game.persistentUpdate = true;
    game.dad.alpha = 0;

    agotiMicless = new FlxSprite(game.dad.x, game.dad.y);
    agotiMicless.frames = Paths.getSparrowAtlas('Agoti_Dir/Agoti_Micless');
    agotiMicless.animation.addByPrefix('idle', 'Agoti_Idle_Micless', 24, true);
    agotiMicless.animation.play('idle');
    agotiMicless.antialiasing = Options.antialiasing;
    game.insert(game.members.indexOf(game.dad) + 1, agotiMicless);

    agotiCutscene = new FlxSprite(game.dad.x - 700, game.dad.y - 500);
    agotiCutscene.frames = Paths.getSparrowAtlas('Agoti_Dir/Agoti_Cutscene_A');
    agotiCutscene.animation.addByPrefix('intro', 'Agoti_Cut_A', 24, false);
    agotiCutscene.setGraphicSize(Std.int(agotiCutscene.width * 1.35));
    agotiCutscene.updateHitbox();
	agotiCutscene.scrollFactor.set();
    agotiCutscene.antialiasing = Options.antialiasing;
    agotiCutscene.alpha = 0.001;
    game.insert(game.members.indexOf(agotiMicless) + 1, agotiCutscene);

    var dialogueCam:FlxCamera = new FlxCamera();
    dialogueCam.bgColor = 0x000000;
    FlxG.cameras.add(dialogueCam, false);

    dialogue = new AnOrdinaryDialogue(PlayState.instance.SONG.meta.name);
    dialogue.camera = dialogueCam;
    add(dialogue);
}

function update() {
    dialogue.dropText.text = dialogue.dialogueText.text;
    if (controls.ACCEPT && !dialogue.endingDialogue && dialogue.endedAnimation) dialogue.nextDialogue();
    if (dialogue.endedDialogue && !startCutscene) agotiThing();
}

function agotiThing() {
    startCutscene = true;

    new FlxTimer().start(0.4, function() {
        game.remove(agotiMicless);
        agotiCutscene.alpha = 1;
        FlxG.sound.play(Paths.sound('agoti/introcut'));

        new FlxTimer().start(0.01, function() {
            agotiCutscene.animation.play('intro');
            
            new FlxTimer().start(3.75, function() {
                enabledCutscenes = false;
				game.dad.alpha = 1;
				game.remove(agotiCutscene);
				close();
			});
        });
    });
}