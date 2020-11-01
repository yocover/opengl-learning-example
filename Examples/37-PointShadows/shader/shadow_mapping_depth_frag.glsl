#version 330 core
in vec4 FragPos;


uniform vec3 lightPos;
uniform float far_plane;

void main()
{
	// 获取片元位置到光位置的距离
	float lightDistance = length(FragPos.xyz - lightPos);

	// 将距离映射到0到1的范围
	lightDistance = lightDistance / far_plane;

	gl_FragDepth = lightDistance;
}