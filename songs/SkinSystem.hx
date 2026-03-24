// function postCreate() {
//     if (dad.curCharacter == 'empty')
// }

public function setSkin(idx:Int, prefix:String) {
    precacheCharacter(idx, prefix + '_' + curSkin);
    changeCharacter(idx, prefix + '_' + curSkin);
}