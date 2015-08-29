#version 120

varying mat3 TBN;

const vec3 LightDirection = vec3(0, 0, 1);
const vec3 LightDiffuseColor = vec3(1, 1, 1);

vec3 DecodeNormalTexel( const in vec3 n )
{
    return normalize( normalize(n * 2.0 - 1.0) * TBN );
}

vec3 CalcLightColor( vec3 normalTexel )
{
    vec3 normal = DecodeNormalTexel(normalTexel);
    float lightIntensity = max(dot(normal, LightDirection), 0.0);
    return LightDiffuseColor * lightIntensity;
}
