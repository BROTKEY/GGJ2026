shader_type spatial;

uniform float time = 0.0;

void vertex() {
	float t = sin(time) / 5.0;
	VERTEX.x += VERTEX.x * t;
	VERTEX.z += VERTEX.z * t;
}

void fragment() {
	ALBEDO = vec3(1.0);
	ALPHA = 1.0;
}
