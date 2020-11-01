#version 330 core
out vec4 FragColor;
in vec4 ourColor;

in vec2 TexCoord;
uniform sampler2D ourTexture1;
uniform sampler2D ourTexture2;

uniform float factor;

void main(){
    FragColor = mix(texture(ourTexture1, TexCoord), texture(ourTexture2, TexCoord), factor) * ourColor;
}