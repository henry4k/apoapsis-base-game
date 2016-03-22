#version 130

void CalcLight(); // from Lighting.vert

uniform mat4 View;
uniform mat4 ModelView;
uniform mat4 ModelViewProjection;

in vec3 VertexPosition;
in vec2 VertexTexCoord;

out vec2 TexCoord;
out vec3 NormalWS;
//out vec3 LightDirectionCS;
//out vec3 CameraDirectionCS;
//out vec3 OuterPositionCS;
//out vec3 InnerPositionCS;

void main()
{
    mat3 viewRotation = mat3(View);

    gl_Position = ModelViewProjection * vec4(VertexPosition*1.01, 1.0);
    TexCoord    = VertexTexCoord;

    //OuterPositionCS = vec3(ModelView * vec4(VertexPosition*1.01, 1.0));
    //InnerPositionCS = vec3(ModelView * vec4(VertexPosition,     1.0));

    //LightDirectionCS  = viewRotation * LightDirectionWS;
    //CameraDirectionCS = normalize(InnerPositionCS);

    CalcLight();
}
