shader_type canvas_item;
render_mode unshaded;

uniform vec4 outline_color : source_color = vec4(1.0);
uniform vec4 mid_color : source_color = vec4(1.0);
uniform vec4 far_color : source_color = vec4(1.0);
uniform vec4 furthest_color : source_color = vec4(1.0);
uniform vec4 blink_color : source_color = vec4(1.0);
uniform float blink_time_scale : hint_range(0.0, 10.0, 0.1) = 0.0;
uniform float scale_factor = 1.0; 
uniform float ripple_speed = 3.0;
uniform float total_duration = 10.0;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

bool check_radius(sampler2D tex, vec2 uv, vec2 offset) {
	return textureLod(tex, uv + vec2(offset.x, 0.0), 0.0).a > 0.0 ||
		   textureLod(tex, uv + vec2(-offset.x, 0.0), 0.0).a > 0.0 ||
		   textureLod(tex, uv + vec2(0.0, offset.y), 0.0).a > 0.0 ||
		   textureLod(tex, uv + vec2(0.0, -offset.y), 0.0).a > 0.0;
}

void fragment() {
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);
	
	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}
	
	vec4 base_color = COLOR * c;
	
	float ripple_distance = floor(mod(TIME * ripple_speed, total_duration)) + 1.0;
	if (ripple_distance > 5.0) {
		ripple_distance = 0.0;
	} 
	vec2 pixel_size = (1.0 / vec2(textureSize(screen_texture, 0))) * scale_factor;
	
	bool is_outline = false;
	
	bool at_1 = false;
	bool at_2 = false;
	bool at_3 = false;
	bool at_4 = false;

	if (base_color.a == 0.0) {
		at_1 = check_radius(screen_texture, SCREEN_UV, pixel_size);
		
		if (ripple_distance == 1.0) {
			is_outline = at_1;
		} else {
			if (ripple_distance == 2.0) {
				at_2 = check_radius(screen_texture, SCREEN_UV, pixel_size * 2.0);
				is_outline = at_2;
			} else if (ripple_distance == 3.0) {
				at_2 = check_radius(screen_texture, SCREEN_UV, pixel_size * 2.0);
				at_3 = check_radius(screen_texture, SCREEN_UV, pixel_size * 3.0);
				is_outline = at_3 && !at_2;
			} else if (ripple_distance == 4.0) {
				at_3 = check_radius(screen_texture, SCREEN_UV, pixel_size * 3.0);
				at_4 = check_radius(screen_texture, SCREEN_UV, pixel_size * 4.0);
				is_outline = at_4 && !at_3;
			}
		}
	}
	
	if (is_outline) {
		vec4 current_outline = outline_color;
		if (at_2) {
			current_outline = mid_color;
		} else if (at_3) {
			current_outline = far_color;
		} else if (at_4) {
			current_outline = furthest_color;
		}
		current_outline = mix(current_outline, current_outline * blink_color, 0.5 - 0.5 * cos(TIME * blink_time_scale));
		COLOR = current_outline;
	} else {
		COLOR = base_color;
	}
}