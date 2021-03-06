#version 150

uniform mat4 ModelViewProjection;

in vec3 VertexPosition;

//out vec2 TexCoord;
out vec3 Normal;

void main()
{
    gl_Position = ModelViewProjection * vec4(VertexPosition, 1.0);
    //TexCoord = GenSphereTexCoords(normalize(VertexPosition));
    Normal = normalize(VertexPosition);
}

// https://stackoverflow.com/questions/14693182/creating-correct-texture-coordinates-for-a-sphere-in-opengl
// https://stackoverflow.com/questions/29080581/opengl-3-2-sphere-texture-coordinates
