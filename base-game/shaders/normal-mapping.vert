#version 120

uniform mat4 ModelViewInverseTranspose;
uniform mat4 InverseModelView;

attribute vec3 VertexNormal;
attribute vec4 VertexTangent;

varying mat3 TBN;

void CalcTBNMatrix()
{
    mat4 normalMatrix = mat4(1.0); //transpose(InverseModelView);
    //mat4 normalMatrix = ModelViewInverseTranspose;

    vec3 normal = vec3(normalize(normalMatrix * vec4(VertexNormal, 1.0)));

    // TBN matrix
    vec4 tangent = normalize(normalMatrix * VertexTangent);
    vec3 n = normal;
    vec3 t = tangent.xyz * tangent.w;
    vec3 b = cross(n, t) * VertexTangent.w;
    TBN = mat3(
        t.x, b.x, n.x,
        t.y, b.y, n.y,
        t.z, b.z, n.z
    );
}
