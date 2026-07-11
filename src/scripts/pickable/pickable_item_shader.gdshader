shader_type canvas_item;

uniform bool use_outline = false;
uniform bool use_water_inline = true;

uniform vec4 outline_color:source_color=vec4(0.0,0.0,0.0,1.0);
uniform float outline_width : hint_range(1.0, 5.0, 1.0) = 1.0;

uniform vec4 inline_color:source_color=vec4(0.0,0.0,0.0,1.0);
uniform float inline_width : hint_range(1.0, 5.0, 1.0) = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

    // Get the texture data from the SubViewport
    vec4 color = COLOR;
	vec4 final_color = color; 
    // Use the texture size to determine the size of a single pixel (texel)
    vec2 texel_size = 1.0 / vec2(textureSize(TEXTURE, 0));

    // Check neighbors for outline
    float alpha = color.a;

    for (int i = 0; i < 4; i++) {
		if (use_outline)
		{
			vec2 offset;
			float outline_pixel_size_x = outline_width * texel_size.x;
			float outline_pixel_size_y = outline_width * texel_size.y;
	        // Check surrounding pixels: left, right, up, down
	        if (i == 0) offset = vec2(-outline_pixel_size_x, -0.0);
	        if (i == 1) offset = vec2(outline_pixel_size_x, 0.0);
	        if (i == 2) offset = vec2(0.0, -outline_pixel_size_y);
	        if (i == 3) offset = vec2(0.0, outline_pixel_size_y);

	        // Sample the neighbor pixel's alpha
	        float neighbor_alpha = texture(TEXTURE, UV + offset).a;
			if (alpha < 0.01 && neighbor_alpha > 0.01) {
	            final_color = outline_color;
	            break; // Found an edge, so draw the outline and stop checking
	        }
		}
		
		if (use_water_inline)
		{
			vec2 offset;
			float inline_pixel_size_x = inline_width * texel_size.x;
			float inline_pixel_size_y = inline_width * texel_size.y;
	        // Check surrounding pixels: left, right, up, down
	        //if (i == 0) offset = vec2(-inline_pixel_size_x, -0.0);
	        //if (i == 1) offset = vec2(inline_pixel_size_x, 0.0);
	        //if (i == 2) offset = vec2(0.0, -inline_pixel_size_y);
	        if (i == 3) offset = vec2(0.0, inline_pixel_size_y);

	        // Sample the neighbor pixel's alpha
	        float neighbor_alpha = texture(TEXTURE, UV + offset).a;
			if (alpha > 0.01 && neighbor_alpha < 0.01) {
				
	            final_color += inline_color*0.7;
	            break; // Found an edge, so draw the outline and stop checking
	        }
		}
        

        //// If the neighbor is opaque (or mostly opaque), and the current pixel is transparent, draw outline
        //else if (use_darken)
		//{
			//final_color *= darken_color;
		//}
		//if (hit_effect > 0.0) {
			//float flash = sin(TIME * flash_speed) * 0.5 + 0.5;
        	//flash *= original_color.a;
			//flash *= flash_color.a;
			//final_color = mix(original_color, flash_color, flash);
	        ////final_color = mix(original_color, final_color, hit_effect);
	        //final_color.a = original_color.a;
		//} 
    }

    // Output the final color
    COLOR = final_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
