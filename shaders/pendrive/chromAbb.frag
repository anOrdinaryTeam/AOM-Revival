#pragma header

uniform float amount;//the point of this amount shit is so u dont have to put like a super tiny decimal to get it to look right
float offset=.01*amount;

void main()
{
	vec4 col=flixel_texture2D(bitmap,openfl_TextureCoordv);
	col.r=flixel_texture2D(bitmap,openfl_TextureCoordv.st-vec2(-offset,0.)).r;
	col.b=flixel_texture2D(bitmap,openfl_TextureCoordv.st-vec2(offset,0.)).b;
	
	gl_FragColor=col;
}