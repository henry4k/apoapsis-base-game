#version 150

uniform samplerCube Texture;
in vec3 TexCoord;

out vec4 FragmentColor;

void main()
{
    vec3 textureColor = texture(Texture, TexCoord).rgb;
    FragmentColor = vec4(textureColor, 1.0);
}
