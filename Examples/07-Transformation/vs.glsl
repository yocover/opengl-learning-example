#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec4 aColor;
layout (location = 2) in vec2 aTexCoord;

uniform float xOffset;

out vec4 ourColor;
out vec2 TexCoord;

uniform mat4 transform;

void main()
{
    gl_Position = transform * vec4(aPos.x + xOffset, aPos.y,aPos.z, 1.0) ;
    ourColor = aColor;
    TexCoord = aTexCoord;
}