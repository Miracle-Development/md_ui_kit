import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:morphable_shape/morphable_shape.dart';

class WaveFlowerLoader extends StatefulWidget {
  const WaveFlowerLoader({super.key});

  @override
  State<WaveFlowerLoader> createState() => _WaveFlowerLoaderState();
}

class _WaveFlowerLoaderState extends State<WaveFlowerLoader>
    with TickerProviderStateMixin {
  Duration breathDuration = const Duration(milliseconds: 2200);
  Duration rotateDuration = const Duration(seconds: 8);
  double minScale = 0.1;
  double maxScale = 1.0;

  double size = 376.0;
  double radius = 50.0;
  double closedCornerBoost = 30.0;

  List<double> layerAnglesDeg = const [15, -33, -75, -15, -63, -105];
  List<double> layerSizeMul = const [1.00, 1.10, 1.24, 1.00, 1.10, 1.24];
  List<Color> layerColors = const [
    Color.fromRGBO(220, 218, 255, 0.2),
    Color.fromRGBO(158, 152, 255, 0.2),
    Color.fromRGBO(134, 127, 255, 0.2),
    Color.fromRGBO(220, 218, 255, 0.2),
    Color.fromRGBO(158, 152, 255, 0.2),
    Color.fromRGBO(134, 127, 255, 0.2),
  ];
  late final _breath =
      AnimationController(vsync: this, duration: breathDuration)
        ..repeat(reverse: true);
  late final _rotate =
      AnimationController(vsync: this, duration: rotateDuration)..repeat();

  late final Animation<double> _scale = Tween<double>(
    begin: minScale,
    end: maxScale,
  ).animate(CurvedAnimation(parent: _breath, curve: Curves.easeInOut));

  late final Animation<double> _angle =
      Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_rotate);

  @override
  void dispose() {
    _rotate.dispose();
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final openCornerRatio = radius / size;
    final angles = layerAnglesDeg.map((d) => d * math.pi / 180).toList();

    return LayoutBuilder(
      builder: (context, c) {
        final maxSide = math.min(c.maxWidth, c.maxHeight);

        return AnimatedBuilder(
          animation: Listenable.merge([_breath, _rotate]),
          builder: (_, __) {
            final tOpen = ((_scale.value - minScale) / (maxScale - minScale))
                .clamp(0.0, 1.0);

            final baseSize = maxSide * _scale.value;

            Widget layer(int i) {
              final color = layerColors[i];
              final angle = angles[i];
              final sizeMul = layerSizeMul[i];
              final size = baseSize * sizeMul;

              final openCornerPx = size * openCornerRatio;

              final targetClosedPx = openCornerPx + closedCornerBoost;

              double cornerPx =
                  lerpDouble(openCornerPx, targetClosedPx, 1 - tOpen)!;

              cornerPx = cornerPx.clamp(0.0, size * 0.5 - 0.5);

              final shape = PolygonShapeBorder(
                sides: 3,
                cornerRadius: Length(cornerPx),
              );

              return Transform.rotate(
                angle: angle,
                child: Container(
                  width: size,
                  height: size,
                  decoration: ShapeDecoration(color: color, shape: shape),
                ),
              );
            }

            return Center(
              child: Transform.rotate(
                angle: _angle.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(6, layer),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
