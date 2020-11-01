#version 330 core
layout (triangles) in;
layout (triangle_strip, max_vertices = 18) out;

uniform mat4 shadowMatrices[6]; // 光空间变换矩阵

out vec4 FragPos;

void main()
{
	for(int face = 0; face < 6; ++face)
	{
		gl_Layer = face; // 指定发送基本图形到立方体的那个面
		for(int i = 0; i < 3; ++i)
		{
			FragPos = gl_in[i].gl_Position;
			gl_Position	 = shadowMatrices[face] * FragPos;
			EmitVertex();
		}
		EndPrimitive();
	}
}

