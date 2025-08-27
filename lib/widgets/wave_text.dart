import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart';

class WaveText extends StatelessWidget {
  const WaveText(
    this.text, {
    super.key,
    this.type = WaveTextType.title,
    this.weight = WaveTextWeight.regular,
    this.waveColor = WaveTextColor.defaultColor,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : assert(color != null || waveColor != null);

  final String text;
  final WaveTextType type;
  final WaveTextWeight weight;
  final WaveTextColor? waveColor;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final style = _buildTextStyle(type, weight, waveColor, color);
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: style,
    );
  }

  static TextStyle _buildTextStyle(
    WaveTextType type,
    WaveTextWeight weight,
    WaveTextColor? waveColor,
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

    // nullable: если inherit — оставляем null и цвет придёт из DefaultTextStyle
    final Color? resolvedColor = switch (waveColor) {
      WaveTextColor.inherit => null,
      WaveTextColor.defaultColor => MdColors.textDefaultColor,
      WaveTextColor.subtitleColor => MdColors.textSubtitleColor,
      WaveTextColor.positiveColor => MdColors.textPositiveColor,
      WaveTextColor.negativeColor => MdColors.textNegativeColor,
      WaveTextColor.disabledColor => MdColors.textDisabledColor,
      WaveTextColor.brandColor => MdColors.textBrandColor,
      null => color,
    };

    return TextStyle(
      fontFamily: 'Play',
      fontSize: size,
      fontWeight: fontWeight,
      height: 1.2,
      letterSpacing: weight == WaveTextWeight.bold ? 0.2 : 0.0,
      color: resolvedColor,
    );
  }
}

enum WaveTextType { title, subtitle, caption, badge }

enum WaveTextWeight { regular, bold }

enum WaveTextColor {
  inherit,
  defaultColor,
  subtitleColor,
  positiveColor,
  negativeColor,
  disabledColor,
  brandColor,
}
