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
uniform sampler2D albedo_texture : source_color;
uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D normal_map : source_color;
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

void fragment(){
	ALBEDO = texture(albedo_texture, UV).rgb * tint.rgb;
	//METALLIC = metallic;
}

void light(){
	vec3 normal;
		vec3 normal_from_texture;
		normal_from_texture = texture(normal_map, UV).rgb;
		normal = vec3(normal_from_texture.x * NORMAL.x,normal_from_texture.y * NORMAL.y, normal_from_texture.z);
		
		normal = NORMAL - normal_from_texture;
	
	float NdotL = dot(normal + normal_bias, LIGHT + light_bias);
	
	float hardLightInterpolation = smoothstep(shadow_size, shadow_blend + shadow_size, NdotL);
    float hardShadowInterpolation = 1.0 - hardLightInterpolation;
	vec3 lightIntensity = LIGHT_COLOR * hardLightInterpolation * light_tint.rgb * ATTENUATION;
	vec3 shadowIntensity = (hardShadowInterpolation * 1.4 * shadow_color.rgb);
 	vec3 intensity = lightIntensity + shadowIntensity;
	
	float rimLight = smoothstep(rimlight_size, rimlight_blend + rimlight_size, fresnel(1.0, NORMAL, VIEW));
	
	DIFFUSE_LIGHT += ALBEDO * (intensity + rimLight * rimlight_color.rgb);
}
