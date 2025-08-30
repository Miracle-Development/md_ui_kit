import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';

class WaveStatus extends StatelessWidget {
  const WaveStatus({
    super.key,
    required this.type,
    required this.label,
    this.statusCircleSize = 12,
    this.gap = 10,
  });

  final WaveStatusType type;
  final String label;

  final double statusCircleSize;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: statusCircleSize,
          height: statusCircleSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: type.color,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: gap),
        Flexible(
          child: WaveText(
            label,
            type: WaveTextType.subtitle,
            weight: WaveTextWeight.bold,
            color: type.color,
          ),
        ),
      ],
    );
  }
}

enum WaveStatusType {
  title(color: MdColors.titleColor),
  subtitle(color: MdColors.subtitleColor),
  positive(color: MdColors.positiveColor),
  negative(color: MdColors.negativeColor),
  disabled(color: MdColors.disabledColor),
  brand(color: MdColors.brandColor),
  darkBrand(color: MdColors.darkBrandColor);

  const WaveStatusType({required this.color});
  final Color color;
}
