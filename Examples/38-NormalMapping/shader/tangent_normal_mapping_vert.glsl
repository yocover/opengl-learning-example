#version 330 core
layout (location = 0) in vec3 iPosition;
layout (location = 1) in vec3 iNormal;
layout (location = 2) in vec2 iTexCoords;
layout (location = 3) in vec3 iTangent;
layout (location = 4) in vec3 iBitangent;

out VS_OUT{
    vec3 FragPos;
    vec2 TexCoords;
    vec3 TangentLightPos;
    vec3 TangentViewPos;
    vec3 TangentFragPos;
} vs_out;

uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
uniform mat4 modelMatrix;

uniform vec3 iLightPos;
uniform vec3 iViewPos;

void main(){

    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(iPosition, 1.0f);
    vs_out.FragPos = vec3(modelMatrix * vec4(iPosition, 1.0f));
    vs_out.TexCoords = iTexCoords;

    mat3 normalMatrix = transpose(inverse(mat3(modelMatrix)));
    vec3 T = normalize(normalMatrix * iTangent);
    vec3 B = normalize(normalMatrix * iBitangent);
    vec3 N = normalize(normalMatrix * iNormal);

    mat3 TBNMatrix = transpose(mat3(T, B, N));
    vs_out.TangentLightPos = TBNMatrix * iLightPos;
    vs_out.TangentViewPos = TBNMatrix * iViewPos;
    vs_out.TangentFragPos = TBNMatrix * vs_out.FragPos;
}