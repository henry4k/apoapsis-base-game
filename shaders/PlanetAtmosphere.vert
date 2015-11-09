#version 120
void CalcLight(); // from Lighting.vert

uniform mat4 View;
uniform mat4 ModelView;
uniform mat4 ModelViewProjection;

attribute vec3 VertexPosition;
attribute vec2 VertexTexCoord;

varying vec2 TexCoord;
varying vec3 NormalWS;
//varying vec3 LightDirectionCS;
//varying vec3 CameraDirectionCS;
//varying vec3 OuterPositionCS;
//varying vec3 InnerPositionCS;

void main()
{
    mat3 viewRotation = mat3(View);

    gl_Position = ModelViewProjection * vec4(VertexPosition*1.01, 1.0);
    TexCoord    = VertexTexCoord;

    //OuterPositionCS = vec3(ModelView * vec4(VertexPosition*1.01, 1.0));
    //InnerPositionCS = vec3(ModelView * vec4(VertexPosition,     1.0));

    //LightDirectionCS  = viewRotation * LightDirectionWS;
    //CameraDirectionCS = normalize(InnerPositionCS);

    CalcLight();
}
