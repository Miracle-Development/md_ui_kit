import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:morphable_shape/morphable_shape.dart';

class WaveFlowerLoader extends StatefulWidget {
  const WaveFlowerLoader({
    super.key,
    this.breathDuration = const Duration(seconds: 2),
    this.rotateDuration = const Duration(seconds: 6),
    this.cornerRadius = 50.0,
    this.minScale = 0.03,
    this.maxScale = 1.0,
  });

  final Duration breathDuration;
  final Duration rotateDuration;
  final double cornerRadius;
  final double minScale;
  final double maxScale;

  @override
  State<WaveFlowerLoader> createState() => _WaveFlowerLoaderState();
}

class _WaveFlowerLoaderState extends State<WaveFlowerLoader>
    with TickerProviderStateMixin {
  late final AnimationController _breathCtrl =
      AnimationController(vsync: this, duration: widget.breathDuration)
        ..repeat(reverse: true);

  late final AnimationController _rotCtrl =
      AnimationController(vsync: this, duration: widget.rotateDuration)
        ..repeat();

  late final Animation<double> _scale = Tween<double>(
    begin: widget.minScale,
    end: widget.maxScale,
  ).animate(CurvedAnimation(parent: _breathCtrl, curve: Curves.easeInOut));

  late final Animation<double> _angle = Tween<double>(
    begin: 0.0,
    end: 2 * math.pi,
  ).animate(_rotCtrl);

  MorphableShapeBorder _roundedTriangle(double rPx) => PolygonShapeBorder(
        sides: 3,
        cornerRadius: Length(rPx),
      );

  @override
  void dispose() {
    _rotCtrl.dispose();
    _breathCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shape = _roundedTriangle(widget.cornerRadius);

    final angles = <double>[15, -33, -75, -15, -63, -105]
        .map((d) => d * math.pi / 180)
        .toList();

    final colors = <Color>[
      const Color.fromRGBO(220, 218, 255, 0.20),
      const Color.fromRGBO(158, 152, 255, 0.20),
      const Color.fromRGBO(134, 127, 255, 0.20),
      const Color.fromRGBO(220, 218, 255, 0.20),
      const Color.fromRGBO(158, 152, 255, 0.20),
      const Color.fromRGBO(134, 127, 255, 0.20),
    ];

    Widget buildFlower(double baseSize) {
      Widget layer(double angle, Color color) => Transform.rotate(
            angle: angle,
            child: Container(
              width: baseSize,
              height: baseSize,
              decoration: ShapeDecoration(
                color: color,
                shape: shape,
              ),
            ),
          );

      return Stack(
        alignment: Alignment.center,
        children: List.generate(6, (i) => layer(angles[i], colors[i])),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final baseSize = math.min(constraints.maxWidth, constraints.maxHeight);

        return AnimatedBuilder(
          animation: Listenable.merge([_breathCtrl, _rotCtrl]),
          builder: (_, __) => Center(
            child: Transform.rotate(
              angle: _angle.value,
              child: Transform.scale(
                scale: _scale.value,
                child: SizedBox(
                  width: baseSize,
                  height: baseSize,
                  child: buildFlower(baseSize),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
