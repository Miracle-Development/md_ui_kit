#version 300 es
precision highp float;

#include <flutter/runtime_effect.glsl>

// uResCenter:
//  x = resLogical_w (logical px), y = resLogical_h (logical px),
//  z = centerX_logical (px), w = centerY_logical (px)
uniform vec4 uResCenter; // indices 0..3

// uParams:
//  x = radius_logical (px), y = blur_logical (px), z = ditherBase, w = ditherMax
uniform vec4 uParams;    // indices 4..7

// uColor: r,g,b,a (0..1)
uniform vec4 uColor;     // indices 8..11

// device pixel ratio (physical / logical)
uniform float uDpr;      // index 12

// флаг: 1.0 если FlutterFragCoord возвращает логические пиксели (например Web),
//       0.0 если возвращает физические пиксели (обычно desktop/mobile).
uniform float uFragCoordIsLogical; // index 13

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

void main() {
  // raw frag coord (может быть phys или logical, в зависимости от backend)
  vec2 fragRaw = FlutterFragCoord().xy;

  // приводим к логическим пикселям: если fragRaw физический — делим на dpr, иначе оставляем
  vec2 fragLogical = mix(fragRaw / max(uDpr, 1e-6), fragRaw, clamp(uFragCoordIsLogical, 0.0, 1.0));

  // затем работаем в логических пикселях
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

  // расстояние в логических пикселях (одинаковая шкала по X и Y => круг)
  float dist = distance(fragLogical, centerLogical);

  float edge0 = radiusLogical;
  float edge1 = radiusLogical + max(blurLogical, 0.0);
  float alphaProfile = 1.0 - smootherstep(edge0, edge1, dist);

  if (alphaProfile <= 0.0005) {
    fragColor = vec4(0.0);
    return;
  }

  // градиент по соседним логическим пикселям (шаг 1 logical px)
  float distX = distance(fragLogical + vec2(1.0, 0.0), centerLogical);
  float alphaX = 1.0 - smootherstep(edge0, edge1, distX);
  float distY = distance(fragLogical + vec2(0.0, 1.0), centerLogical);
  float alphaY = 1.0 - smootherstep(edge0, edge1, distY);

  float gradAlphaX = abs(alphaProfile - alphaX);
  float gradAlphaY = abs(alphaProfile - alphaY);
  float grad = length(vec2(gradAlphaX, gradAlphaY));
  float eps = 1e-4;
  float adapt = (0.02 / (grad + eps));
  float amp = clamp(uDitherBase * adapt, 0.0, uDitherMax);

  // для бетер/рандома используем fragRaw (привязан к пиксельной сетке)
  float b = bayer4(fragRaw);
  float r = rand01(fragRaw * 1.37);
  float dither = (b - 0.5) * amp + (r - 0.5) * (amp * 0.35);

  float outA = clamp(uA * alphaProfile + dither, 0.0, 1.0);
  vec3 color = vec3(uR, uG, uB) * outA;
  fragColor = vec4(color, outA);
}
