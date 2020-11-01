//#include "imgui/imgui.h"
//#include "imgui/imgui_impl_glfw.h"
//#include "imgui/imgui_impl_opengl3.h"
//#include <stdio.h>
//
//#include <GL/glad.h>
//#include <GL/glfw3.h>
//#include <iostream>
//#include <map>
//
//#include <Shader.h>
//#include <camera.h>
//#define STB_IMAGE_IMPLEMENTATION
//#include <stb_image.h>
//
//#include <glm/glm.hpp>
//#include <glm/gtc/matrix_transform.hpp>
//#include <glm/gtc/type_ptr.hpp>
//
//using namespace std;
//
//void framebuffer_size_callback(GLFWwindow *window, int width, int height);
//void processInput(GLFWwindow *window);
//void mouse_callback(GLFWwindow* window, double xpos, double ypos);
//void scroll_callback(GLFWwindow* window, double xoffset, double yoffset);
//unsigned int loadTexture(char const * path);
//unsigned int loadCubemap(vector<std::string> faces);
//
//
//const unsigned int  SCREEN_WIDTH = 800;
//const unsigned int SCREEN_HEIGHT = 600;
//
//Camera camera(glm::vec3(1.0f, 1.0f, 3.0f));
//
//
//float deltaTime = 0.0f; // 当前帧与上一帧之间的时间差
//float lastTime = 0.0f; // 上一帧的时间
//
//float lastX = SCREEN_WIDTH / 2.0f; // 鼠标上一帧的位置
//float lastY = SCREEN_HEIGHT / 2.0f;
//bool firstMouse = true;
//
//
//int main()
//{
//
//	// 初始化GLFW
//	glfwInit();
//
//	// 配置GLFW
//	const char* glsl_version = "#version 330";
//	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
//	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
//	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
//
//	// 创建GLFW窗口对象
//	GLFWwindow *window = glfwCreateWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "OpenGL", NULL, NULL);
//
//	if (window == NULL)
//	{
//		cout << "初始化glfw窗口失败!" << endl;
//		glfwTerminate();
//		return -1;
//	}
//	glfwMakeContextCurrent(window);
//
//	// 设置绘制模式
//	glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_NORMAL);
//	glfwSetCursorPosCallback(window, mouse_callback);
//	glfwSetScrollCallback(window, scroll_callback);
//
//	// 初始化GLAD
//	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
//	{
//		cout << "初始化GLAD失败!" << endl;
//		return -1;
//	}
//
//	// 设置视口
//	glViewport(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//
//	// 注测窗口监听
//	glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
//
//	// 深度测试
//	glEnable(GL_DEPTH_TEST);
//	glDepthFunc(GL_LESS);
//
//	// 混合
//	glEnable(GL_BLEND);
//	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//
//	// 面剔除
//	glEnable(GL_CULL_FACE);
//	glCullFace(GL_BACK); // 剔除背向的面
//	glFrontFace(GL_CCW);//将顺时针的面定义为正向的面
//
//	glEnable(GL_PROGRAM_POINT_SIZE);
//
//	Shader screenShader("framebuffer_vert.glsl", "framebuffer_frag.glsl");
//	Shader skyboxShader("skybox_vert.glsl", "skybox_frag.glsl");
//	Shader instanceShader("instance_vert.glsl", "instance_frag.glsl");
//
//
//	float screenVertices[] = {
//		// positions   // texCoords
//		-1.0f,  1.0f,  0.0f, 1.0f,
//		-1.0f, -1.0f,  0.0f, 0.0f,
//		1.0f, -1.0f,  1.0f, 0.0f,
//
//		-1.0f,  1.0f,  0.0f, 1.0f,
//		1.0f, -1.0f,  1.0f, 0.0f,
//		1.0f,  1.0f,  1.0f, 1.0f
//	};
//
//	float skyboxVertices[] = {
//		// positions          
//		-1.0f,  1.0f, -1.0f,
//		-1.0f, -1.0f, -1.0f,
//		1.0f, -1.0f, -1.0f,
//		1.0f, -1.0f, -1.0f,
//		1.0f,  1.0f, -1.0f,
//		-1.0f,  1.0f, -1.0f,
//
//		-1.0f, -1.0f,  1.0f,
//		-1.0f, -1.0f, -1.0f,
//		-1.0f,  1.0f, -1.0f,
//		-1.0f,  1.0f, -1.0f,
//		-1.0f,  1.0f,  1.0f,
//		-1.0f, -1.0f,  1.0f,
//
//		1.0f, -1.0f, -1.0f,
//		1.0f, -1.0f,  1.0f,
//		1.0f,  1.0f,  1.0f,
//		1.0f,  1.0f,  1.0f,
//		1.0f,  1.0f, -1.0f,
//		1.0f, -1.0f, -1.0f,
//
//		-1.0f, -1.0f,  1.0f,
//		-1.0f,  1.0f,  1.0f,
//		1.0f,  1.0f,  1.0f,
//		1.0f,  1.0f,  1.0f,
//		1.0f, -1.0f,  1.0f,
//		-1.0f, -1.0f,  1.0f,
//
//		-1.0f,  1.0f, -1.0f,
//		1.0f,  1.0f, -1.0f,
//		1.0f,  1.0f,  1.0f,
//		1.0f,  1.0f,  1.0f,
//		-1.0f,  1.0f,  1.0f,
//		-1.0f,  1.0f, -1.0f,
//
//		-1.0f, -1.0f, -1.0f,
//		-1.0f, -1.0f,  1.0f,
//		1.0f, -1.0f, -1.0f,
//		1.0f, -1.0f, -1.0f,
//		-1.0f, -1.0f,  1.0f,
//		1.0f, -1.0f,  1.0f
//	};
//
//	float points[] = {
//		-0.5f,  0.5f, 1.0f, 0.0f, 0.0f, // 左上
//		0.5f,  0.5f, 0.0f, 1.0f, 0.0f, // 右上
//		0.5f, -0.5f, 0.0f, 0.0f, 1.0f, // 右下
//		-0.5f, -0.5f, 1.0f, 1.0f, 0.0f  // 左下
//	};
//
//	float quadVertices[] = {
//		// 位置          // 颜色
//		-0.05f,  0.05f,  1.0f, 0.0f, 0.0f,
//		0.05f, -0.05f,  0.0f, 1.0f, 0.0f,
//		-0.05f, -0.05f,  0.0f, 0.0f, 1.0f,
//
//		-0.05f,  0.05f,  1.0f, 0.0f, 0.0f,
//		0.05f, -0.05f,  0.0f, 1.0f, 0.0f,
//		0.05f,  0.05f,  0.0f, 1.0f, 1.0f
//	};
//
//	// screen quad VAO
//	unsigned int screenVAO, screenVBO;
//	glGenVertexArrays(1, &screenVAO);
//	glGenBuffers(1, &screenVBO);
//	glBindVertexArray(screenVAO);
//	glBindBuffer(GL_ARRAY_BUFFER, screenVBO);
//	glBufferData(GL_ARRAY_BUFFER, sizeof(screenVertices), &screenVertices, GL_STATIC_DRAW);
//	glEnableVertexAttribArray(0);
//	glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(float), (void*)0);
//	glEnableVertexAttribArray(1);
//	glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(float), (void*)(2 * sizeof(float)));
//
//	// skyboxVBO quad VAO
//	unsigned int skyboxVAO, skyboxVBO;
//	glGenVertexArrays(1, &skyboxVAO);
//	glGenBuffers(1, &skyboxVBO);
//	glBindVertexArray(skyboxVAO);
//	glBindBuffer(GL_ARRAY_BUFFER, skyboxVBO);
//	glBufferData(GL_ARRAY_BUFFER, sizeof(skyboxVertices), &skyboxVertices, GL_STATIC_DRAW);
//	glEnableVertexAttribArray(0);
//	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
//
//	unsigned int quadVAO, quadVBO;
//	glGenVertexArrays(1, &quadVAO);
//	glGenBuffers(1, &quadVBO);
//	glBindVertexArray(quadVAO);
//	glBindBuffer(GL_ARRAY_BUFFER, quadVBO);
//	glBufferData(GL_ARRAY_BUFFER, sizeof(quadVertices), &quadVertices, GL_STATIC_DRAW);
//	glEnableVertexAttribArray(0);
//	glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
//	glEnableVertexAttribArray(1);
//	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(2 * sizeof(float)));
//	glEnableVertexAttribArray(0);
//
//
//	// 创建imgui上下文
//	ImGui::CreateContext();
//	ImGuiIO& io = ImGui::GetIO(); (void)io;
//	ImGui::StyleColorsDark();
//	ImGui_ImplGlfw_InitForOpenGL(window, true);
//	ImGui_ImplOpenGL3_Init(glsl_version);
//
//	screenShader.use();
//	screenShader.setInt("screenTexture", 0);
//
//	skyboxShader.use();
//	skyboxShader.setInt("skybox", 0);
//
//
//	vector<glm::vec3> windows
//	{
//		glm::vec3(-1.5f, 0.0f, -0.48f),
//		glm::vec3(1.5f, 0.0f, 0.51f),
//		glm::vec3(0.0f, 0.0f, 0.7f),
//		glm::vec3(-0.3f, 0.0f, -2.3f),
//		glm::vec3(0.5f, 0.0f, -0.6f)
//	};
//
//	// 创建一个帧缓冲对象并绑定它
//	unsigned int framebuffer;
//	glGenFramebuffers(1, &framebuffer);
//	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
//
//	// 创建一个颜色附件并将它附加到帧缓冲上
//	// 生成纹理
//	unsigned int texColorBuffer;
//	glGenTextures(1, &texColorBuffer);
//	glBindTexture(GL_TEXTURE_2D, texColorBuffer);
//	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 800, 600, 0, GL_RGB, GL_UNSIGNED_BYTE, NULL);
//	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//	glBindTexture(GL_TEXTURE_2D, 0);
//
//	// 将颜色附加附加到当前绑定的帧缓冲上
//	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texColorBuffer, 0);
//
//	// 创建渲染缓冲对象
//	unsigned int rbo;
//	glGenRenderbuffers(1, &rbo);
//	glBindRenderbuffer(GL_RENDERBUFFER, rbo);
//	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8, 800, 600);
//	glBindRenderbuffer(GL_RENDERBUFFER, 0);
//
//	// 将渲染缓冲对象附加到帧缓冲的深度和模板附件上
//	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_STENCIL_ATTACHMENT, GL_RENDERBUFFER, rbo);
//
//	// 检查帧缓冲是否完整
//	if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
//	{
//		cout << "ERROR:: FRAMEBUFFER :: framebuffer is not complete！ " << std::endl;
//	}
//
//	glBindFramebuffer(GL_FRAMEBUFFER, 0);
//
//	vector<string>faces{
//		"./skybox/right.jpg",
//		"./skybox/left.jpg",
//		"./skybox/top.jpg",
//		"./skybox/bottom.jpg",
//		"./skybox/front.jpg",
//		"./skybox/back.jpg"
//	};
//
//	unsigned int cubemapTexture = loadCubemap(faces);
//		
//	// 每个实例的xy偏移量
//	glm::vec2 translations[100];
//	int index = 0;
//	float offset = 0.1f;
//	for (int y = -10; y < 10; y += 2)
//	{
//		for (int x = -10; x < 10; x += 2)
//		{
//			glm::vec2 translation;
//			translation.x = (float)x / 10.0f + offset;
//			translation.y = (float)y / 10.0f + offset;
//			translations[index++] = translation;
//		}
//	}
//
//	// 创建实例数组顶点属性缓冲区对象
//	unsigned int instanceVBO;
//	glGenBuffers(1, &instanceVBO);
//	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
//	glBufferData(GL_ARRAY_BUFFER, sizeof(glm::vec2) * 100, &translations[0], GL_STATIC_DRAW);
//	glBindBuffer(GL_ARRAY_BUFFER, 0);
//
//	// 
//	glEnableVertexAttribArray(2);
//	glBindBuffer(GL_ARRAY_BUFFER, instanceVBO);
//	glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), (void*)0);
//	glBindBuffer(GL_ARRAY_BUFFER, 0);
//	glVertexAttribDivisor(2, 1);
//
//
//
//
//	//渲染循环
//	while (!glfwWindowShouldClose(window))
//	{
//		float currentFrame = glfwGetTime();
//		deltaTime = currentFrame - lastTime;
//		lastTime = currentFrame;
//
//		processInput(window);
//
//		ImGui_ImplOpenGL3_NewFrame();
//		ImGui_ImplGlfw_NewFrame();
//		ImGui::NewFrame();
//
//		// 排序
//		map<float, glm::vec3> sorted;
//		for (unsigned int i = 0; i < windows.size(); i++)
//		{
//			float distance = glm::length(camera.Position - windows[i]);
//			sorted[distance] = windows[i];
//		}
//
//		// 绑定帧缓冲
//		glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
//
//		// 检测是否需要退出窗口
//		glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
//		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//		glEnable(GL_DEPTH_TEST);
//
//		
//		ImGui::Begin("view value");
//		ImGui::Text("Average %.3f ms/frame (%.1f FPS)", 1000.0f / ImGui::GetIO().Framerate, ImGui::GetIO().Framerate);
//		ImGui::End();
//
//		glCullFace(GL_FRONT);
//
//		instanceShader.use();
//		glBindVertexArray(quadVAO);
//		glDrawArraysInstanced(GL_TRIANGLES, 0, 6, 100);
//		glBindVertexArray(0);
//
//
//		glDepthFunc(GL_LEQUAL);
//		glDisable(GL_CULL_FACE);
//
//		skyboxShader.use();
//		glm::mat4 view = glm::mat4(glm::mat3(camera.GetViewMatrix()));
//		glm::mat4 projection = glm::perspective(glm::radians(camera.Zoom), (float)SCREEN_WIDTH / (float)SCREEN_HEIGHT, 0.1f, 100.0f);
//		skyboxShader.setMat4("view", view);
//		skyboxShader.setMat4("projection", projection);
//
//		glBindVertexArray(skyboxVAO);
//		glActiveTexture(GL_TEXTURE0);
//		glBindTexture(GL_TEXTURE_CUBE_MAP, cubemapTexture);
//		glDrawArrays(GL_TRIANGLES, 0, 36);
//		glBindVertexArray(0);
//		glDepthFunc(GL_LESS);
//
//		glBindFramebuffer(GL_FRAMEBUFFER, 0);
//		glDisable(GL_DEPTH_TEST);
//
//		glClearColor(1.0, 1.0, 1.0, 1.0);
//		glClear(GL_COLOR_BUFFER_BIT);
//
//		screenShader.use();
//		screenShader.setFloat("offset", 1 / 300.0);
//
//		glBindVertexArray(screenVAO);
//		glBindTexture(GL_TEXTURE_2D, texColorBuffer);
//		glDrawArrays(GL_TRIANGLES, 0, 6);
//
//
//		// Rendering
//		ImGui::Render();
//		int display_w, display_h;
//		glfwGetFramebufferSize(window, &display_w, &display_h);
//		ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
//
//
//		// 交换颜色缓冲区
//		glfwSwapBuffers(window);
//
//		// 检查是否出发相关事件
//		glfwPollEvents();
//	}
//
//	glDeleteVertexArrays(1, &screenVAO);
//	glDeleteVertexArrays(1, &skyboxVAO);
//	glDeleteVertexArrays(1, &quadVAO);
//
//
//	glDeleteBuffers(1, &screenVBO);
//	glDeleteBuffers(1, &skyboxVBO);
//	glDeleteBuffers(1, &quadVBO);
//
//	// 删除/释放资源
//	glfwTerminate();
//	return 0;
//}
//void scroll_callback(GLFWwindow* window, double xoffset, double yoffset)
//{
//	camera.ProcessMouseScroll(yoffset);
//}
//
//void mouse_callback(GLFWwindow* window, double xpos, double ypos)
//{
//	if (firstMouse)
//	{
//		lastX = xpos;
//		lastY = ypos;
//		firstMouse = false;
//	}
//
//	float xoffset = xpos - lastX;
//	float yoffset = lastY - ypos;
//
//	lastX = xpos;
//	lastY = ypos;
//
//	camera.ProcessMouseMovement(xoffset, yoffset);
//}
//
//// 窗口大小变换监听
//void framebuffer_size_callback(GLFWwindow *window, int width, int height)
//{
//	glViewport(0, 0, width, height);
//}
//
//// 输入监听
//void processInput(GLFWwindow *window)
//
//{
//	float cameraSpeed = deltaTime * 2.5f;
//
//	if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
//	{
//		glfwSetWindowShouldClose(window, true);
//	}
//
//}
//
//unsigned int loadTexture(char const * path)
//{
//	unsigned int textureID;
//	glGenTextures(1, &textureID);
//
//	//stbi_set_flip_vertically_on_load(true);
//	int width, height, nrComponents;
//	unsigned char *data = stbi_load(path, &width, &height, &nrComponents, 0);
//	if (data)
//	{
//		GLenum format;
//		if (nrComponents == 1)
//			format = GL_RED;
//		else if (nrComponents == 3)
//			format = GL_RGB;
//		else if (nrComponents == 4)
//			format = GL_RGBA;
//
//		glBindTexture(GL_TEXTURE_2D, textureID);
//		glTexImage2D(GL_TEXTURE_2D, 0, format, width, height, 0, format, GL_UNSIGNED_BYTE, data);
//		glGenerateMipmap(GL_TEXTURE_2D);
//
//		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
//		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
//		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
//		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//
//		stbi_image_free(data);
//	}
//	else
//	{
//		std::cout << "Texture failed to load at path: " << path << std::endl;
//		stbi_image_free(data);
//	}
//
//	return textureID;
//}
//
//unsigned int loadCubemap(vector<std::string> faces)
//{
//	unsigned int textureID;
//	glGenTextures(1, &textureID);
//	glBindTexture(GL_TEXTURE_CUBE_MAP, textureID);
//
//	int width, height, nrChannels;
//	for (unsigned int i = 0; i < faces.size(); i++)
//	{
//		unsigned char *data = stbi_load(faces[i].c_str(), &width, &height, &nrChannels, 0);
//		if (data)
//		{
//			glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X + i,
//				0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, data
//			);
//			stbi_image_free(data);
//		}
//		else
//		{
//			std::cout << "Cubemap texture failed to load at path: " << faces[i] << std::endl;
//			stbi_image_free(data);
//		}
//	}
//	glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//	glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//	glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//	glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//	glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_R, GL_CLAMP_TO_EDGE);
//
//	return textureID;
//}