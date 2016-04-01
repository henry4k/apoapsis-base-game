#version 150

uniform samplerCube Texture;
in vec3 TexCoord;

out vec4 FragmentColor;

void main()
{
    vec3 textureColor = texture(Texture, TexCoord).rgb;
    FragmentColor = vec4(pow(textureColor, vec3(1.0/2.2)), 1.0);
}
