#version 320 es
precision highp float;

// uniforms (pixel-space)
uniform vec2 uResolution; // 0: width_px, 1: height_px
uniform vec2 uCenter;     // 2: center_px.x, 3: center_px.y
uniform float uRadius;    // 4: radius_px
uniform float uBlur;      // 5: blur_px
uniform float uR;         // 6: color r 0..1 (sRGB)
uniform float uG;         // 7: color g
uniform float uB;         // 8: color b
uniform float uA;         // 9: alpha 0..1

// 10: базовая амплитуда дезеринга (в долях цвета; ~1/255 типично)
// 11: верхняя граница амплитуды дезеринга (max), тоже в единицах цвета
uniform float uDitherBase;
uniform float uDitherMax;

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
  float jitter = (rand01(pos) - 0.5) * 0.4; // small jitter
  return (float(val) + jitter) / 16.0;
}

void main() {
  vec2 fragPos = gl_FragCoord.xy;

  // distance в пикселях
  float dist = distance(fragPos, uCenter);

  // smoother profile
  float edge0 = uRadius;
  float edge1 = uRadius + max(uBlur, 0.0);
  float alphaProfile = 1.0 - smootherstep(edge0, edge1, dist);

  // если вне зоны влияния — прозрачный
  if (alphaProfile <= 0.0005) {
    fragColor = vec4(0.0);
    return;
  }

  // Быстрый аппрокс градиента альфы: считаем локальную разницу альфа в соседних пикселях (прибл.)
  // Берём 1px шаг — стабильно и без зависимости от производных dFdx
  float distX = distance(fragPos + vec2(1.0, 0.0), uCenter);
  float alphaX = 1.0 - smootherstep(edge0, edge1, distX);
  float distY = distance(fragPos + vec2(0.0, 1.0), uCenter);
  float alphaY = 1.0 - smootherstep(edge0, edge1, distY);

  float gradAlphaX = abs(alphaProfile - alphaX);
  float gradAlphaY = abs(alphaProfile - alphaY);
  float grad = length(vec2(gradAlphaX, gradAlphaY)); // ~ change in alpha per px

  // адаптивная амплитуда: чем меньше градиент (плоская зона) — тем сильнее дезеринг
  float eps = 1e-4;
  float adapt = (0.02 / (grad + eps)); // scalar: larger when grad small
  // scale base by adapt, clamp by uDitherMax
  float amp = clamp(uDitherBase * adapt, 0.0, uDitherMax);

  // bayer + small random jitter to avoid patterning
  float b = bayer4(fragPos);
  float r = rand01(fragPos * 1.37); // different seed
  float dither = (b - 0.5) * amp + (r - 0.5) * (amp * 0.35);

  // final alpha with dither, clamp
  float outA = clamp(uA * alphaProfile + dither, 0.0, 1.0);

  // premultiplied color
  vec3 color = vec3(uR, uG, uB) * outA;
  fragColor = vec4(color, outA);
}
