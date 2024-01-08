shader_type canvas_item;

void fragment() {
    COLOR = texture(TEXTURE, UV);
    COLOR.a = abs(sin(TIME * 5.0));
	//COLOR.rgb = COLOR.gbr;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
