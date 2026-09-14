/*
This shader is by: Andres Ortiz
***SCROLLING FILM REEL***
Based off of old school film projectors, this shader "loads" the next image by scrolling the image rapidly and applying a vignette to fade the colors and add film grain
*/

shader_type canvas_item;

uniform float radius;
uniform float speed : hint_range(0.0, 1.0, 0.1) = 1.0;

void fragment() {
	vec2 uvOffset = UV;
	uvOffset.y += TIME * speed;
	COLOR = texture(TEXTURE, mod(uvOffset, 1.0));
}
