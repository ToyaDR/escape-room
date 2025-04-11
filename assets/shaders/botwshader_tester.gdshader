// BoTW Toon Shader by NekotoArts
// wrote this at 2AM
//
//
//
// England is my city
// Smoke trees
// Two to the One from the One to the Three
shader_type spatial;
render_mode diffuse_toon, specular_toon;

uniform vec4 tint : source_color;
uniform sampler2D albedo_texture : source_color,filter_linear_mipmap,repeat_enable;
uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D normal_map : source_color,hint_roughness_normal,filter_linear_mipmap,repeat_enable;
uniform float shadow_size = 0.045;
uniform float shadow_blend = 0.001;
uniform float shadow_extra_intensity = 0.0;
uniform vec4 shadow_color : source_color;
uniform vec4 light_tint : source_color;
uniform float rimlight_size = 0.921;
uniform float rimlight_blend = 0.01;
uniform vec4 rimlight_color : source_color;
uniform vec3 normal_bias = vec3(0.0);
uniform vec3 light_bias = vec3(0.0);
varying vec3 uv1_triplanar_pos;
uniform float uv1_blend_sharpness;
varying vec3 uv1_power_normal;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;


float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

//varying vec3 vertex_normal;
//varying vec3 vertex_tangent;

//void vertex(){
	//vertex_normal = NORMAL;
	//vertex_normal = TANGENT;
//}

void vertex() {
	vec3 normal = NORMAL;
	TANGENT = vec3(0.0,0.0,-1.0) * abs(normal.x);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(normal.y);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(normal.z);
	TANGENT = normalize(TANGENT);
	BINORMAL = vec3(0.0,1.0,0.0) * abs(normal.x);
	BINORMAL+= vec3(0.0,0.0,-1.0) * abs(normal.y);
	BINORMAL+= vec3(0.0,1.0,0.0) * abs(normal.z);
	BINORMAL = normalize(BINORMAL);
	uv1_power_normal=pow(abs(NORMAL),vec3(uv1_blend_sharpness));
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset;
	uv1_power_normal/=dot(uv1_power_normal,vec3(1.0));
	uv1_triplanar_pos *= vec3(-1.0,-1.0, 1.0);
}

vec4 triplanar_texture(sampler2D p_sampler,vec3 p_weights,vec3 p_triplanar_pos) {
	vec4 samp=vec4(0.0);
	samp+= texture(p_sampler,p_triplanar_pos.xy) * p_weights.z;
	samp+= texture(p_sampler,p_triplanar_pos.xz) * p_weights.y;
	samp+= texture(p_sampler,p_triplanar_pos.zy * vec2(-1.0,1.0)) * p_weights.x;
	return samp;
}

void fragment(){
	//ALBEDO = texture(albedo_texture, UV).rgb * tint.rgb;
	vec4 albedo_tex = triplanar_texture(albedo_texture,uv1_power_normal,uv1_triplanar_pos);
	ALBEDO = tint.rgb * albedo_tex.rgb;
	METALLIC = metallic;
}

void light(){
	vec3 normal;
		vec3 normal_from_texture;
		normal_from_texture = texture(normal_map, UV).rgb;
		normal = vec3(normal_from_texture.x * NORMAL.x,normal_from_texture.y * NORMAL.y, normal_from_texture.z);
		normal = NORMAL - triplanar_texture(normal_map,uv1_power_normal,uv1_triplanar_pos).rgb;
	//
	//if (use_view){
		//normal -= VIEW * view_bias.rgb * view_multiplier;
	//}
	
	float NdotL = dot(normal + normal_bias, LIGHT + light_bias);
	
	float rounded = smoothstep(shadow_size, shadow_blend + shadow_size, NdotL);
	float one_minus = 1.0 - rounded;
	vec3 mult1 = LIGHT_COLOR * rounded * light_tint.rgb * ATTENUATION;
	vec3 mult2 = (one_minus * 1.4 * shadow_color.rgb) - shadow_extra_intensity;
	vec3 add1 = mult1 + mult2;
	
	float add3  = rimlight_blend + rimlight_size;
	float basic_fresnel = fresnel(1.0, NORMAL, VIEW);
	float smoothed = smoothstep(rimlight_size, add3, basic_fresnel);
	
	vec3 add2 = add1 + smoothed * rimlight_color.rgb;
	DIFFUSE_LIGHT += ALBEDO * add2;
}
