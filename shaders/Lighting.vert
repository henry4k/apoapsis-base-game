#version 150

uniform mat4 View;
uniform mat4 ModelView;

in vec3 VertexPosition;
in vec3 VertexNormal;
in vec3 VertexTangent;
in vec3 VertexBitangent;

out vec3 LightDirectionTS;
out vec3 HalfWayDirectionTS;
out vec3 CameraDirectionTS;

const vec3 LightDirectionWS = -normalize(vec3(-0.6, 0, 1));

void CalcLight()
{
    mat3 viewRotation      = mat3(View);
    mat3 modelViewRotation = mat3(ModelView);

    vec3 t = normalize(modelViewRotation * VertexTangent);
    vec3 b = normalize(modelViewRotation * VertexBitangent);
    vec3 n = normalize(modelViewRotation * VertexNormal);
    mat3 tbn = transpose(mat3(t, b, n)); // Transforms from model space to tangent space

    vec3 positionCS = vec3(ModelView * vec4(VertexPosition, 1.0));

    vec3 lightDirectionCS   = viewRotation * LightDirectionWS;
    vec3 cameraDirectionCS  = normalize(positionCS);
    vec3 halfWayDirectionCS = normalize(cameraDirectionCS + lightDirectionCS);

    LightDirectionTS   = tbn * lightDirectionCS;
    CameraDirectionTS  = tbn * cameraDirectionCS;
    HalfWayDirectionTS = tbn * halfWayDirectionCS;
}
