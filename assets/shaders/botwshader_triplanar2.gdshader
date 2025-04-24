// NOTE: Shader automatically converted from Godot Engine 4.2.1.stable.mono's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform float point_size : hint_range(0,128);
uniform float roughness : hint_range(0,1);
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular;
uniform float metallic;
uniform sampler2D normal_map : source_color,filter_linear_mipmap,repeat_enable;
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
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}
void vertex() {
	vec3 normal = MODEL_NORMAL_MATRIX * NORMAL;
	TANGENT = vec3(0.0,0.0,-1.0) * abs(normal.x);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(normal.y);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(normal.z);
	TANGENT = inverse(MODEL_NORMAL_MATRIX) * normalize(TANGENT);
	BINORMAL = vec3(0.0,1.0,0.0) * abs(normal.x);
	BINORMAL+= vec3(0.0,0.0,-1.0) * abs(normal.y);
	BINORMAL+= vec3(0.0,1.0,0.0) * abs(normal.z);
	BINORMAL = inverse(MODEL_NORMAL_MATRIX) * normalize(BINORMAL);
	uv1_power_normal=pow(abs(normal),vec3(uv1_blend_sharpness));
	uv1_triplanar_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0f)).xyz * uv1_scale + uv1_offset;
	uv1_power_normal/=dot(uv1_power_normal,vec3(1.0));
	uv1_triplanar_pos *= vec3(1.0,-1.0, 1.0);
}




vec4 triplanar_texture(sampler2D p_sampler,vec3 p_weights,vec3 p_triplanar_pos) {
	vec4 samp=vec4(0.0);
	samp+= texture(p_sampler,p_triplanar_pos.xy) * p_weights.z;
	samp+= texture(p_sampler,p_triplanar_pos.xz) * p_weights.y;
	samp+= texture(p_sampler,p_triplanar_pos.zy * vec2(-1.0,1.0)) * p_weights.x;
	return samp;
}


void fragment() {
	vec4 albedo_tex = triplanar_texture(texture_albedo,uv1_power_normal,uv1_triplanar_pos);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	float metallic_tex = dot(triplanar_texture(texture_metallic,uv1_power_normal,uv1_triplanar_pos),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);
	float roughness_tex = dot(triplanar_texture(texture_roughness,uv1_power_normal,uv1_triplanar_pos),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
}

void light(){
	vec4 normal = triplanar_texture(normal_map,uv1_power_normal,uv1_triplanar_pos);
	float NdotL = dot(NORMAL - normal.rgb + normal_bias, LIGHT + light_bias);
	
	float hardLightInterpolation = smoothstep(shadow_size, shadow_blend + shadow_size, NdotL);
    float hardShadowInterpolation = 1.0 - hardLightInterpolation;
	vec3 lightIntensity = LIGHT_COLOR * hardLightInterpolation * light_tint.rgb * ATTENUATION;
	vec3 shadowIntensity = (hardShadowInterpolation * 1.4 * shadow_color.rgb);
 	vec3 intensity = lightIntensity + shadowIntensity;
	
	float rimLight = smoothstep(rimlight_size, rimlight_blend + rimlight_size, fresnel(1.0, NORMAL, VIEW));
	
	DIFFUSE_LIGHT += ALBEDO * (intensity + rimLight * rimlight_color.rgb);
}
