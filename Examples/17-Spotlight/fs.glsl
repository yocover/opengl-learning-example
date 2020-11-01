#version 330 core
out vec4 FragColor;

// 光照材质结构
struct Material {
	sampler2D  diffuse; // 漫反射
	sampler2D specular; // 镜面光照
	float shininess;// 高光强度
};

// 光影响强度结构
struct Light {
	vec3  position; // 聚光位置
	vec3  direction;// 聚光的方向
	float cutOff; // 切光角
	float outerCutOff; // 外切光角

	vec3 ambient;
	vec3 diffuse;
	vec3 specular;

	// 光的衰减参数
	float constant; // 常数项 1.0
	float linear; // 一次项
	float quadratic;// 二次项
};

uniform vec3 lightColor;
uniform vec3 objectColor;

uniform vec3 viewPos; // 相机位置

in vec3 Normal;
in vec3 FragPos;
in vec2 TexCoords;

uniform Material material;
uniform Light light;


void main() {

	vec3 lightDir = normalize(light.position - FragPos);
	float theta = dot(lightDir, normalize(-light.direction));
	float epsilon = light.cutOff - light.outerCutOff;
	float intensity = clamp((theta - light.outerCutOff) / epsilon, 0.0, 1.0);

	// 执行光照计算
	float distance = length(light.position - FragPos); // 距离光源的距离
	float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * (distance * distance));

	// 环境光
	vec3 ambient = light.ambient * vec3(texture(material.diffuse, TexCoords));

	// 漫反射
	vec3 norm = normalize(Normal);
	float diff = max(dot(norm, lightDir), 0.0);
	vec3 diffuse = light.diffuse * diff * vec3(texture(material.diffuse, TexCoords));

	// 镜面高光
	vec3 viewDir = normalize(viewPos - FragPos);
	vec3 reflectDir = reflect(-lightDir, norm);
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
	vec3 specular = light.specular * spec * vec3(texture(material.specular, TexCoords)); // 高光颜色值

	ambient *= attenuation;
	diffuse *= intensity;
	specular *= intensity;

	vec3 result = ambient + diffuse + specular;

	FragColor = vec4(result, 1.0f);
}