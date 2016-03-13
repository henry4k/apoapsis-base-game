#version 150

uniform samplerCube Texture;
in vec3 TexCoord;

void main()
{
    vec3 textureColor = texture(Texture, TexCoord).rgb;
    gl_FragColor = vec4(textureColor, 1.0);
}
