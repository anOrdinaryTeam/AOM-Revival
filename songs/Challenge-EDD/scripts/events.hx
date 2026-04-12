var matt:FunkinSprite;

function create() {
    matt(true, false);
}

function matt(index:Bool, can:Bool) {
    if (index)
    {
        matt = new FunkinSprite(25, 230).loadSprite(getModImage('Challenge-EDD/matt'));
        matt.antialiasing = true;
        matt.scale.set(1.7, 1.7);

        matt.addAnim('walk', 'walk', 12, true);
        matt.addAnim('idle', 'idle', 8, true);
        matt.playAnim('idle');

        insert(7, matt);
    }
    if (can)
    {
        if (diff == 'hard')
        {
            //
        }
        else
        {
            //
        }
    }

}