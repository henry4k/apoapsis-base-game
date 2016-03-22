#version 130

in vec3 VertexPosition;
in vec2 VertexTexCoord;

out vec2 TexCoord;

uniform mat4 MVP;

void main()
{
    gl_Position = MVP * vec4(VertexPosition, 1.0);
    TexCoord = VertexTexCoord;
}
