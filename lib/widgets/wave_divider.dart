import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';

class WaveDivider extends StatelessWidget {
  const WaveDivider({
    super.key,
    required this.type,
    required this.label,
    this.gap = 10,
    this.thickness = 1,
    this.radius = 1,
  });

  final WaveDividerType type;
  final String label;
  final double gap;
  final double thickness;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxTextWidth = constraints.maxWidth * 0.8;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Divider(
                  color: type.color,
                  thickness: 1,
                  height: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: gap),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxTextWidth),
                  child: WaveText(
                    label,
                    textAlign: TextAlign.center,
                    type: WaveTextType.caption,
                    color: type.color,
                    weight: WaveTextWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: type.color,
                  thickness: 1,
                  height: 1,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

enum WaveDividerType {
  title(color: MdColors.titleColor),
  subtitle(color: MdColors.subtitleColor),
  positive(color: MdColors.positiveColor),
  negative(color: MdColors.negativeColor),
  disabled(color: MdColors.disabledColor),
  brand(color: MdColors.brandColor),
  darkBrand(color: MdColors.darkBrandColor);

  const WaveDividerType({required this.color});
  final Color color;
}
