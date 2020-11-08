#version 330 core
out vec4 FragColor;

in VS_OUT{
    vec3 FragPos;
    vec2 TexCoords;
    vec3 TangentLightPos;
    vec3 TangentViewPos;
    vec3 TangentFragPos;
} fs_in;

uniform sampler2D iDiffuseMap;
uniform sampler2D iNormalMap;
uniform sampler2D iHeightMap;

uniform bool iNormalMapping;
uniform float iHeightScale;

vec2 ParallaxMapping(vec2 texCoords, vec3 viewDir)
{
	float height = texture(iHeightMap, texCoords).r;
	//vec2 p = texCoords - viewDir.xy / viewDir.z * (height * iHeightScale);
	//return texCoords - p;
	return texCoords - viewDir.xy * (height * iHeightScale);
}

vec2 ParallaxMappingLayer(vec2 texCoords, vec3 viewDir)
{
	// 深度层数
	//const float numLayers = 32.0;

	// 动态计算样本数量
	const float minLayers = 8;
	const float maxLayers = 32;

	float numLayers = mix(maxLayers, minLayers, abs(dot(vec3(0.0, 0.0, 1.0), viewDir)));

	// 计算每一层的大小
	float layerDepth = 1.0 / numLayers;

	// 当前的深度
	float currentLayerDepth = 0.0;
		
	// 每层移动纹理坐标的量 从p方向开始
	vec2 p = viewDir.xy * iHeightScale;
	vec2 deltaTexCoords = p / numLayers;

	// 获取初始值
	vec2 currentTexCoords = texCoords;
	float currentDepthMapValue = texture(iHeightMap, currentTexCoords).r;

	while(currentLayerDepth < currentDepthMapValue)
	{
		// 沿p方向移动纹理坐标
		currentTexCoords -= deltaTexCoords;

		// 获取当前纹理坐标处的采样值
		currentDepthMapValue = texture(iHeightMap, currentTexCoords).r;

		// 获取下一层的深度
		currentLayerDepth += layerDepth;
	}


	// 屏蔽陡峭视察映射的问题

	// 在碰撞前获取纹理坐标（反向操作）
	vec2 prevTexCoords = currentTexCoords + deltaTexCoords;

	// 为线性插值获取碰撞前后的深度
	float afterDepth  = currentDepthMapValue - currentLayerDepth;
	float beforeDepth = texture(iHeightMap, prevTexCoords).r - currentLayerDepth + layerDepth;

	// 纹理坐标插值
	float weight = afterDepth / (afterDepth - beforeDepth);
	vec2 finalTexCoords = prevTexCoords * weight + currentTexCoords * (1.0 - weight);

	return finalTexCoords;

	// return currentTexCoords;

}


void main(){

	vec3 viewDir = normalize(fs_in.TangentViewPos - fs_in.TangentFragPos);
	vec2 texCoords = fs_in.TexCoords;
	
	//texCoords = ParallaxMapping(fs_in.TexCoords, viewDir);

	texCoords = ParallaxMappingLayer(fs_in.TexCoords,  viewDir);
	if(texCoords.x > 1.0 || texCoords.y > 1.0 || texCoords.x < 0.0 || texCoords.y < 0.0)
		discard;


    vec3 normal = texture(iNormalMap, texCoords).rgb;
    // vector to [-1, 1] range
    normal = normalize(normal * 2.0 - 1.0);

    // diffuse color
    vec3 color = texture(iDiffuseMap, texCoords).rgb;

    // ambient
    vec3 ambient = 0.1* color;

    // diffuse
    vec3 lightDir = normalize(fs_in.TangentLightPos - fs_in.TangentFragPos);
    float diff = max(dot(lightDir, normal), 0.0);
    vec3 diffuse = diff * color;

    // specular
    // vec3 viewDir = normalize(fs_in.TangentViewPos - fs_in.TangentFragPos);
    vec3 halfwayDir = normalize(lightDir + viewDir);
    float spec = pow(max(dot(normal, halfwayDir), 0.0), 32.0); 
    vec3 specular = vec3(0.2) * spec;

    FragColor = vec4(ambient + diffuse + specular, 1.0f);
}

