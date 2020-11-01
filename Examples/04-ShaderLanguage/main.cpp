#include <GL/glad.h>
#include <GL/glfw3.h>
#include "Shader.h"

#include <iostream>
using namespace std;

void framebuffer_size_callback(GLFWwindow *window, int width, int height);
void processInput(GLFWwindow *window);

int main()
{

	// 初始化GLFW
	glfwInit();

	// 配置GLFW
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

	// 创建GLFW窗口对象
	GLFWwindow *window = glfwCreateWindow(800, 600, "demo01", NULL, NULL);

	if (window == NULL)
	{
		cout << "初始化glfw窗口失败!" << endl;
		glfwTerminate();
		return -1;
	}
	glfwMakeContextCurrent(window);

	// 初始化GLAD
	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
	{
		cout << "初始化GLAD失败!" << endl;
		return -1;
	}

	// 设置视口
	glViewport(0, 0, 800, 600);

	// 注测窗口监听
	glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

	// 顶点数组
	float vertices[] = {
		// 顶点位置xyz		颜色 rgba
		-0.5f, -0.5f, 0.0f, 1.0f, 0.0f, 0.0f, 1.0f, // 左下
		0.5f, -0.5f, 0.0f, 0.0f, 1.0f, 0.0f, 1.0f,	// 右下
		0.0f, 0.5f, 0.0f, 0.0f, 0.0f, 1.0f, 1.0f };	// 顶部

													// 生成VBO对象
	unsigned int VBO;
	glGenBuffers(1, &VBO);

	// 创建顶点数组对象
	unsigned int VAO;
	glGenVertexArrays(1, &VAO);
	// 绑定VAO
	glBindVertexArray(VAO);
	// 绑定缓冲到目标缓冲
	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

	// 顶点位置
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 7 * sizeof(float), (void *)0);
	glEnableVertexAttribArray(0);

	// 顶点颜色
	glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 7 * sizeof(float), (void *)(3 * sizeof(float)));
	glEnableVertexAttribArray(1);

	Shader ourShader("vs.glsl", "fs.glsl");

	// 5 解析顶点数据
	// 参数1 location
	// 参数2 顶点属性的大小
	// 参数3 数据类型
	// 参数4 是否数据标准化
	// 参数5 步长
	// 参数6 起始位置的偏移量
	// glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void *)0);
	// // 启用顶点属性
	// glEnableVertexAttribArray(0);

	// 绑定buffer
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glBindVertexArray(0);

	// 使用现况绘制模式
	// glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

	//渲染循环
	while (!glfwWindowShouldClose(window))
	{

		// 检测是否需要退出窗口
		processInput(window);

		// 渲染指令

		// 设置清除颜色 -- 状态设置
		glClearColor(0.2f, 0.3f, 0.4f, 1.0f);

		//开始清空屏幕并且使用上面的颜色 -- 状态使用
		glClear(GL_COLOR_BUFFER_BIT);

		// 绘制物体
		// glUseProgram(shaderProgram);
		ourShader.use();

		glBindVertexArray(VAO);
		glDrawArrays(GL_TRIANGLES, 0, 3);

		// 参数1 图元类型
		// 参数2 顶点数组的起始索引
		// 参数3 绘制的顶点个数
		// glDrawArrays(GL_LINE_LOOP, 0, 3);

		// 交换颜色缓冲区
		glfwSwapBuffers(window);

		// 检查是否出发相关事件
		glfwPollEvents();
	}

	// 删除相关资源
	glDeleteBuffers(1, &VBO);
	glDeleteVertexArrays(1, &VAO);

	// 删除/释放资源
	glfwTerminate();
	return 0;
}

// 窗口大小变换监听
void framebuffer_size_callback(GLFWwindow *window, int width, int height)
{
	glViewport(0, 0, width, height);
}

// 输入监听
void processInput(GLFWwindow *window)
{
	if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
	{
		glfwSetWindowShouldClose(window, true);
	}
}