import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';

class WaveStatus extends StatelessWidget {
  const WaveStatus({
    super.key,
    required this.color,
    required this.label,
    this.iconSize = 12,
    this.gap = 10,
    this.height = 21,
  });

  final WaveStatusColor color;
  final String label;

  final double iconSize;
  final double gap;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (label.trim().isEmpty) {
      return SizedBox(
        height: height,
      );
    }
    return SizedBox(
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SizedBox(
              width: iconSize,
              height: iconSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(width: gap),
          Flexible(
            child: WaveText(
              label,
              type: WaveTextType.subtitle,
              weight: WaveTextWeight.bold,
              color: color.color,
            ),
          ),
        ],
      ),
    );
  }
}

enum WaveStatusColor {
  titleColor(color: MdColors.titleColor),
  subtitleColor(color: MdColors.subtitleColor),
  positiveColor(color: MdColors.positiveColor),
  negativeColor(color: MdColors.negativeColor),
  disabledColor(color: MdColors.disabledColor),
  brandColor(color: MdColors.brandColor),
  darkBrandColor(color: MdColors.darkBrandColor);

  const WaveStatusColor({required this.color});
  final Color color;
}
