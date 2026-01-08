shader_type spatial;
render_mode unshaded;

uniform int grid_size : hint_range(1, 1000) = 10;
uniform float line_thickness : hint_range(0.001, 0.1) = 0.01;
uniform vec4 line_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 face_color : source_color = vec4(1.0, 1.0, 1.0, 0.0);
uniform float edge : hint_range(-1.0, 4.0) = 0.5;
uniform vec2 pos_offset = vec2(0.0, 0.0);

const vec3 BLACK = vec3(0.0, 0.0, 0.0);

bool close_to(float a, float b, float epsilon) {
	return abs(a - b) <= epsilon;
}

void fragment() {
	// UV coordinates for this face (0..1)
	//vec2 uv = UV * vec2(scale_x, scale_y) - vec2(offset_x, offset_y);
	vec2 offset = vec2(1.0, 1.0) * (1.0 / (float(grid_size) * 2.0));
	offset += pos_offset;
	//vec2 scale = vec2(3.0, 2.0);
	vec2 uv = UV - offset;
	
	// Scale UV to the number of lines
	vec2 grid = uv * float(grid_size);
	
	// Compute distance to nearest line
	vec2 line_dist = abs(fract(grid) - 0.5);
	
	// Check if the pixel is within line_thickness
	float mask = step(line_dist.x, line_thickness) + step(line_dist.y, line_thickness);
	mask = clamp(mask, 0.0, 1.0);
	
	// Mix between face color and line color
	vec4 final = mix(face_color, line_color, mask);
	ALBEDO = final.xyz;
	//ALPHA = final.a;
	if (final == face_color) {
		ALPHA = 0.0;
	}
	
	uv += offset;
	
	//if (close_to(uv.x, edge, 0.01) || close_to(uv.y, edge, 0.01)) {
		//ALBEDO = vec3(1.0, 0.0, 0.0);
	//}
	
	if (close_to(uv.x, 0.0, 0.01) || close_to(uv.y, 0.0, 0.01)) {
		ALBEDO = BLACK;
	}
	
	if (close_to(uv.x, 1.0, 0.01) || close_to(uv.y, 1.0, 0.01)) {
		ALBEDO = BLACK;
	}
}
