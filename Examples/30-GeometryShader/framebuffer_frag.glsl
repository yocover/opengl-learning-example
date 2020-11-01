#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D screenTexture;
uniform float offset;

void main()
{ 
	// 1. 反向
    // FragColor =vec4(vec3(1.0 -  texture(screenTexture, TexCoords) * 2.0), 1.0 );

	// 2. 灰度
	// FragColor = texture(screenTexture, TexCoords);
	// float average  = (FragColor.r +FragColor.g + FragColor.b ) / 3.0;
	// float average  = FragColor.r * 0.2126 +FragColor.g *  0.7152 + FragColor.b *  0.0722;
	// FragColor = vec4(vec3(average), 1.0);
	
	// 3. 核效果
	vec2 offset[9] = vec2[](
		vec2(-offset,  offset), // 左上
		vec2( 0.0f,    offset), // 正上
		vec2( offset,  offset), // 右上
        vec2(-offset,  0.0f),   // 左
        vec2( 0.0f,    0.0f),   // 中
        vec2( offset,  0.0f),   // 右
        vec2(-offset, -offset), // 左下
        vec2( 0.0f,   -offset), // 正下
        vec2( offset, -offset)  // 右下
	);

	float kernel[9] = float[](
		1, 2, 1,
		2, 4, 2,
		1, 2, 1
	);

	vec3 sampleTex[9];
	for(int i = 0; i < 9; i++){
		sampleTex[i] = vec3(texture(screenTexture, TexCoords.st + offset[i]));
	}

	vec3 col = vec3(0.0);
	
	for(int i = 0; i < 9; i++){
		col += kernel[i] * sampleTex[i];
	}

	FragColor = texture(screenTexture, TexCoords);
}