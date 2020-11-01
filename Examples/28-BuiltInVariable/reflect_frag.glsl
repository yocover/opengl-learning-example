#version 420 core
out vec4 FragColor;
layout (depth_greater) out float gl_FragDepth;

in vec3 Normal;
in vec3 Position;

in VS_OUT
{
	vec3 Normal;
	vec3 Position;
} fs_in;

uniform vec3 cameraPos;
uniform samplerCube skybox; 

void main()
{
	
	// ’€…‰¬ 
	float ratio = 1.00 / 1.52;

	vec3 I = normalize(fs_in.Position - cameraPos);

	// ∑¥…‰
	// vec3 R = reflect(I, normalize(fs_in.Normal));

	// ’€…‰
	vec3 R = refract(I, normalize(fs_in.Normal), ratio);
	
	if(gl_FrontFacing){
		FragColor = vec4(texture(skybox, R).rgb, 1.0) * vec4(1.0, 0.0, 0.0 ,1.0);
	}else {
		FragColor = vec4(texture(skybox, R).rgb, 1.0) * vec4(0.0, 0.0, 1.0 ,1.0);
	}
	FragColor = vec4(texture(skybox, R).rgb, 1.0) * vec4(1.0, 0.0, 0.0 ,1.0);
}
