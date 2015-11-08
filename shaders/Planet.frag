#version 120
vec3 UnpackDUDVNormal( vec2 dudv ); // from Lighting.frag
vec3 CalcLightColor( vec3 albedo, vec3 specular, vec3 normalTS ); // from Lighting.frag

uniform sampler2D SurfaceSampler;
uniform sampler2D AlbedoSampler;
uniform sampler2D SpecularSampler;
uniform sampler2D CloudSampler;

varying vec2 TexCoord;

void main()
{
    vec3 surfaceTexel = texture2D(SurfaceSampler, TexCoord).rgb;
    vec2 dudv = surfaceTexel.gb;
    float x = surfaceTexel.r;
    float y = abs(TexCoord.y * 2 - 1); // Gets one at the poles and zero at the equator.
    vec2 xy = vec2(x, 1-y);

    vec3 albedo   = texture2D(AlbedoSampler,   xy).rgb;
    vec3 specular = texture2D(SpecularSampler, xy).rgb;

    float cloudDensity = texture2D(CloudSampler, TexCoord).r;

    gl_FragColor.rgb = CalcLightColor(albedo,
                                      specular,
                                      UnpackDUDVNormal(dudv)) * (1-cloudDensity);
    gl_FragColor.a = 1.0;
}
