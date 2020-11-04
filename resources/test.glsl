uniform vec2 resolution;

vec3 rgb(float r, float g, float b) {
	return vec3(r / 255.0, g / 255.0, b / 255.0);
}
vec4 rectangle(vec2 uv, vec2 pos, float width, float height, vec3 color) {
	float t = 0.0;
	if ((uv.x > pos.x - width / 2.0) && (uv.x < pos.x + width / 2.0)
		&& (uv.y > pos.y - height / 2.0) && (uv.y < pos.y + height / 2.0)) {
		t = 1.0;
	}
	return vec4(color, t);
}


void main()
{
	vec2 uv = gl_FragCoord.xy;
	vec2 center = resolution.xy * 0.5;
    vec2 off = vec2(20, 20);
	float width = 0.25 * resolution.x;
	float height = 0.25 * resolution.x;
    float t = 0.0;

    // Background layer
	vec4 layer1 = vec4(rgb(144.0, 144.0, 144.0), 0.0);
	
	// Rectangle
	vec4 layer2 = rectangle(uv, center, width, height, rgb(255.0, 255.0, 0.0));

    vec4 layer3 = rectangle(uv, off, width, height, rgb(255.0, 0.0, 0.0));

    vec4 test = mix(layer1, layer2, t);
	
	// Blend the two

	gl_FragColor = mix(test, layer3, t);
}
