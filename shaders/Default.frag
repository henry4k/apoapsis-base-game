#version 120

vec3 UnpackDUDVNormal( vec2 dudv ); // from Lighting.frag
vec3 CalcLightColor( vec3 albedo, vec3 specular, vec3 normalTS ); // from Lighting.frag

uniform sampler2D AlbedoSampler;
uniform sampler2D SpecularSampler;
uniform sampler2D NormalSampler;

varying vec2 TexCoord;

void main()
{
    vec3 albedo   = texture2D(AlbedoSampler,   TexCoord).rgb;
    vec3 specular = texture2D(SpecularSampler, TexCoord).rgb;
    vec3 normal   = texture2D(NormalSampler,   TexCoord).rgb * 2.0 - 1.0;

    gl_FragColor.rgb = CalcLightColor(albedo, specular, normal);
    gl_FragColor.a = 1.0;
}
