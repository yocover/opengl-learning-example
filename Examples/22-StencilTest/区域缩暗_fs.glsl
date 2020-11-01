#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D texture1;

void main()
{
    vec4 maxValue = vec4(0.0);
    int coreSize=10;
    int halfSize=coreSize/2;
    float texelOffset = 1/100.0;
    for(int y=0;y<coreSize;y++)
    {
        for(int x = 0;x<coreSize;x++)
        {
            vec4 currentAlpha = texture(texture1,TexCoords+vec2((-halfSize+x)*texelOffset,(-halfSize+y)*texelOffset));
            maxValue = max(maxValue,currentAlpha);
        }
    }
    FragColor=maxValue;
}