#version 120

varying vec3 LightDirectionTS;
varying vec3 HalfWayDirectionTS;
varying vec3 CameraDirectionTS;

const vec3 LightAmbientColor  = vec3(0.1, 0.1, 0.1);
const vec3 LightDiffuseColor  = vec3(1, 1, 1) - LightAmbientColor;
const vec3 LightSpecularColor = vec3(1, 1, 1);

vec3 CalcLightColor( vec3 albedo, vec3 specular, vec3 normal )
{
    vec3 lightDirectionTS  = normalize(LightDirectionTS);
    vec3 cameraDirectionTS = normalize(CameraDirectionTS);

    float lamberFactor = max(dot(lightDirectionTS, normal), 0.0);

    vec3 reflectionTS = reflect(lightDirectionTS, normal);

    // Cosine of the angle between the camera and reflection vector,
    float cosAlpha = dot(cameraDirectionTS, reflectionTS);
    // clamped to 0
    //  - Looking into the reflection -> 1
    //  - Looking elsewhere -> < 1
    cosAlpha = clamp(cosAlpha, 0,1);

    return albedo * (LightAmbientColor +
                     LightDiffuseColor * lamberFactor) +
           specular * LightSpecularColor * pow(cosAlpha, 5);
}

vec3 UnpackDUDVNormal( vec2 dudv )
{
    dudv = dudv * 2.0 - 1.0;
    float z = sqrt(1.0 - dudv.x*dudv.x - dudv.y*dudv.y);
    return vec3(dudv, z);
}
