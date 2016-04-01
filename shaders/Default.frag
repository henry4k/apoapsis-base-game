#version 150

vec3 UnpackDUDVNormal( vec2 dudv ); // from Lighting.frag
vec3 CalcLightColor( vec3 albedo, vec3 specular, vec3 normalTS ); // from Lighting.frag

uniform sampler2D AlbedoSampler;
uniform sampler2D SpecularSampler;
uniform sampler2D NormalSampler;

in vec2 TexCoord;

out vec4 FragmentColor;

void main()
{
    vec3 albedo   = texture(AlbedoSampler,   TexCoord).rgb;
    vec3 specular = texture(SpecularSampler, TexCoord).rgb;
    vec3 normal   = texture(NormalSampler,   TexCoord).rgb * 2.0 - 1.0;

    FragmentColor.rgb = CalcLightColor(albedo, specular, normal);
    FragmentColor.a = 1.0;
}
