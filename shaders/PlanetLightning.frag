#version 150

uniform sampler2D CloudSampler;

//in vec2 TexCoord;
in vec3 Normal;

out vec4 FragmentColor;

vec2 GenSphereTexCoords( vec3 normal )
{
    const float M_PI  = 3.14159265358979323846;
    const float M_PI2 = 3.14159265358979323846*2.0;

    const vec3 yReference = vec3(0,1,0);
    const vec3 xReference = vec3(1,0,0);

    vec3 normalXZ = normalize(vec3(normal.x, 0, normal.z));

    float y = acos(dot(yReference, -normal)) / M_PI;

    float x = acos(dot(xReference, normalXZ));
    if(normal.z < 0)
        x = M_PI + (M_PI-x);
    x = x / M_PI2;

    return vec2(x,y);
}

void main()
{
    vec2 TexCoord = GenSphereTexCoords(normalize(Normal));
    vec4 cloudTexel = texture(CloudSampler, TexCoord).rgba;
    FragmentColor = vec4(cloudTexel.bbb, 1.0);
}
