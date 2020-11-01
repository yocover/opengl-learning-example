#version 330 core
out vec4 FragColor;

in VS_OUT
{
	vec2 TexCoords;
	vec3 FragPos;
} fs_in;

uniform sampler2D diffauseMap;
uniform sampler2D normalMap;
uniform vec3 lightPos;
uniform vec3 viewPos;

void main()
{
	vec3 color = texture(diffauseMap, fs_in.TexCoords).rgb;
	vec3 normal = texture(normalMap, fs_in.TexCoords).rgb;

	// 将法向量重新映射到[-1, 1]
	normal = normalize(normal * 2.0 - 1.0);

	// ambient
	vec3 ambient = 0.1 * color;

	// diffuse
	vec3 lightDir = normalize(lightPos - fs_in.FragPos);
	float diff = max(dot(normal, lightDir), 0.0);
	vec3 diffuse = diff * color;

	// specular
	vec3 viewDir = normalize(viewPos - fs_in.FragPos);
	vec3 halfwayDir = normalize(lightDir + viewDir);
	float spec = pow(max(dot(normal, viewDir), 0.0), 32.0);
	vec3 specular = spec * color;

	vec3 resultColor = ambient + diffuse + specular;

	FragColor = vec4(resultColor, 1.0);
}