shader_type canvas_item;

void fragment() {
    COLOR = texture(TEXTURE, UV);
    //COLOR.b = abs(sin(TIME * 6.0));
    COLOR.s = abs(sin(TIME * 8.0));
}