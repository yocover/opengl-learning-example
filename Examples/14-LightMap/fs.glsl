#version 330 core
out vec4 FragColor;

// 光照材质结构
struct Material {
	sampler2D  diffuse; // 漫反射
	sampler2D specular; // 镜面光照
	sampler2D creativesam;
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
in vec2 TexCoords;

uniform Material material;
uniform Light light;


void main(){

	// 环境光
	vec3 ambient = light.ambient * vec3(texture(material.diffuse,TexCoords ));

	// 漫反射
	vec3 norm = normalize(Normal);
	vec3 lightDir = normalize(light.position- FragPos);
	float diff = max(dot(norm, lightDir), 0.0);
	vec3 diffuse = light.diffuse * diff * vec3(texture(material.diffuse, TexCoords));

	// 镜面高光
	vec3 viewDir = normalize(viewPos - FragPos);
	vec3 reflectDir  = reflect(-lightDir, norm);
	float spec =  pow(max(dot(viewDir, reflectDir),0.0),material.shininess);
	vec3 specular =  light.specular * spec * vec3(texture(material.specular, TexCoords)); // 高光颜色值

	vec3 creativesamColor = vec3(texture(material.creativesam, TexCoords));

	vec3 result = ambient + diffuse + specular + creativesamColor;

    FragColor = vec4(result, 1.0f);
}