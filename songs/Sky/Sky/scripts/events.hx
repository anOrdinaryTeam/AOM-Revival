function beatHit() switch(curBeat) {
    case 30,31,62,63: dad.playAnim('huh 1');
    case 126,127,190,191:
        dad.playAnim('huh 2');
        dad.idleSuffix = '-alt';
    case 254,255,270,271: dad.playAnim('huh 3');
    case 286,287: dad.playAnim('menoje');
}