#version 120

attribute vec3 VertexPosition;

varying vec3 TexCoord;

uniform mat4 ModelViewProjection;

void main()
{
    gl_Position = ModelViewProjection * vec4(VertexPosition, 1.0);
    TexCoord = -normalize( VertexPosition );
}
