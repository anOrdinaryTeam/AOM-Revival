class ModPage extends FlxSprite
{
    public var url:String = 'https://tenor.com/view/family-guy-theres-nothing-thank-you-son-chris-griffin-peter-griffin-gif-16308152171798273645';
    public var ogX:Float = 0;

    public function new(type:String, _url:String, _ogX:Float) {
        super();
        this.url = _url;
        this.ogX = _ogX;

        var defScale:Float = switch(type) {
            default: 0.25;
            case 'GB' | 'GJ': 2;
        };
        var smooth:Bool = switch(type) {
            default: true;
            case 'GB' | 'GJ': false;
        };

        this.loadGraphic(Paths.image('Pages/$type'));
        this.antialiasing = smooth;
        this.scale.set(defScale, defScale);
        this.updateHitbox();
    }
}