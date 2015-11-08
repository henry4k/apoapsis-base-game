#version 120
vec3 CalcLightColor( vec3 albedo, vec3 specular, vec3 normalTS ); // from Lighting.frag

uniform sampler2D CloudSampler;

varying vec2 TexCoord;

varying vec3 LightDirectionCS;
varying vec3 CameraDirectionCS;
varying vec3 OuterPositionCS;
varying vec3 InnerPositionCS;

const float CloudAmount     = 1.0;
const float TransitionWidth = 0.2;

const vec3 CloudAlbedo   = vec3(1,1,1);
const vec3 CloudSpecular = vec3(1,1,1.4);

void main()
{
    /*
    float ln  = dot(LightDirectionCS, OuterPositionCS);
    float lnn = dot(LightDirectionCS, InnerPositionCS);
    float lc  = dot(LightDirectionCS, CameraDirectionCS);

    ln  = max(0, ln +0.5);
    lnn = max(0, lnn+0.5);

    float x = clamp(ln + lnn*lc, 0.0, 1.0) *
              clamp(lc + 1.0 + 0.5, 0.0, 1.0);

    gl_FragColor.rgba = vec4(lnn, lnn, lnn, 1.0);
    */

    float density = texture2D(CloudSampler, TexCoord).r;

    vec3 lightColor = CalcLightColor(CloudAlbedo,
                                     CloudSpecular,
                                     vec3(0, 0, 1));

    gl_FragColor.rgb = lightColor;

    float start = 1.0-CloudAmount;
    float end = max(start+TransitionWidth, 1.0);
    gl_FragColor.a = smoothstep(start, end, density);
}
