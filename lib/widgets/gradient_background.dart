import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0xFF0D0D0F),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: child,
            ),
            BlurredCircle(
              alignment: Alignment.topCenter,
              offset: const Offset(0, -100),
              radius: 128,
              blur: 100,
              color: const Color(0xFF1B2CE9).withAlpha(13),
            ),
            BlurredCircle(
              alignment: Alignment.centerRight,
              offset: const Offset(125, 0),
              radius: 183,
              blur: 400,
              color: const Color(0xFF7C41F3).withAlpha(20),
            ),
            BlurredCircle(
              alignment: Alignment.bottomLeft,
              offset: const Offset(65, -68),
              radius: 136,
              blur: 400,
              color: const Color(0xFF4145F3).withAlpha(13),
            ),
            BlurredCircle(
              alignment: Alignment.bottomLeft,
              offset: const Offset(106, 0),
              radius: 136,
              blur: 400,
              color: const Color(0xFF1B2CE9).withAlpha(13),
            ),
            BlurredCircle(
              alignment: Alignment.bottomLeft,
              offset: const Offset(31, -19),
              radius: 136,
              blur: 400,
              color: const Color(0xFF1B2CE9).withAlpha(13),
            ),
          ],
        ),
      ),
    );
  }
}

class BlurredCircle extends StatefulWidget {
  const BlurredCircle({
    super.key,
    this.alignment = Alignment.center,
    this.offset = Offset.zero,
    required this.radius,
    this.blur = 30,
    required this.color,
  });

  final Alignment alignment; // позиция относительно экрана
  final Offset offset; // дополнительный сдвиг
  final double radius;
  final double blur;
  final Color color;

  @override
  State<BlurredCircle> createState() => _BlurredCircleState();
}

class _BlurredCircleState extends State<BlurredCircle> {
  late Future<ui.FragmentProgram> _program;

  @override
  void initState() {
    super.initState();
    _program = ui.FragmentProgram.fromAsset('shaders/blurred_circle.frag');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.FragmentProgram>(
      future: _program,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final shader = snapshot.data!.fragmentShader();

        return CustomPaint(
          size: Size.infinite,
          painter: _CirclePainter(
            shader,
            alignment: widget.alignment,
            offset: widget.offset,
            radius: widget.radius,
            blur: widget.blur,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _CirclePainter extends CustomPainter {
  _CirclePainter(
    this.shader, {
    required this.alignment,
    required this.offset,
    required this.radius,
    required this.blur,
    required this.color,
  });

  final ui.FragmentShader shader;
  final Alignment alignment;
  final Offset offset;
  final double radius;
  final double blur;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // devicePixelRatio — для web/desktop это может быть 1.0 или >1
    final double dpr = ui.window.devicePixelRatio;

    // центр в логических пикселях
    final Offset centerPxLogical = alignment.alongSize(size) + offset;

    // переводим в физические пиксели
    final double centerXpx = centerPxLogical.dx * dpr;
    final double centerYpx = centerPxLogical.dy * dpr;

    // физическая резолюция полотна
    final double resWpx = size.width * dpr;
    final double resHpx = size.height * dpr;

    // радиус и blur в физич пикселях
    final double radiusPx = radius * dpr;
    final double blurPx = blur * dpr;

    // color -> components
    final int argb = color.value; // 0xAARRGGBB
    final double a = ((argb >> 24) & 0xFF) / 255.0;
    final double r = ((argb >> 16) & 0xFF) / 255.0;
    final double g = ((argb >> 8) & 0xFF) / 255.0;
    final double b = (argb & 0xFF) / 255.0;

    // порядок uniforms должен совпадать с шейдером:

    shader.setFloat(0, resWpx); // uResolution.x
    shader.setFloat(1, resHpx); // uResolution.y
    shader.setFloat(2, centerXpx); // uCenter.x
    shader.setFloat(3, centerYpx); // uCenter.y
    shader.setFloat(4, radiusPx); // uRadius
    shader.setFloat(5, blurPx); // uBlur
    shader.setFloat(6, r); // uR
    shader.setFloat(7, g); // uG
    shader.setFloat(8, b); // uB
    shader.setFloat(9, a); // uA

    // Добавляем dither amplitude (uDitherAmp)
    const double base = 1.5 / 255.0; // начни с ~0.0059
    const double maxAmp = 6.0 / 255.0; // например 0.0235
    shader.setFloat(10, base);
    shader.setFloat(11, maxAmp);

    final paintObj = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paintObj);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
