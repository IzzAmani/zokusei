shader_type canvas_item;

uniform vec4 flash_color : source_color;
uniform float flash_view : hint_range(0.0, 1.0, 0.1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	COLOR = mix(texture_color, flash_color, flash_view);
	COLOR.a = texture_color.a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
