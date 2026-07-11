#pragma header

vec2 fragCoord=openfl_TextureCoordv*openfl_TextureSize;

uniform float iTime;

uniform float speed;
uniform float intensity;
uniform float bloom;

const float blurSize=1./512.;

void main()
{
	vec4 sum = vec4(0);
	vec2 texcoord=fragCoord.xy/openfl_TextureSize.xy;
	
	// blur in y (vertical)
	// take nine samples, with the distance blurSize between them
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x-4.*blurSize,texcoord.y))*.05;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x-3.*blurSize,texcoord.y))*.09;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x-2.*blurSize,texcoord.y))*.12;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x-blurSize,texcoord.y))*.15;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y))*.16;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x+blurSize,texcoord.y))*.15;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x+2.*blurSize,texcoord.y))*.12;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x+3.*blurSize,texcoord.y))*.09;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x+4.*blurSize,texcoord.y))*.05;
	
	// blur in y (vertical)
	// take nine samples, with the distance blurSize between them
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y-4.*blurSize))*.05;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y-3.*blurSize))*.09;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y-2.*blurSize))*.12;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y-blurSize))*.15;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y))*.16;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y+blurSize))*.15;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y+2.*blurSize))*.12;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y+3.*blurSize))*.09;
	sum+=flixel_texture2D(bitmap,vec2(texcoord.x,texcoord.y+4.*blurSize))*.05;
	
	vec2 uv=fragCoord.xy/openfl_TextureSize.xy;
	uv.y+=(sin((uv.x+(iTime*.5))*10.)*speed)+
	(sin((uv.x+(iTime*.2))*intensity)*.01);
	
	vec4 texColor=texture2D(bitmap,uv);

	gl_FragColor= sum * bloom + texColor;
}