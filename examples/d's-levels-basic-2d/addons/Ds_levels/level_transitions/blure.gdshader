shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_nearest_mipmap;

uniform float blure_amount = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(screen_tex, SCREEN_UV, blure_amount);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
