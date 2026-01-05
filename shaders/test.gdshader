shader_type spatial;

uniform float height_scale = 0.25;
uniform sampler2D noise;
uniform float texel_size = 0.01;

varying vec2 tex_position;
varying flat vec3 face_normal_view;
varying float vert_y;

float get_height(vec2 uv) {
	//return texture(noise, uv).x * height_scale;
	return sin(uv.x * 2.0) * cos(uv.y * 2.0);
}

void vertex() {
	tex_position = VERTEX.xz / 2.0 + 0.5;
	
	float h  = get_height(tex_position);
	float hx = get_height(tex_position + vec2(texel_size, 0.0));
	float hz = get_height(tex_position + vec2(0.0, texel_size));
	
	// Object-space tangents
	vec3 dx = vec3(texel_size * 2.0, hx - h, 0.0);
	vec3 dz = vec3(0.0, hz - h, texel_size * 2.0);
	
	// Object-space face normal
	vec3 face_normal_object = normalize(cross(dz, dx));
	
	// Transform to VIEW SPACE (vertex-only!)
	face_normal_view =
	    normalize((MODELVIEW_MATRIX * vec4(face_normal_object, 0.0)).xyz);
	
	// Apply displacement
	VERTEX.y += h;
	vert_y = VERTEX.y;
}

void fragment() {
	ALBEDO = vec3(0.1, 0.5, 0.1);
	NORMAL = face_normal_view;
	METALLIC = 0.0;
	ROUGHNESS = 1.0;
	
	//if (vert_y > 0.75) {
		//discard;
	//}
}
