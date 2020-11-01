#version 330 core
out vec4 FragColor;

// 光照材质结构
struct Material {
	vec3 ambient; // 环境光
	vec3 diffuse; // 漫反射光
	vec3 specular; // 镜面光照
	float shininess;// 高光强度
};

// 光影响强度结构
struct Light {
	vec3 position;

	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
};

uniform vec3 lightColor;
uniform vec3 objectColor;

uniform vec3 viewPos; // 相机位置

in vec3 Normal;
in vec3 FragPos;

uniform Material material;
uniform Light light;


void main(){

	// 环境光
	vec3 ambient = light.ambient * material.ambient;

	// 漫反射
	vec3 norm = normalize(Normal);
	vec3 lightDir = normalize(light.position- FragPos);
	float diff = max(dot(norm, lightDir), 0.0);
	vec3 diffuse = light.diffuse * (diff * material.diffuse);

	// 镜面高光
	vec3 viewDir = normalize(viewPos - FragPos);
	vec3 reflectDir  = reflect(-lightDir, norm);
	float spec =  pow(max(dot(viewDir, reflectDir),0.0),material.shininess);
	vec3 specular =  light.specular * (spec * material.specular); // 高光颜色值

	vec3 result = ambient + diffuse + specular;

    FragColor = vec4(result, 1.0f);
}