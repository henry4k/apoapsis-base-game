#version 120
vec3 CalcLightColor( vec3 normalTexel ); // from normal-mapping.frag

uniform sampler2D DiffuseSampler;
uniform sampler2D NormalSampler;
uniform sampler2D CloudSampler;

varying vec2 TexCoord;

const float CloudShadowAlpha = 0.9;

void main()
{
    vec3 diffuseColor = texture2D(DiffuseSampler, TexCoord).rgb;

    vec3 lightColor = CalcLightColor(texture2D(NormalSampler, TexCoord).rgb);

    vec3 cloudColor   = texture2D(CloudSampler, TexCoord).rgb;
    float cloudShadow = 1.0 - cloudColor.r*CloudShadowAlpha;

    gl_FragColor = vec4(diffuseColor * lightColor * cloudShadow, 1.0);
}
