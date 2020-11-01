#version 330 core
layout (location = 0) in vec3 aPos;

uniform mat4 model;

void main()
{
	// 将顶点位置变换到世界空间并发送到几何着色器
	gl_Position =  model * vec4(aPos, 1.0);
}