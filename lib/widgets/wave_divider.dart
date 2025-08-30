import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';

class WaveDivider extends StatelessWidget {
  const WaveDivider({super.key, required this.label, required this.type});

  final WaveDividerType type;
  final String label;
  static const double gap = 10;
  static const double width = 1;
  static const double borderRadius = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 323,
      child: Row(
        children: [
          Expanded(
              child: Container(
            height: width,
            decoration: BoxDecoration(
              color: type.color,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          )),
          const SizedBox(
            width: gap,
          ),
          WaveText(
            label,
            type: WaveTextType.caption,
            color: type.color,
            weight: WaveTextWeight.bold,
          ),
          const SizedBox(
            width: gap,
          ),
          Expanded(
              child: Container(
            height: width,
            decoration: BoxDecoration(
              color: type.color,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          )),
        ],
      ),
    );
  }
}

enum WaveDividerType {
  positive(color: MdColors.positiveColor),
  negative(color: MdColors.negativeColor),
  process(color: MdColors.brandColor),
  done(color: MdColors.disabledColor);

  const WaveDividerType({required this.color});

  final Color color;
}
