#version 330 core
out vec4 FragColor;

flat in ivec2 TexCoords;

uniform sampler2D screenTexture;
uniform sampler2DMS screenTextureMS;

uniform float offset;

void main()
{ 
	ivec2 texturePosition = ivec2(gl_FragCoord.x, gl_FragCoord.y);
	vec4 colorSample0 = texelFetch(screenTextureMS, texturePosition, 0);
	vec4 colorSample1 = texelFetch(screenTextureMS, texturePosition, 1);
	vec4 colorSample2 = texelFetch(screenTextureMS, texturePosition, 2);
	vec4 colorSample3 = texelFetch(screenTextureMS, texturePosition, 3);

	vec4 antialiased = (colorSample0 + colorSample1 + colorSample2 + colorSample3) / 4.0f;

	FragColor = antialiased;
}