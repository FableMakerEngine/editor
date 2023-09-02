#version 300 es

in vec3 vertexPosition;
in vec2 vertexTCoord;

out vec2 tcoord;
out vec3 vPosition;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;

void main(void) {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(vertexPosition, 1.0);
    tcoord = vertexTCoord;
    vPosition = vertexPosition;
    gl_PointSize = 1.0;
}