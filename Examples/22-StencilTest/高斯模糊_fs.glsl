#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D texture1;

void main()
{
    vec4 color = vec4(0.0);
    int coreSize=3;
    int halfSize=coreSize/2;
    float texelOffset = 1/100.0;
    float kernel[9];
    kernel[6] = 1; kernel[7] = 2; kernel[8] = 1;
    kernel[3] = 2; kernel[4] = 4; kernel[5] = 2;
    kernel[0] = 1; kernel[1] = 2; kernel[2] = 1;
    int index = 0;
    for(int y=0;y<coreSize;y++)
    {
        for(int x = 0;x<coreSize;x++)
        {
            vec4 currentColor = texture(texture1,TexCoords+vec2((-1+x)*texelOffset,(-1+y)*texelOffset));
            color += currentColor*kernel[index];
            index++;
        }
    }
    color/=16.0;
    FragColor=color;
}