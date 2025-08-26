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
  float jitter = (rand01(pos) - 0.5) * 0.4;
  return (float(val) + jitter) / 16.0;
}

float alphaProfileFor(vec2 fragLogical, vec2 centerLogical, float radiusLogical, float blurLogical) {
  float dist = distance(fragLogical, centerLogical);
  float edge0 = radiusLogical;
  float edge1 = radiusLogical + max(blurLogical, 0.0);
  return 1.0 - smootherstep(edge0, edge1, dist);
}

void main() {
  // raw coord от движка (может быть физическим или логическим)
  vec2 fragRaw = FlutterFragCoord().xy;

  // два варианта логических координат:
  //vec2 fragLogicalA = fragRaw / max(uDpr, 1e-6); // если fragRaw физические(px)
  vec2 fragLogicalB = fragRaw;                   // если fragRaw уже логические(px)

  // параметры в логических пикселях, переданные из Dart
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

  // считаем профиль alpha для обоих кандидатов
  //float alphaA = alphaProfileFor(fragLogicalA, centerLogical, radiusLogical, blurLogical);
  float alphaB = alphaProfileFor(fragLogicalB, centerLogical, radiusLogical, blurLogical);

  // градиенты (используются для адаптивного dithering). Берём градиент по варианту A и B и усредняем их — это нормально.
  //vec2 onePxA = vec2(1.0, 1.0); // шаг в логических пикселях — 1.0
  //float alphaAx = alphaProfileFor(fragLogicalA + vec2(1.0, 0.0), centerLogical, radiusLogical, blurLogical);
  //float alphaAy = alphaProfileFor(fragLogicalA + vec2(0.0, 1.0), centerLogical, radiusLogical, blurLogical);
  //float gradA = length(vec2(abs(alphaA - alphaAx), abs(alphaA - alphaAy)));

  float alphaBx = alphaProfileFor(fragLogicalB + vec2(1.0, 0.0), centerLogical, radiusLogical, blurLogical);
  float alphaBy = alphaProfileFor(fragLogicalB + vec2(0.0, 1.0), centerLogical, radiusLogical, blurLogical);
  float gradB = length(vec2(abs(alphaB - alphaBx), abs(alphaB - alphaBy)));

  //float grad = max(gradA, gradB);

  float eps = 1e-4;
  float adapt = (0.02 / (gradB + eps)); // grad
  float amp = clamp(uDitherBase * adapt, 0.0, uDitherMax);

  // dither: используем fragRaw чтобы быть привязанным к пиксельной сетке
  float b = bayer4(fragRaw);
  float r = rand01(fragRaw * 1.37);
  float dither = (b - 0.5) * amp + (r - 0.5) * (amp * 0.35);

  // финальная альфа — берём максимум (выбирается правильный интерпретатор координат)
  //float outA_A = clamp(uA * alphaA + dither, 0.0, 1.0);
  float outA_B = clamp(uA * alphaB + dither, 0.0, 1.0);
  //float outA = max(outA_A, outA_B);

  vec3 color = vec3(uR, uG, uB) * outA_B; // outA
  fragColor = vec4(color, outA_B); // outA
}
