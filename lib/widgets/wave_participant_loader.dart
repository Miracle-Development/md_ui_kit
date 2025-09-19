import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart';

class WaveParticipantLoader extends StatefulWidget {
  const WaveParticipantLoader({
    super.key,
    this.size = 6,
    this.gap = 6,
    this.duration = const Duration(milliseconds: 1200),
    this.first = MdColors.participantLoaderFirstPointColor,
    this.second = MdColors.participantLoaderSecondPointColor,
    this.third = MdColors.participantLoaderThirdPointColor,
    this.direction = WaveParticipantLoaderDirection.leftToRight,
  });

  final double size;
  final double gap;
  final Duration duration;

  final Color first;
  final Color second;
  final Color third;

  final WaveParticipantLoaderDirection direction;

  @override
  State<WaveParticipantLoader> createState() => _ParticipantLoaderState();
}

class _ParticipantLoaderState extends State<WaveParticipantLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration)..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [widget.first, widget.second, widget.third];
    final dirSign =
        widget.direction == WaveParticipantLoaderDirection.leftToRight
            ? -1.0
            : 1.0;

    double fract(double x) => x - x.floorToDouble();

    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final base = _c.value;

        Color colorForDot(int index) {
          final phase = base + dirSign * index / 3.0;
          final t = fract(phase);
          final seg = (t * 3).floor();
          final localT = (t * 3) - seg;
          final a = colors[seg];
          final b = colors[(seg + 1) % 3];
          return _lerpHSV(a, b, Curves.easeInOut.transform(localT));
        }

        Widget dot(int i) => Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: colorForDot(i),
                shape: BoxShape.circle,
              ),
            );

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            dot(0),
            SizedBox(width: widget.gap),
            dot(1),
            SizedBox(width: widget.gap),
            dot(2),
          ],
        );
      },
    );
  }
}

Color _lerpHSV(Color a, Color b, double t) {
  final ahsv = HSVColor.fromColor(a);
  final bhsv = HSVColor.fromColor(b);

  double hueA = ahsv.hue, hueB = bhsv.hue;
  double d = hueB - hueA;
  if (d.abs() > 180) {
    if (d > 0) {
      hueA += 360;
    } else {
      hueB += 360;
    }
  }

  final h = hueA + (hueB - hueA) * t;
  final s = ahsv.saturation + (bhsv.saturation - ahsv.saturation) * t;
  final v = ahsv.value + (bhsv.value - ahsv.value) * t;
  final aOut = a.alpha + (b.alpha - a.alpha) * t;

  return HSVColor.fromAHSV(aOut / 255.0, h % 360, s, v).toColor();
}

enum WaveParticipantLoaderDirection { leftToRight, rightToLeft }
