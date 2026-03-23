import haxe.ds.StringMap;

public var charMap:Array<Array<StringMap<Character>>> = [];
function charMapNullCheck(strumIndex:Int, charIndex:Int) {
	if (charMap[strumIndex] == null) charMap[strumIndex] = [];
	if (charMap[strumIndex][charIndex] == null) charMap[strumIndex][charIndex] = new StringMap();
}

function postCreate() {
	for (strumLine in strumLines) {
		var strumIndex:Int = strumLines.members.indexOf(strumLine);
		for (char in strumLine.characters) {
			var charIndex:Int = strumLine.characters.indexOf(char);
			charMapNullCheck(strumIndex, charIndex);
			charMap[strumIndex][charIndex].set(char.curCharacter, char);
		}
	}
}

public function precacheCharacter(strumIndex:Int, charName:String = 'bf', memberIndex:Int = 0) {
	charMapNullCheck(strumIndex, memberIndex);
	if (!charMap[strumIndex][memberIndex].exists(charName)) {
		var strumLine:StrumLine = strumLines.members[strumIndex];
		var existingChar:Character = strumLine.characters[memberIndex];

		var newChar:Character = new Character(existingChar.x, existingChar.y, charName, existingChar.isPlayer);
		charMap[strumIndex][memberIndex].set(newChar.curCharacter, newChar);
		newChar.active = false;

		try {
			if (newChar.animateAtlas != null) newChar.animateAtlas.drawComplex(FlxG.camera);
			else newChar.drawComplex(FlxG.camera);
		} catch(e:Dynamic) {
			trace('drawComplex didn\'t work this time for some reason');
		}

		switch (strumIndex) {
			case 0:
				newChar.cameraOffset.x += stage?.characterPoses['dad']?.camxoffset;
				newChar.cameraOffset.y += stage?.characterPoses['dad']?.camyoffset;
			case 1:
				newChar.cameraOffset.x += stage?.characterPoses['boyfriend']?.camxoffset;
				newChar.cameraOffset.y += stage?.characterPoses['boyfriend']?.camyoffset;
			case 2:
				newChar.cameraOffset.x += stage?.characterPoses['girlfriend']?.camxoffset;
				newChar.cameraOffset.y += stage?.characterPoses['girlfriend']?.camyoffset;
		}
		newChar.setPosition(existingChar.x, existingChar.y);
		scripts.call('onCharacterCached', [newChar, strumIndex, memberIndex]);
	}
}

public function changeCharacter(strumIndex:Int, charName:String = 'bf', memberIndex:Int = 0, ?updateBar:Bool = true) {
	if (!charMap[strumIndex][memberIndex].exists(charName))
		precacheCharacter(strumIndex, charName, memberIndex);

	var oldChar:Character = strumLines.members[strumIndex].characters[memberIndex];
	var newChar:Character = charMap[strumIndex][memberIndex].get(charName);

	if (oldChar == null || newChar == null) return;
	if (oldChar.curCharacter == newChar.curCharacter) return trace('It\'s the same character bro.');

	if (memberIndex == 0 && updateBar) {
		if (strumIndex == 0) {
			iconP2.setIcon(newChar.getIcon());
			if (Options.colorHealthBar) healthBar.createColoredEmptyBar(newChar.iconColor ?? (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000));
			healthBar.updateBar();
		} else if (strumIndex == 1) {
			iconP1.setIcon(newChar.getIcon());
			if (Options.colorHealthBar) healthBar.createColoredFilledBar(newChar.iconColor ?? (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33));
			healthBar.updateBar();
		}
	}

	var group = FlxTypedGroup.resolveGroup(oldChar) ?? this;
	group.insert(group.members.indexOf(oldChar), newChar);
	newChar.active = true;
	oldChar.active = false;
	group.remove(oldChar);

	newChar.setPosition(oldChar.x, oldChar.y);
	newChar.playAnim(oldChar.animation?.name, true, oldChar.lastAnimContext);
	newChar.animation?.curAnim?.curFrame = oldChar.animation?.curAnim?.curFrame;
	strumLines.members[strumIndex].characters[memberIndex] = newChar;
	newChar.visible = oldChar.visible;
	newChar.alpha = oldChar.alpha;

	if (strumIndex != 2)theShitDoesntChange(strumIndex == 1, newChar);
	scripts.call('onChangeCharacter', [oldChar, newChar, strumIndex, memberIndex]);
}

function theShitDoesntChange(player:Bool, getIcon:Dynamic) {
	var idk_Whats_Better_A_ifCondition_or_This:HealthIcon = player ? iconP1 : iconP2;
	idk_Whats_Better_A_ifCondition_or_This.setIcon(getIcon.getIcon());
	if (player) healthBar.createColoredFilledBar(getIcon.iconColor);
	else healthBar.createColoredEmptyBar(getIcon.iconColor);
	healthBar.updateBar();
}