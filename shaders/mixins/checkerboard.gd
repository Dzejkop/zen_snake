vec3 uv = (CAMERA_MATRIX * vec4(VERTEX, 1.0)).xyz;
uv *= n;
vec3 abs_diff = abs(uv - round(uv));
abs_diff -= 0.1;
abs_diff /= 0.1;
abs_diff = clamp(abs_diff, 0, 1);

if (abs_diff.z == 0.0) {
	_out = abs_diff.x * abs_diff.y;
} else if (abs_diff.y == 0.0) {
	_out = abs_diff.x * abs_diff.z;
} else {
	_out = abs_diff.y * abs_diff.z;
}