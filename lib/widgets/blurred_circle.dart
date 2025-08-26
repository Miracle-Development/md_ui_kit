// lib/widgets/blurred_circle.dart
import 'dart:ui' as ui;
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class BlurredCircle extends StatefulWidget {
  const BlurredCircle({
    super.key,
    this.alignment = Alignment.center,
    this.offset = Offset.zero,
    required this.radius,
    this.blur = 30,
    required this.color,
  });

  final Alignment alignment; // logical px
  final Offset offset; // logical px
  final double radius; // logical px (передавать желаемый радиус)
  final double blur; // logical px
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
    final double dpr = MediaQuery.of(context).devicePixelRatio;
    final double fragIsLogicalFlag = kIsWeb ? 1.0 : 0.0;

    return FutureBuilder<ui.FragmentProgram>(
      future: _program,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final shader = snapshot.data!.fragmentShader();

        return CustomPaint(
          size: Size.infinite,
          painter: _CirclePainter(
            shader: shader,
            alignment: widget.alignment,
            offset: widget.offset,
            radius: widget.radius,
            blur: widget.blur,
            color: widget.color,
            dpr: dpr,
          ),
        );
      },
    );
  }
}

class _CirclePainter extends CustomPainter {
  _CirclePainter({
    required this.shader,
    required this.alignment,
    required this.offset,
    required this.radius,
    required this.blur,
    required this.color,
    required this.dpr,
  });

  final ui.FragmentShader shader;
  final Alignment alignment;
  final Offset offset;
  final double radius;
  final double blur;
  final Color color;
  final double dpr;

  @override
  void paint(Canvas canvas, Size size) {
    // logical coordinates (size уже в logical px)
    final Offset centerLogical = alignment.alongSize(size) + offset;
    final double wLogical = size.width;
    final double hLogical = size.height;

    // radius и blur оставляем в логических пикселях — как их передали
    final double radiusLogical = radius;
    final double blurLogical = blur;

    // color components
    final int argb = color.value;
    final double a = ((argb >> 24) & 0xFF) / 255.0;
    final double r = ((argb >> 16) & 0xFF) / 255.0;
    final double g = ((argb >> 8) & 0xFF) / 255.0;
    final double b = (argb & 0xFF) / 255.0;

    const double ditherBase = 1.5 / 255.0;
    const double ditherMax = 6.0 / 255.0;

    // порядок uniforms должен совпадать с шейдером:
    final floats = <double>[
      // uResCenter: resLogical.w, resLogical.h, centerX_logical, centerY_logical
      wLogical, // 0
      hLogical, // 1
      centerLogical.dx, // 2
      centerLogical.dy, // 3

      // uParams: radius_logical, blur_logical, ditherBase, ditherMax
      radiusLogical, // 4
      blurLogical, // 5
      ditherBase, // 6
      ditherMax, // 7

      // uColor
      r, // 8
      g, // 9
      b, // 10
      a, // 11

      // uDpr
      dpr, // 12
    ];

    int written = 0;
    for (var i = 0; i < floats.length; i++) {
      try {
        shader.setFloat(i, floats[i]);
        written++;
      } on RangeError {
        assert(() {
          developer.log(
            'FragmentShader supports only $written floats on this platform; skipping remaining ${floats.length - i} floats.',
            name: 'shaders',
          );
          return true;
        }());
        break;
      }
    }

    // TODO: разобраться с логическими/физическими координатами на iOS/Android
    // developer.log(
    //   'size=$size dpr=$dpr centerLogical=$centerLogical radius=$radiusLogical fragIsLogical=$fragCoordIsLogical',
    // );

    final paintObj = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paintObj);
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) => true;
}
