#version 330 core
layout (location = 0) in vec3 aPos;

uniform mat4 model;// 模型矩阵 作用 将顶点转换到世界坐标系
uniform mat4 view; // 视图矩阵 作用 将世界坐标转换到观察空间
uniform mat4 projection; // 投影矩阵 作用 将世界坐标投影到裁剪坐标

void main()
{
    gl_Position = projection * view *  model * vec4(aPos, 1.0);
}