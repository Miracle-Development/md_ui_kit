import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';

class WaveDivider extends StatelessWidget {
  const WaveDivider({
    super.key,
    required this.color,
    this.label,
    this.gap = 10,
    this.thickness = 1,
    this.radius = 1,
  });

  final WaveDividerColor color;
  final String? label;
  final double gap;
  final double thickness;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final hasLabel = (label != null && label!.trim().isNotEmpty);

    final line = Expanded(
        child: SizedBox(
      width: double.infinity,
      height: thickness,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.color,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    ));

    if (!hasLabel) {
      return Container(
        width: double.infinity,
        height: thickness,
        decoration: BoxDecoration(
          color: color.color,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          line,
          SizedBox(width: gap),
          Flexible(
            child: WaveText(
              label!,
              type: WaveTextType.caption,
              color: color.color,
              weight: WaveTextWeight.bold,
            ),
          ),
          SizedBox(width: gap),
          line,
        ],
      ),
    );
  }
}

enum WaveDividerColor {
  titleColor(color: MdColors.titleColor),
  subtitleColor(color: MdColors.subtitleColor),
  positiveColor(color: MdColors.positiveColor),
  negativeColor(color: MdColors.negativeColor),
  disabledColor(color: MdColors.disabledColor),
  brandColor(color: MdColors.negativeColor),
  darkBrandColor(color: MdColors.darkBrandColor);

  const WaveDividerColor({required this.color});
  final Color color;
}
