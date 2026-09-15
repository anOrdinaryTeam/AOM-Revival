var boomspeed:Float = 4;
var bam:Float = 0.001;
camZooming = true;

function stepHit(e) switch(e) {
    case 144, 528, 1216: setBoom(1, 2);
    case 520, 1088, 1521, 2000, 2288: bam = 0.001;
    case 1050: boomspeed = 2;
    case 1776: setBoom(1, 1.50);
    case 2032: setBoom(1, 2.50);
}

function setBoom(spd:Float, boom:Float) {
    boomspeed = spd;
    bam = boom;
}

function beatHit() if (curBeat % boomspeed == 0) {
    FlxG.camera.zoom += 0.015 * bam;
    camHUD.zoom += 0.03 * bam;

    if (camGame.zoom >= 1.35) {
        camGame.zoom += 0.025 * bam;
        camHUD.zoom += 0.03 * bam;
    }
}