import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart';

class WaveHintText extends StatelessWidget {
  const WaveHintText({
    super.key,
    required this.boldPart,
    required this.normalPart,
    this.boldStyle,
    this.normalStyle,
    this.textAlign = TextAlign.start,
  });

  final String boldPart;
  final String normalPart;
  final TextStyle? boldStyle;
  final TextStyle? normalStyle;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: [
          TextSpan(
            text: boldPart,
            style: boldStyle ??
                _buildTextStyle(
                  WaveTextType.subtitle,
                  WaveTextWeight.bold,
                  MdColors.subtitleColor,
                ),
          ),
          TextSpan(
            text: normalPart,
            style: normalStyle ??
                _buildTextStyle(
                  WaveTextType.subtitle,
                  WaveTextWeight.regular,
                  MdColors.subtitleColor,
                ),
          ),
        ],
      ),
    );
  }
}

TextStyle _buildTextStyle(
  WaveTextType type,
  WaveTextWeight weight,
  Color? color,
) {
  final double size = switch (type) {
    WaveTextType.title => 24,
    WaveTextType.subtitle => 16,
    WaveTextType.caption => 14,
    WaveTextType.badge => 8
  };

  final fontWeight = switch (weight) {
    WaveTextWeight.regular => FontWeight.w400,
    WaveTextWeight.bold => FontWeight.w700,
  };

  return TextStyle(
    fontFamily: 'Play',
    fontSize: size,
    fontWeight: fontWeight,
    color: color,
  );
}

enum WaveTextType { title, subtitle, caption, badge }

enum WaveTextWeight { regular, bold }

enum WaveTextColor {
  inherit,
  titleColor,
  subtitleColor,
  positiveColor,
  negativeColor,
  disabledColor,
  brandColor,
  darkBrandColor,
}
