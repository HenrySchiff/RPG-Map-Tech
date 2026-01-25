shader_type spatial;
render_mode unshaded;

uniform float line_length;
uniform vec3 line_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float line = UV.y * line_length + TIME * 0.5;
	ALPHA = step(fract(line), 0.5);
	ALBEDO = line_color;
}