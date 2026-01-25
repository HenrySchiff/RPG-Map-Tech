shader_type spatial;
render_mode unshaded;

uniform float edge_length = 10.0;
uniform float cell_length = 1.0;
uniform float line_thickness = 0.5;
uniform float edge_thickness = 0.5;

uniform float smooth_factor = 1.0;

uniform vec2 position_offset;

uniform vec4 line_color;
uniform vec4 face_color;
uniform vec4 edge_color;

bool close_to(float a, float b, float epsilon) {
	return abs(a - b) <= epsilon;
}

void fragment() {
	float avg_lines_per_edge = edge_length / cell_length;

	vec2 offset = vec2(1.0, 1.0) * (1.0 / (float(avg_lines_per_edge) * 2.0));
	offset += position_offset;

	vec3 color = face_color.rgb;
	float alpha = face_color.a;

	// grid
	vec2 grid = (UV - offset) * avg_lines_per_edge;
	vec2 line_dist = abs(fract(grid) - 0.5) * 2.0;
	float grid_mask =
	    step(line_dist.x, line_thickness) +
	    step(line_dist.y, line_thickness);
	grid_mask = clamp(grid_mask, 0.0, 1.0);

	color = mix(color, line_color.rgb, grid_mask);
	alpha = mix(alpha, line_color.a, grid_mask);

	// edges
	vec2 scaled_uv = UV * edge_length;
	vec2 edge_dist = min(scaled_uv, edge_length - scaled_uv);
	float edge_mask =
	    step(edge_dist.x, edge_thickness) +
	    step(edge_dist.y, edge_thickness);
	edge_mask = clamp(edge_mask, 0.0, 1.0);

	color = mix(color, edge_color.rgb, edge_mask);
	alpha = mix(alpha, edge_color.a, edge_mask);

	ALBEDO = color;
	ALPHA = alpha;
}