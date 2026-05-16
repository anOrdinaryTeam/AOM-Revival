#if !ARKOSE_PORT
function onSelectOption(e) if (e.name == 'Exit to menu') {
    windowShit(ORIGINAL_RES[0], ORIGINAL_RES[1]);
    window.resizable = true;
}
#end