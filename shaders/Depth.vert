#version 120

attribute vec3 VertexPosition;
attribute vec2 VertexTexCoord;

varying vec2 TexCoord;

uniform mat4 MVP;

void main()
{
    gl_Position = MVP * vec4(VertexPosition, 1.0);
    TexCoord = VertexTexCoord;
}
