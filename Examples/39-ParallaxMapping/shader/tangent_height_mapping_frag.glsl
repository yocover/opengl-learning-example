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
	vec2 p = texCoords - viewDir.xy / viewDir.z * (height * iHeightScale);
	return texCoords - p;
}

void main(){

	vec3 viewDir = normalize(fs_in.TangentViewPos - fs_in.TangentFragPos);
	vec2 texCoords = fs_in.TexCoords;
	
	texCoords = ParallaxMapping(fs_in.TexCoords, viewDir);


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
    vec3 specular = vec3(0.3) * spec;

    FragColor = vec4(ambient + diffuse + specular, 1.0f);
}

