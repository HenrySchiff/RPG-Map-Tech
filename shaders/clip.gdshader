shader_type spatial;
render_mode world_vertex_coords;

uniform bool enable_clipping = true;
uniform float visible_distance = 0.55;
uniform vec3 position = vec3(0.0);

varying vec3 extent;

void vertex() {
	extent = VERTEX - position;
}

void fragment() {
	if (
		enable_clipping && (
			abs(extent.x) > visible_distance || 
			abs(extent.y) > visible_distance || 
			abs(extent.z) > visible_distance 
		)
	) {
		discard;
	}
	
	ALBEDO = vec3(0.25, 0.25, 0.25);
}