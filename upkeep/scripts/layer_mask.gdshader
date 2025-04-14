shader_type canvas_item;

uniform sampler2D mask_texture;
uniform vec2 viewport_size;

void fragment() {
	vec2 screen_uv = SCREEN_UV;
	float mask_value = texture(mask_texture, screen_uv).r;
	vec4 final_color = COLOR;
	final_color.a *= mask_value;
	COLOR = final_color;
}
