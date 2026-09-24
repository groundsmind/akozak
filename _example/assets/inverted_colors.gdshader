shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    	vec3 c = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
    	c.rgb = 1.0 - c.rgb;
    	COLOR.rgb = c;
    	COLOR.a = texture(TEXTURE, UV).a;
    }