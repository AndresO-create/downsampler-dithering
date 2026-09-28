/*
This shader is by: Andres Ortiz
***SCROLLING FILM REEL***
Based off of old school film projectors, this shader "loads" the next image by scrolling the image rapidly and applying a vignette to fade the colors and add film grain
*/

shader_type canvas_item;

uniform float screenWidth = 1152;
uniform float screenHeight = 1048;

uniform float radius;
uniform float velocity : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float max_speed : hint_range(0.0, 2.0, 0.1) = 1.5;
uniform vec4 color : source_color;

uniform sampler2D noise;

void fragment() {
	//determine x and y values of screenspace shader
	float widthParam = UV.x * screenWidth;
	float heightParam = UV.y * screenHeight;
	vec2 params = vec2(widthParam, heightParam);
	
	//scroll texture
	vec2 uvOffset = UV;
	uvOffset.y += velocity * TIME;
	clamp(velocity, 0.0, max_speed);
	COLOR = texture(TEXTURE, mod(uvOffset, 1.0));
	
	//add color to image
	COLOR *= color;
	
	//add vigniette
	float alpha = float(distance(params, vec2(576, 524)) > radius);
	COLOR.a = alpha;
}