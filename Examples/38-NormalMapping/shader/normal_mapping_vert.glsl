#version 330 core
layout (location = 0)in vec3 aPos;
layout (location = 2)in vec2 aTexCoords;

out VS_OUT
{
	vec2 TexCoords;
	vec3 FragPos;
}vs_out;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

void main()
{
	gl_Position = projection * view * model * vec4(aPos, 1.0);
	vs_out.TexCoords = aTexCoords;
	vs_out.FragPos = aPos;
}