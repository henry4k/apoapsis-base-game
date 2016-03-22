#version 130

vec3 CalcLightColor( vec3 albedo, vec3 specular, vec3 normalTS ); // from Lighting.frag

uniform sampler2D CloudSampler;

in vec2 TexCoord;

//varying vec3 LightDirectionCS;
//varying vec3 CameraDirectionCS;
//varying vec3 OuterPositionCS;
//varying vec3 InnerPositionCS;

const float CloudAmount     = 1.0;
const float TransitionWidth = 0.2;

const vec3 CloudAlbedo   = vec3(1,1,1);
const vec3 CloudSpecular = vec3(.2,.2,.28);

void main()
{
    float density = texture2D(CloudSampler, TexCoord).r;

    vec3 lightColor = CalcLightColor(CloudAlbedo,
                                     CloudSpecular,
                                     vec3(0, 0, 1));

    float start = 1.0-CloudAmount;
    float end = max(start+TransitionWidth, 1.0);
    float alpha = smoothstep(start, end, density);

    gl_FragColor.rgb = lightColor * alpha;
    gl_FragColor.a = alpha;
}
