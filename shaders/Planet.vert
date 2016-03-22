#version 130

void CalcLight(); // from Lighting.vert

uniform mat4 ModelViewProjection;

in vec3 VertexPosition;
in vec2 VertexTexCoord;

out vec2 TexCoord;

void main()
{
    gl_Position = ModelViewProjection * vec4(VertexPosition, 1.0);
    TexCoord    = VertexTexCoord;
    CalcLight();
}
