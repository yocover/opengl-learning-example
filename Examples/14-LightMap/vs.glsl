#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;

uniform mat4 model;// 模型矩阵 作用 将顶点转换到世界坐标系
uniform mat4 view; // 视图矩阵 作用 将世界坐标转换到观察空间
uniform mat4 projection; // 投影矩阵 作用 将世界坐标投影到裁剪坐标

out vec3 FragPos; // 顶点位置转换到世界空间的坐标
out vec3 Normal;
out vec2 TexCoords;
void main()
{
	FragPos = vec3(model * vec4(aPos, 1.0));
	Normal = mat3(transpose(inverse(model))) * aNormal;
	TexCoords = aTexCoords;

    gl_Position = projection * view *  model * vec4(aPos, 1.0);

}