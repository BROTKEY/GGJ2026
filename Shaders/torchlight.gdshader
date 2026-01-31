shader_type canvas_item;

/** The gray-scale texture to use as a mask */
uniform sampler2D tex_mask;
/** Radius (= scale) of the mask texture */ 
uniform float radius = 100.0;
/** The current mouse position */
uniform vec2 mouse_position;

varying vec2 frag_pos;
varying vec2 world_pos;

void vertex() {
	frag_pos = VERTEX;
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy;
}

void fragment() {
	vec2 mouse_offset = world_pos - mouse_position;
	// Position in the mask in the range [-1, 1]
	vec2 pos_in_mask = mouse_offset / radius;
	if (abs(pos_in_mask.x) <= 1.0 && abs(pos_in_mask.y) <= 1.0) {
		// Position in the mask's texture in [0, 1]
		vec2 mask_uv = (pos_in_mask + 1.0) / 2.0;
		// Use gray-scale value of the texture
		COLOR.w = COLOR.w * length(texture(tex_mask, mask_uv).xyz);
		//COLOR.w = texture(tex_mask, mask_uv).x;
	} else {
		// Set transparent if not inside mask
		COLOR.w = 0.0;
	}
	
	//if (length(frag_pos) < 10.0) {
		//COLOR = vec4(1.0);
	//}
	//if (length(world_pos) < 10.0) {
		//COLOR = vec4(1.0, 0.0, 0.0, 1.0);
	//}
}
