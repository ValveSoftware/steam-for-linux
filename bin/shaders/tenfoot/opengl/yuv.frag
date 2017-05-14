#version 120
#extension GL_ARB_texture_rectangle : require
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect Texture0;
uniform sampler2DRect Texture1;
uniform sampler2DRect Texture2;

varying vec4 tex;

const vec3 mulRed = vec3( 1.0, 0.0, 1.5958 );
const vec3 mulGreen = vec3( 1.0, -0.39173, -0.8129 );
const vec3 mulBlue = vec3( 1.0, 2.017, 0.0 );

void main (void) 
{
	vec2 texHalf = tex.st * 0.5;
	vec3 yuv = vec3( 
		1.1643 * texture2DRect( Texture0, tex.st ).r + 0.42723,
		texture2DRect( Texture1, texHalf ).r,
		texture2DRect( Texture2, texHalf ).r, 1.0 ) - 0.5;
	gl_FragColor = vec4( dot( yuv, mulRed ), dot( yuv, mulGreen ), dot( yuv, mulBlue ), 1.0 );
}

