shader_type canvas_item;

uniform vec4 circle_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float radius_meters : hint_range(0.0, 10.0) = 1.0;
uniform float thickness_meters : hint_range(0.0, 5.0) = 0.1;
uniform float decal_size_meters : hint_range(0.1, 20.0) = 2.0;

void fragment() {
	// Convert UV from [0,1] to world space meters
	// UV (0.5, 0.5) is the center of the decal
	vec2 uv_centered = (UV - vec2(0.5)) * decal_size_meters;
	
	// Calculate distance from center in meters
	float dist = length(uv_centered);
	
	// Create circle ring using meter-based measurements
	float inner_radius = radius_meters - thickness_meters * 0.5;
	float outer_radius = radius_meters + thickness_meters * 0.5;
	
	float s = 0.005;
	
	// Smooth the edges for anti-aliasing (0.01 meters smoothing)
	float circle_mask = smoothstep(inner_radius - s, inner_radius, dist) * 
		(1.0 - smoothstep(outer_radius, outer_radius + s, dist));
	
	// Apply color with alpha
	COLOR = vec4(circle_color.rgb, circle_color.a * circle_mask);
}