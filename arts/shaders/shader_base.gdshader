shader_type spatial;
render_mode unshaded;
uniform vec4 albedo_color : source_color = vec4(1,1,1,1);
uniform sampler2D texture_albedo : source_color, filter_linear;

void fragment () {
    vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO =  albedo_color.rgb * albedo_tex.rgb;
}

