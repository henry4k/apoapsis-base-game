#version 120
vec3 CalcLightColorFromDUDV( vec2 dudv ); // from normal-mapping.frag

uniform sampler2D SurfaceSampler;
uniform sampler2D MaterialSampler;

varying vec2 TexCoord;

void main()
{
    vec4 surfaceTexel = texture2D(SurfaceSampler, TexCoord).rgba;
    vec2 dudv = surfaceTexel.rg;
    vec2 xy = surfaceTexel.ba;
    xy = vec2(xy.x, 1-xy.y);

    vec3 surfaceColor = texture2D(MaterialSampler, xy).rgb;

    vec3 lightColor = CalcLightColorFromDUDV(dudv);

    gl_FragColor = vec4(surfaceColor * lightColor, 1.0);
}
