function stepHit(e) {
    if (curStep % 16 == 0) {
        if (stepRange(264, 312))
            camHUD.zoom = 1.1;

        if (stepRange(648, 760))
            camGame.zoom = .62;

        if (stepRange(776, 872))
            camHUD.zoom = 1.1;

        if (stepRange(328, 360))
            camGame.zoom = .62;
    }

    if (curStep % 6 == 0) {
        if (stepRange(646, 762))
            camGame.zoom = .62;

        if (stepRange(768, 876))
            camGame.zoom = .62;
    }

    switch(e) {
        case 640, 896, 1664, 2176:
            camGame.zoom = 0.65;
            camHUD.zoom = 1.1;
            setStrumsVisiblity();
    }
}

function setStrumsVisiblity() {
    var items:Array<Dynamic> = [iconP1, iconP2, healthBar, healthBarBG];

    if (getSaveData('allowCustomHud'))
        for (i in hudItems)
            items.push(i);
    else
        for (i in [missesTxt, accuracyTxt, scoreTxt])
            items.push(i);

    for (obj in items)
        obj.visible = !obj.visible;
}