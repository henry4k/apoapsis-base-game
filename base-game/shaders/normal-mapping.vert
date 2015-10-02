#version 120

uniform mat4 View;
uniform mat4 ModelView;

attribute vec3 VertexPosition;
attribute vec3 VertexNormal;
attribute vec3 VertexTangent;
attribute vec3 VertexBitangent;

varying vec3 LightDirectionTS;
varying vec3 HalfWayDirectionTS;
varying vec3 CameraDirectionTS;

const vec3 LightDirectionWS = -normalize(vec3(-1, -1, 0));

void CalcTBNMatrix()
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
