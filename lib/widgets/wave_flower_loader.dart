import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:morphable_shape/morphable_shape.dart';

class WaveFlowerLoader extends StatefulWidget {
  const WaveFlowerLoader({
    super.key,
    this.breathDuration = const Duration(seconds: 2),
    this.rotateDuration = const Duration(seconds: 6),
    this.designCornerRadiusPx = 50.0,
    this.designSizePx = 376.0,
    this.minScale = 0.05,
    this.maxScale = 1.0,
  });

  final Duration breathDuration;
  final Duration rotateDuration;

  final double designCornerRadiusPx;
  final double designSizePx;

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

  @override
  void dispose() {
    _rotCtrl.dispose();
    _breathCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radiusRatio = widget.designCornerRadiusPx / widget.designSizePx;

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSize = math.min(constraints.maxWidth, constraints.maxHeight);

        return AnimatedBuilder(
          animation: Listenable.merge([_breathCtrl, _rotCtrl]),
          builder: (_, __) {
            final effectiveSize = maxSize * _scale.value;

            final cornerRadiusPx = effectiveSize * radiusRatio;

            MorphableShapeBorder roundedTriangle(double rPx) =>
                PolygonShapeBorder(
                  sides: 3,
                  cornerRadius: Length(cornerRadiusPx),
                );

            final shape = roundedTriangle(cornerRadiusPx);

            Widget layer(double angle, Color color) => Transform.rotate(
                  angle: angle,
                  child: Container(
                    width: effectiveSize,
                    height: effectiveSize,
                    decoration: ShapeDecoration(
                      color: color,
                      shape: shape,
                    ),
                  ),
                );

            return Center(
              child: Transform.rotate(
                angle: _angle.value,
                child: SizedBox(
                  width: maxSize,
                  height: maxSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children:
                        List.generate(6, (i) => layer(angles[i], colors[i])),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
