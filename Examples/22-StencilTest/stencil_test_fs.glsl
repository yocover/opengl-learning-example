#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D texture1;

void main()
{
	vec4 color = vec4(0.0);
	int seg = 5;
	int i = -seg;
	int j = 0;
	float f = 0.0f;
	float dv = 2.0f/512.0f;
	float tot = 0.0f;
	for(; i <= seg; ++i)
	{
		for(j = -seg; j <= seg; ++j)
		{
			f = (1.1 - sqrt(i*i + j*j)/8.0);
			f *= f;
			tot += f;
			color += texture( texture1, vec2(TexCoords.x + j * dv, TexCoords.y + i * dv) ).rgba * f;
		}
	}
	color /= tot;
	FragColor = color;
}