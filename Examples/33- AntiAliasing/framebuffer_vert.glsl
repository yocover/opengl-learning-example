#version 330 core
layout (location = 0) in vec2 aPos;
layout (location = 1) in ivec2 aTexCoords;

flat out ivec2 TexCoords;

void main()
{
	gl_Position = vec4(aPos.x, aPos.y, 0.0, 1.0);
	TexCoords = aTexCoords;
}