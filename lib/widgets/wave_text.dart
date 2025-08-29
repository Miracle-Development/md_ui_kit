import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart';

class WaveText extends StatelessWidget {
  const WaveText(
    this.text, {
    super.key,
    this.type = WaveTextType.title,
    this.weight = WaveTextWeight.regular,
    this.waveColor = WaveTextColor.titleColor,
    this.color,
    this.textAlign,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
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

    final Color? resolvedColor = switch (waveColor) {
      WaveTextColor.inherit => null,
      WaveTextColor.titleColor => MdColors.textTitleColor,
      WaveTextColor.subtitleColor => MdColors.textSubtitleColor,
      WaveTextColor.positiveColor => MdColors.textPositiveColor,
      WaveTextColor.negativeColor => MdColors.textNegativeColor,
      WaveTextColor.disabledColor => MdColors.textDisabledColor,
      WaveTextColor.brandColor => MdColors.textBrandColor,
      WaveTextColor.darkBrandColor => MdColors.textDarkBrandColor,
      null => color,
    };

    return TextStyle(
      fontFamily: 'Play',
      fontSize: size,
      fontWeight: fontWeight,
      color: color ?? resolvedColor,
    );
  }
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
