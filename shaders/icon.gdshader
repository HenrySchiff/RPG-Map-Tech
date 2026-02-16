shader_type spatial;
render_mode unshaded;

uniform bool animated = false;
uniform bool dashed = true;

uniform float line_length;
uniform vec3 line_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float time = animated ? TIME : 1.0;
	
	float line = UV.y * line_length + -time * 0.5;
	
	if (dashed) {
		ALPHA = step(fract(line), 0.5);
	}
	
	ALBEDO = line_color;
}