#version 300 es
precision highp float;

#include <flutter/runtime_effect.glsl>

// uResCenter:
//  x = resLogical_w (logical px), y = resLogical_h (logical px),
//  z = centerX_logical (px), w = centerY_logical (px)
uniform vec4 uResCenter; // 0..3

// uParams:
//  x = radius_logical (px), y = blur_logical (px), z = ditherBase, w = ditherMax
uniform vec4 uParams;    // 4..7

// uColor: r,g,b,a (0..1)
uniform vec4 uColor;     // 8..11

// device pixel ratio (physical / logical)
uniform float uDpr;      // 12

out vec4 fragColor;

float smootherstep(float e0, float e1, float x) {
  float t = clamp((x - e0) / (e1 - e0 + 1e-9), 0.0, 1.0);
  return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

float rand01(vec2 co) {
  return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float bayer4(vec2 pos) {
  // pos ожидается целочисленные координаты пикселя (можно передать floor(fragPhysical))
  int x = int(mod(pos.x, 4.0));
  int y = int(mod(pos.y, 4.0));
  int idx = x + y * 4;
  int m0 = 0;  int m1 = 8;  int m2 = 2;  int m3 = 10;
  int m4 = 12; int m5 = 4;  int m6 = 14; int m7 = 6;
  int m8 = 3;  int m9 = 11; int m10 = 1; int m11 = 9;
  int m12 = 15;int m13 = 7; int m14 = 13; int m15 = 5;
  int val = 0;
  if (idx==0) val = m0;
  else if (idx==1) val = m1;
  else if (idx==2) val = m2;
  else if (idx==3) val = m3;
  else if (idx==4) val = m4;
  else if (idx==5) val = m5;
  else if (idx==6) val = m6;
  else if (idx==7) val = m7;
  else if (idx==8) val = m8;
  else if (idx==9) val = m9;
  else if (idx==10) val = m10;
  else if (idx==11) val = m11;
  else if (idx==12) val = m12;
  else if (idx==13) val = m13;
  else if (idx==14) val = m14;
  else val = m15;
  float jitter = (rand01(pos) - 0.5) * 0.4; // small jitter
  return (float(val) + jitter) / 16.0;
}

float alphaProfileFor(vec2 fragLogical, vec2 centerLogical, float radiusLogical, float blurLogical) {
  float dist = distance(fragLogical, centerLogical);
  float edge0 = radiusLogical;
  float edge1 = radiusLogical + max(blurLogical, 0.0);
  return 1.0 - smootherstep(edge0, edge1, dist);
}

void main() {
  // fragRaw от движка (логические координаты)
  vec2 fragRaw = FlutterFragCoord().xy;

  // предполагаем, что uResCenter/uParams передаются в логических пикселях
  vec2 fragLogical = fragRaw;

  // физические пиксели (для dither/индексов и "1px" шагов)
  float safeDpr = max(uDpr, 1e-6);
  vec2 fragPhysical = fragLogical * safeDpr;

  vec2 resLogical = vec2(uResCenter.x, uResCenter.y);
  vec2 centerLogical = uResCenter.zw;
  float radiusLogical = uParams.x;
  float blurLogical = uParams.y;
  float uDitherBase = uParams.z;
  float uDitherMax = uParams.w;

  float uR = uColor.x;
  float uG = uColor.y;
  float uB = uColor.z;
  float uA = uColor.w;

  // alpha профиль — в логических пикселях (как хочет Flutter-код)
  float alpha = alphaProfileFor(fragLogical, centerLogical, radiusLogical, blurLogical);

  // быстрый отсев: если почти прозрачный — выходим
  if (alpha <= 0.0005) {
    fragColor = vec4(0.0);
    return;
  }

  // Для оценки градиента делаем шаг на 1 **физический** пиксель.
  // 1 physical px в логических координатах = 1.0 / uDpr
  vec2 onePhysInLogical = vec2(1.0 / safeDpr, 0.0);
  float alphaX = alphaProfileFor(fragLogical + vec2(1.0 / safeDpr, 0.0), centerLogical, radiusLogical, blurLogical);
  float alphaY = alphaProfileFor(fragLogical + vec2(0.0, 1.0 / safeDpr), centerLogical, radiusLogical, blurLogical);

  float gradAlphaX = abs(alpha - alphaX);
  float gradAlphaY = abs(alpha - alphaY);
  float grad = length(vec2(gradAlphaX, gradAlphaY)); // ~ change in alpha per physical px

  // адаптивная амплитуда: используем grad измеренный на физ.шаге, как и раньше
  float eps = 1e-4;
  float adapt = (0.02 / (grad + eps));
  float amp = clamp(uDitherBase * adapt, 0.0, uDitherMax);

  // Bayer+rand нужно привязать к физическому пикселю — используем целочисленную координату
  vec2 physPixel = floor(fragPhysical); // integer physical pixel coords
  float b = bayer4(physPixel);
  float r = rand01(physPixel * 1.37);

  float dither = (b - 0.5) * amp + (r - 0.5) * (amp * 0.35);

  // финальная альфа (premultiplied color ниже)
  float outA = clamp(uA * alpha + dither, 0.0, 1.0);

  vec3 color = vec3(uR, uG, uB) * outA; // premultiplied
  fragColor = vec4(color, outA);
}
