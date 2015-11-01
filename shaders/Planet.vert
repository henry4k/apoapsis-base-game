#version 120
void CalcLight(); // from Lighting.vert

uniform mat4 ModelViewProjection;

attribute vec3 VertexPosition;
attribute vec2 VertexTexCoord;

varying vec2 TexCoord;

void main()
{
    gl_Position = ModelViewProjection * vec4(VertexPosition, 1.0);
    TexCoord    = VertexTexCoord;
    CalcLight();
}
