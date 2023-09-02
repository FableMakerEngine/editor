#version 300 es

#ifdef GL_ES
precision mediump float;
#else
#define mediump
#endif

uniform vec4 color;
uniform vec2 size;
uniform float thickness;
uniform float alpha;
uniform float scale;
uniform vec2 resolution;
uniform sampler2D tex0;

vec2 texSize;

in vec2 tcoord;
out vec4 outColor;

 // adapted from https://madebyevan.com/shaders/grid/
void main() {
  vec2 uv = tcoord;
  vec4 texColor = texture(tex0, uv);

  texSize = vec2(textureSize(tex0, 0));
  if (resolution != vec2(0.0)) {
    texSize = resolution;
  }

  vec2 gridUv = uv * (texSize / size);
  vec2 grid = abs(fract(gridUv - 0.5) - 0.5) / fwidth(gridUv);

  float line = (min(grid.x, grid.y) / thickness) / scale;
  vec4 lineColor = color * (1.0 - min(line, 1.0));

  outColor = (lineColor * alpha) + texColor;
}