#version 330 core
out vec4 FragColor;

in VS_OUT{
	vec3 FragPos;
	vec3 Normal;
	vec2 TexCoords;
}fs_in;

uniform sampler2D diffuseTexture;
uniform samplerCube shadowMap;

uniform vec3 lightPos;
uniform vec3 viewPos;

uniform float far_plane;

float ShadowCalculation(vec3 fragPos)
{
	// 获取光空间位置和片元位置之间的向量
	vec3 fragToLight = fragPos - lightPos;

	// 使用方向向量对立方体贴图进行采样，获取光源和它最接近的可见片元之间标准化深度值
	float closestDepth = texture(shadowMap, fragToLight).r;

	// 将其转回0到far_plane范围
	closestDepth *= far_plane;

	// 获取当前片元和光源之间的深度值，返回和closestDepth在一个范围内的深度值
	float currentDepth = length(fragToLight);

	// 阴影偏移
	// float bias = 0.05;
	// float shadow = currentDepth - bias > closestDepth ? 1.0 : 0.0;

	//--------------------------------------------------------------------------
	vec3 sampleOffsetDirections[20] = vec3[]
	(
		vec3( 1,  1,  1), vec3( 1, -1,  1), vec3(-1, -1,  1), vec3(-1,  1,  1), 
		vec3( 1,  1, -1), vec3( 1, -1, -1), vec3(-1, -1, -1), vec3(-1,  1, -1),
		vec3( 1,  1,  0), vec3( 1, -1,  0), vec3(-1, -1,  0), vec3(-1,  1,  0),
		vec3( 1,  0,  1), vec3(-1,  0,  1), vec3( 1,  0, -1), vec3(-1,  0, -1),
		vec3( 0,  1,  1), vec3( 0, -1,  1), vec3( 0, -1, -1), vec3( 0,  1, -1)
	);

	float shadow = 0.0;
	float bias = 0.15;
	int samples = 20;
	float viewDistance = length(viewPos - fragPos);
	float diskRadius = (1.0 + (viewDistance / far_plane)) / 25.0;
	for(int i = 0; i < samples; ++i)
	{
		float closestDepth = texture(shadowMap, fragToLight + sampleOffsetDirections[i] * diskRadius).r;
		closestDepth *= far_plane;   // Undo mapping [0;1]
		if(currentDepth - bias > closestDepth)
			shadow += 1.0;
	}
	shadow /= float(samples);
	//--------------------------------------------------------------------------


	//--------------------------------------------------------------------------
	// float shadow = 0.0;
	// float bias = 0.05; 
	// float samples = 4.0;
	// float offset = 0.1;
	// for(float x = -offset; x < offset; x += offset / (samples * 0.5))
	// {
	// 	for(float y = -offset; y < offset; y += offset / (samples * 0.5))
	// 	{
	// 		for(float z = -offset; z < offset; z += offset / (samples * 0.5))
	// 		{
	// 			float closestDepth = texture(shadowMap, fragToLight + vec3(x, y, z)).r; 
	// 			closestDepth *= far_plane;   // Undo mapping [0;1]
	// 			if(currentDepth - bias > closestDepth)
	// 				shadow += 1.0;
	// 		}
	// 	}
	// }
	// shadow /= (samples * samples * samples);
	//--------------------------------------------------------------------------
	

	return shadow;
}

void main()
{
	// 进行Blinn Phong光照计算
	vec3 color = texture(diffuseTexture, fs_in.TexCoords).rgb;
	vec3 normal = normalize(fs_in.Normal);
	vec3 lightColor = vec3(0.3);
	// ambient
	vec3 ambient = 0.1 * color;
	
	// diffuse
	vec3 lightDir = normalize(lightPos - fs_in.FragPos);
	float diff = max(dot(lightDir, normal), 0.0);
	vec3 diffuse = diff * lightColor;
	
	// specular
	vec3 viewDir = normalize(viewPos - fs_in.FragPos);
	vec3 reflectDir = reflect(-lightDir, normal);
	float spec = 0.0;
	vec3 halfwayDir = normalize(lightDir + viewDir);
	spec = pow(max(dot(normal, halfwayDir), 0.0), 64.0);
	vec3 specular = spec * lightColor;

	// 计算阴影
	float shadow = ShadowCalculation(fs_in.FragPos);
	vec3 lighting = (ambient + (1.0 - shadow) * (diffuse + specular)) * color;
	FragColor = vec4(lighting, 1.0);
}