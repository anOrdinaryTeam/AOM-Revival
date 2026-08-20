import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.text.FlxTextBorderStyle;

// Basically easing the stuff.
class AomText extends FlxBitmapText
{
    public var size(get, set):Float;

    public function new(X:Float = 0, Y:Float = 0, Text:String = '', Size:Float = 1, Font:String = 'VCR')
    {
        X ??= 0; Y ??= 0;
        Text ??= '';
        Font ??= 'VCR';
        Size ??= 1;

        super(X, Y, Text, _GetFont(Font));
        this.size = Size;
        this.antialiasing = true;
    }

    public function setFormat(Color:FlxColor = -1, Alignment:String = 'none', ?BorderStyle:String, ?BorderSize:Float, ?BorderColor:FlxColor):Void
    {
        this.color = Color ?? -1;
        this.alignment = Alignment ?? 'none';

        if (BorderStyle != null)
            _SetupBorder(BorderStyle, BorderSize, BorderColor);
    }

    // without update hitbox
    public function forceSize(val:Float):Void
        this.scale.set(val, val);

    public function set_size(val:Float):Float
    {
        this.scale.set(val, val);
        this.updateHitbox();
        return val;
    }

    public function get_size():Float
        return this.scale.x;

    private function _GetFont(Font:String):FlxTextBorderStyle
    {
        final image:String = Paths.getPath('fonts-bmd/$Font/data.png');
        final fnt:String = Paths.getPath('fonts-bmd/$Font/data.fnt');

        return FlxBitmapFont.fromAngelCode(image, fnt);
    }

    private function _SetupBorder(?BorderStyle:String, ?BorderSize:Float, ?BorderColor:FlxColor)
    {
        BorderStyle ??= 'none';
        BorderSize ??= 6;
        BorderColor ??= FlxColor.BLACK;

        this.borderStyle = switch(BorderStyle.toLowerCase()) {
            default: FlxTextBorderStyle.NONE;
            case 'outline': FlxTextBorderStyle.OUTLINE;
            case 'shadow': FlxTextBorderStyle.SHADOW;
            case 'fast': FlxTextBorderStyle.OUTLINE_FAST;
        };
        this.borderSize = BorderSize;
        this.borderColor = BorderColor;
    }
}