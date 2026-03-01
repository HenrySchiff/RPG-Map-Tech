shader_type canvas_item;

uniform vec4 reticle_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float size_meters : hint_range(0.0, 10.0) = 1.0;
uniform float thickness_meters : hint_range(0.0, 5.0) = 0.1;
uniform float gap_meters : hint_range(0.0, 5.0) = 0.3;
uniform float decal_size_meters : hint_range(0.1, 20.0) = 2.0;

void fragment() {
    // Convert UV from [0,1] to world space meters
    vec2 uv_centered = (UV - vec2(0.5)) * decal_size_meters;
    
    // Get absolute distances from center for x and y
    vec2 abs_pos = abs(uv_centered);
    
    // Half the size of the square
    float half_size = size_meters * 0.5;
    float half_gap = gap_meters * 0.5;
    
    // Determine which edge we're closest to
    float dist_to_vert_edge = half_size - abs_pos.x;
    float dist_to_horiz_edge = half_size - abs_pos.y;
    
    float mask = 0.0;
    
    // If we're closer to vertical edge, check vertical edge conditions
    if (dist_to_vert_edge < dist_to_horiz_edge) {
        // On vertical edge (left/right)
        if (abs_pos.x >= half_size - thickness_meters && abs_pos.x <= half_size) {
            // Not in vertical gap
            if (abs_pos.y >= half_gap) {
                mask = 1.0;
            }
        }
    } else {
        // On horizontal edge (top/bottom)
        if (abs_pos.y >= half_size - thickness_meters && abs_pos.y <= half_size) {
            // Not in horizontal gap
            if (abs_pos.x >= half_gap) {
                mask = 1.0;
            }
        }
    }
    
    // Apply color
    COLOR.rgb = reticle_color.rgb;
    COLOR.a = reticle_color.a * mask;
}