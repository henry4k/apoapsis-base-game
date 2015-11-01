#version 120
vec3 UnpackDUDVNormal( vec2 dudv ); // from Lighting.frag
vec3 CalcLightColor( vec3 albedo, vec3 specular, vec3 normal ); // from Lighting.frag

uniform sampler2D SurfaceSampler;
uniform sampler2D AlbedoSampler;
uniform sampler2D SpecularSampler;

varying vec2 TexCoord;

void main()
{
    vec4 surfaceTexel = texture2D(SurfaceSampler, TexCoord).rgba;
    vec2 dudv = surfaceTexel.rg;
    vec2 xy = surfaceTexel.ba;
    xy = vec2(xy.x, 1-xy.y);

    vec3 albedo   = texture2D(AlbedoSampler,   xy).rgb;
    vec3 specular = texture2D(SpecularSampler, xy).rgb;

    gl_FragColor.rgb = CalcLightColor(albedo,
                                      specular,
                                      UnpackDUDVNormal(dudv));
    gl_FragColor.a = 1.0;
}
