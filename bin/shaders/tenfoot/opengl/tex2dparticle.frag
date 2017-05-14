#version 120

uniform sampler2D Texture0;
uniform sampler2D Texture1;

uniform float particleSharpness = 0.0;

varying vec4 tex; 
varying vec4 tex1; 
varying vec4 color; 


void main (void) 
{	
	vec2 uv = tex.st - 0.5;
	float radius = sqrt( dot( uv, uv ) );
	float flSharpRadius = clamp( particleSharpness, 0.0, 0.98 ) * 0.5; 
	gl_FragColor = color * vec4( color.aaa, 1.0 ) *
		mix( 1.0, clamp( 1.0 - ( radius - flSharpRadius ) / ( 0.5 - flSharpRadius ), 0.0, 1.0 ), step( flSharpRadius, radius ) );
}
