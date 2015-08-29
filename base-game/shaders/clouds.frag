#version 120
vec3 CalcLightColor( vec3 normalTexel ); // from normal-mapping.frag

uniform sampler2D DiffuseSampler;
uniform sampler2D NormalSampler;

varying vec2 TexCoord;

void main()
{
    vec3 diffuseColor = texture2D(DiffuseSampler, TexCoord).rgb;

    vec3 lightColor = CalcLightColor(texture2D(NormalSampler, TexCoord).rgb);

    gl_FragColor = vec4(diffuseColor * lightColor, diffuseColor.r);
}
