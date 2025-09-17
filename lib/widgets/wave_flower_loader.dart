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
  Duration breathDuration = const Duration(milliseconds: 800);
  Duration rotateDuration = const Duration(seconds: 5);
  double minScale = 0.2;
  double maxScale = 0.5;

  double size = 376.0;
  double radius = 50.0;
  double closedCornerBoost = 20.0;

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

  // TODO: Edit rotate durations
  // rotate duration list (seconds), each index correspoding to the triangle in UI
  List<double> rotateDurationList = const [5, 5, 5, 5, 5, 5];

  late final AnimationController _breath;
  late final Animation<double> _scale;

  late final AnimationController _rotateAll;
  late final Animation<double> _angleAll;

  late final List<AnimationController> _layerRotCtrls;
  late final List<Animation<double>> _layerAnglesAnim;

  @override
  void initState() {
    super.initState();

    _breath = AnimationController(vsync: this, duration: breathDuration)
      ..repeat(reverse: true);

    _scale = Tween<double>(begin: minScale, end: maxScale)
        .animate(CurvedAnimation(parent: _breath, curve: Curves.easeInOut));

    _rotateAll = AnimationController(vsync: this, duration: rotateDuration)
      ..repeat();

    _angleAll = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_rotateAll);

    final layerCount = layerAnglesDeg.length;
    _layerRotCtrls = List.generate(layerCount, (i) {
      final secs = rotateDurationList[i % rotateDurationList.length];
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: (secs * 1000).round()),
      )..repeat();
    });

    _layerAnglesAnim = _layerRotCtrls
        .map((c) => Tween<double>(begin: 0.0, end: 2 * math.pi).animate(c))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _layerRotCtrls) {
      c.dispose();
    }
    _rotateAll.dispose();
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final openCornerRatio = radius / size;
    final baseAngles = layerAnglesDeg.map((d) => d * math.pi / 180).toList();

    return LayoutBuilder(
      builder: (context, c) {
        final maxSide = math.min(c.maxWidth, c.maxHeight);

        final listeners = <Listenable>[_breath, _rotateAll, ..._layerRotCtrls];

        return AnimatedBuilder(
          animation: Listenable.merge(listeners),
          builder: (_, __) {
            final tOpen = ((_scale.value - minScale) / (maxScale - minScale))
                .clamp(0.0, 1.0);
            final baseSize = maxSide * _scale.value;

            Widget layer(int i) {
              final color = layerColors[i];
              final sizeMul = layerSizeMul[i];
              final side = baseSize * sizeMul;

              final openCornerPx = side * openCornerRatio;
              final targetClosedPx = openCornerPx + closedCornerBoost;
              double cornerPx =
                  lerpDouble(openCornerPx, targetClosedPx, 1 - tOpen)!;
              cornerPx = cornerPx.clamp(0.0, side * 0.5 - 0.5);

              final shape = PolygonShapeBorder(
                sides: 3,
                cornerRadius: Length(cornerPx),
              );

              final angle = baseAngles[i] + _layerAnglesAnim[i].value;

              return Transform.rotate(
                angle: angle,
                child: Container(
                  width: side,
                  height: side,
                  decoration: ShapeDecoration(color: color, shape: shape),
                ),
              );
            }

            return Center(
              child: Transform.rotate(
                angle: _angleAll.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(baseAngles.length, layer),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
