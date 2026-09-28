/*
This shader is by: Andres Ortiz
***HALFTONE***
Based off of comic book coloring, this shader will apply a halftone pattern to the image
*/

shader_type canvas_item;

//relative radius of circle in each cell
uniform float radius : hint_range(0.01, 0.5, 0.01) = 0.25;

//size of grid across image (use powers of two, do not exceed 1/4 of image res)
uniform float grid_size : hint_range(1.0, 64.0 , 1.0) = 1.0;

//size of each pixel in the image
uniform float pixel_size : hint_range(2.0, 128.0, 2.0) = 2.0;

uniform vec2 image_res;

void fragment() {
	vec2 normalPixel = pixel_size/image_res;
	vec2 pixelUV = normalPixel * floor(UV/normalPixel);
	
	vec2 cell_uv = fract(pixelUV * grid_size); //divide UV coordinates into desired number of grids and take decimal point
	
	float dist = length(cell_uv - 0.5);
	float relative_radius = radius * max(UV.x, radius); //find the relative radius of the image by first finding the maximum between the current UV position and the radius, then multiplying that value by the radius
	
	float circle = smoothstep(radius - 0.01, radius + 0.01, dist); //return either 1 or 0 if distance is greater than radius
	
	vec4 color = texture(TEXTURE, pixelUV);
	color = mix(color, vec4(0.0), circle); //apply a mask to all values outside of the set radius
	
	COLOR = color;
}