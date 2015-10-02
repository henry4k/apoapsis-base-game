#version 120

varying vec3 LightDirectionTS;
varying vec3 HalfWayDirectionTS;
varying vec3 CameraDirectionTS;

const vec3 LightDiffuseColor = vec3(1, 1, 1);

vec3 UnpackDUDVNormal( vec2 dudv )
{
    dudv = dudv * 2.0 - 1.0;
    float z = sqrt(1.0 - dudv.x*dudv.x - dudv.y*dudv.y);
    return vec3(dudv, z);
}

vec3 CalcLightColorFromDUDV( vec2 dudv )
{
    vec3 normal = UnpackDUDVNormal(dudv);
    float lamberFactor = max(dot(LightDirectionTS, normal), 0.0);
    return LightDiffuseColor * lamberFactor;
}
