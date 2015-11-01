#version 120
uniform mat4 View;
uniform mat4 ModelView;
uniform mat4 ModelViewProjection;

attribute vec3 VertexPosition;
attribute vec3 VertexNormal;

varying vec3 LightDirectionCS;
varying vec3 CameraDirectionCS;
varying vec3 OuterPositionCS;
varying vec3 InnerPositionCS;

const vec3 LightDirectionWS = -normalize(vec3(-1, 0, 0));

void main()
{
    mat3 viewRotation = mat3(View);

    gl_Position = ModelViewProjection * vec4(VertexPosition*1.1, 1.0);

    OuterPositionCS = vec3(ModelView * vec4(VertexPosition*1.1, 1.0));
    InnerPositionCS = vec3(ModelView * vec4(VertexPosition,     1.0));

    LightDirectionCS  = viewRotation * LightDirectionWS;
    CameraDirectionCS = normalize(InnerPositionCS);
}
