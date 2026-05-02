function onNoteCreation(e) if (getSaveData('usingSkins') && e.strumLineID == 1)
    e.noteSprite = getSaveData('curSkinNote');

function onStrumCreation(e) if (getSaveData('usingSkins') && e.player == 1)
    e.sprite = getSaveData('curSkinNote');