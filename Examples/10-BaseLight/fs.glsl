#version 330 core
out vec4 FragColor;

uniform vec3 lightColor;
uniform vec3 objectColor;

uniform vec3 viewPos; // 相机位置
uniform vec3 lightPos; // 光源的位置




in vec3 Normal;
in vec3 FragPos;

void main(){

	// 环境光强度 
	float ambientStrength = 0.1;
	// 计算环境光
	vec3 ambient = ambientStrength * lightColor;

	// 计算漫反射
	vec3 norm = normalize(Normal);
	vec3 lightDir = normalize(lightPos- FragPos);
	float diff = max(dot(norm, lightDir), 0.0);
	vec3 diffuse = diff * lightColor;

	// 计算镜面高光
	float specularStrength = 0.5; // 高光强度
	vec3 viewDir = normalize(viewPos - FragPos);
	vec3 reflectDir  = reflect(-lightDir, norm);
	float spec =  pow(max(dot(viewDir, reflectDir),0.0),32);
	vec3 specular = specularStrength * spec * lightColor; // 高光颜色值

	vec3 result = (ambient + diffuse + specular) * objectColor;

    FragColor = vec4(result, 1.0f);
}