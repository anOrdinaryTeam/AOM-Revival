#pragma header

uniform vec3 red;
uniform vec3 green;
uniform vec3 blue;
uniform bool enabled;

void main() {
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    gl_FragColor = enabled ? vec4(color.r * red + color.g * green + color.b * blue, color.a) : color;
}