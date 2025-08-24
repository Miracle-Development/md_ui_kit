#version 300 es
precision highp float;

uniform sampler2D uTexture;
uniform vec2 uResolution;
uniform float uRadius;

out vec4 fragColor;

float gaussian(float x, float sigma) {
  return exp(-(x * x) / (2.0 * sigma * sigma)) / (2.0 * 3.14159265 * sigma * sigma);
}

void main() {
  vec2 uv = gl_FragCoord.xy / uResolution;
  vec2 texelSize = 1.0 / uResolution;

  vec4 result = vec4(0.0);
  float sigma = uRadius / 2.0;
  float sum = 0.0;

  for (int x = -10; x <= 10; x++) {
    for (int y = -10; y <= 10; y++) {
      vec2 offset = vec2(float(x), float(y)) * texelSize * uRadius * 0.1;
      float weight = gaussian(length(offset), sigma);
      result += texture(uTexture, uv + offset) * weight;
      sum += weight;
    }
  }

  fragColor = result / sum;
}
