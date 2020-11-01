#version 330 core
out vec4 FragColor;
in vec4 ourColor;
in vec4 aPosCoord;

void main()
{
    FragColor = aPosCoord;
}