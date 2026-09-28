/*
This shader is by: Andres Ortiz
***HALFTONE***
Based off of comic book coloring, this shader will apply a halftone pattern to the image
Based off of this tutorial from maximheckel: https://blog.maximeheckel.com/posts/shades-of-halftone/
Modified to include color palette selection from my July shader upload: 
*/

shader_type canvas_item;

//relative radius of circle in each cell
uniform float radius : hint_range(0.01, 0.5, 0.01) = 0.25;

//size of grid across image (use powers of two, do not exceed 1/4 of image res)
uniform float grid_size : hint_range(1.0, 64.0 , 1.0) = 1.0;

//size of each pixel in the image
uniform float pixel_size : hint_range(2.0, 128.0, 2.0) = 2.0;

//holds the resolution of the image
uniform vec2 image_res;

//flag to set radius of circle based off of the luminance of the grid-cell
uniform bool lum_radius = false;

/*PALETTE SWAPPER*/
//flag to determine whether to combine halftone effect with palette swap effect
uniform bool palette_swap = false;

//thresholds used to determine which color to select from index
const float threshold_a  = 0.25;
const float threshold_b = 0.50;
const float threshold_c = 0.75;

//palettes
const vec3[4] black_white = {vec3(0.0), vec3(0.33), vec3(0.67), vec3(1.0)};
const vec3[4] green = {vec3(0, 0.09, 0),vec3(0, 0.6, 0), vec3(0, 0.83, 0), vec3(0, 1.0, 0)};
const vec3[4] purple_haze = {vec3(0.05, 0.04, 0.05), vec3(0.2, 0.17, 0.24), vec3(0.35, 0.30, 0.42), vec3(0.5, 0.44, 0.60)};
const vec3[4] purple_pride = {vec3(0.06, 0.04, 0.07), vec3(0.26, 0.18, 0.28), vec3(0.45, 0.32, 0.5), vec3(0.65, 0.46, 0.71)};
const vec3[4] marvelous_pink = {vec3(0.08, 0.07, 0.07), vec3(0.33, 0.27, 0.3), vec3(0.59, 0.48, 0.52), vec3(0.84, 0.69, 0.75)};
const vec3[4] silly_putty = {vec3(0.09, 0.06, 0.07), vec3(0.37, 0.27, 0.29), vec3(0.65, 0.48, 0.52), vec3(0.93, 0.91, 0.98)};
const vec3[4] real_rasberry = {vec3(0.08, 0.04, 0.06), vec3(0.34, 0.18, 0.26), vec3(0.61, 0.32, 0.45), vec3(0.87, 0.46, 0.65)};
const vec3[4] dizzy_days = {vec3(0.08, 0.03, 0.01), vec3(0.32, 0.12, 0.07), vec3(0.56, 0.21, 0.12), vec3(0.81, 0.30, 0.18)};
const vec3[4] troll_slayer_orange = {vec3(0.09, 0.06, 0.03), vec3(0.38, 0.25, 0.12), vec3(0.67, 0.43, 0.21), vec3(0.96, 0.62, 0.3)};
const vec3[4] goldfinch_yellow = {vec3(0.09, 0.08, 0.04), vec3(0.38, 0.34, 0.17), vec3(0.67, 0.61, 0.3), vec3(0.96, 0.87, 0.43)};
const vec3[4] lepton_gold = {vec3(0.08, 0.06, 0.0), vec3(0.32, 0.25, 0.0), vec3(0.56, 0.43, 0.0), vec3(0.81, 0.62, 0.0)};
const vec3[4] slick_mud = {vec3(0.06, 0.04, 0.02), vec3(0.26, 0.17, 0.1), vec3(0.45, 0.3, 0.19), vec3(0.65, 0.43, 0.27)};

//selected palette
uniform int selected_palette : hint_range(0,11) = 0;

//return palette depending on value of selected_palette
vec3[4] get_palette(){
		switch (selected_palette){
		case 0:
			return black_white;
		case 1:
			return green;
		case 2:
			return purple_haze;
		case 3:
			return purple_pride;
		case 4:
			return marvelous_pink;
		case 5:
			return silly_putty;
		case 6:
			return real_rasberry;
		case 7:
			return dizzy_days;
		case 8:
			return troll_slayer_orange;
		case 9:
			return goldfinch_yellow;
		case 10:
			return lepton_gold;
		case 11:
			return slick_mud;
	}
}

//set the color of the image by comparing the luminance to the thresholds
vec3 set_color(float luminance) {
	vec3 palette[4] = get_palette();
	if (luminance <= threshold_a){
		return palette[0];
	} else if (luminance <= threshold_b) {
		return palette[1];
	} else if (luminance <= threshold_c) {
		return palette[2];
	} else {
		return palette[3];
	}
}

void fragment() {
	vec2 normalPixel = pixel_size/image_res;
	vec2 pixelUV = normalPixel * floor(UV/normalPixel);
	
	vec2 cell_uv = fract(pixelUV * grid_size); //divide UV coordinates into desired number of grids and take decimal point
	
	float dist = length(cell_uv - 0.5);
	float relative_radius = radius * max(UV.x, radius); //find the relative radius of the image by first finding the maximum between the current UV position and the radius, then multiplying that value by the radius
	
	vec4 color = texture(TEXTURE, pixelUV);
	float luma = dot(vec3(0.2126, 0.7152, 0.0722), color.rgb);
	float radius_lum = radius * (0.1 + luma);
	
	//if palette_swap is enabled, swap palette now
	color.rgb = palette_swap ? set_color(luma) : color.rgb;

	
	float circle; //return either 1 or 0 if distance is greater than radius
	if (lum_radius)
		circle = smoothstep(radius_lum - 0.01, radius_lum + 0.01, dist);
	else
		circle = smoothstep(radius - 0.01, radius + 0.01, dist);

	
	color = mix(color, vec4(0.0), circle); //apply a mask to all values outside of the set radius
	
	COLOR = color;
}