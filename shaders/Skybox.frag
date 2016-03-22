#version 130

uniform samplerCube Texture;
in vec3 TexCoord;

void main()
{
    vec3 textureColor = textureCube(Texture, TexCoord).rgb;
    gl_FragColor = vec4(pow(textureColor, vec3(1,1,1)*1.0/2.2), 1.0);
}
