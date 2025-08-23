import 'package:flutter/material.dart';

// MdTextTheme хранит в себе возможные цвета текста
@immutable
class MdTextTheme extends ThemeExtension<MdTextTheme> {
  const MdTextTheme({
    required this.defaultColor,
    required this.subtitleColor,
    required this.positiveColor,
    required this.negativeColor,
    required this.disabledColor,
    required this.brandColor,
  });

  final Color defaultColor;
  final Color subtitleColor;
  final Color positiveColor;
  final Color negativeColor;
  final Color disabledColor;
  final Color brandColor;

  static const MdTextTheme fallback = MdTextTheme(
    defaultColor: Color.fromRGBO(220, 218, 255, 1),
    subtitleColor: Color.fromRGBO(174, 174, 207, 1),
    positiveColor: Color.fromRGBO(50, 130, 59, 1),
    negativeColor: Color.fromRGBO(130, 50, 50, 1),
    disabledColor: Color.fromRGBO(113, 113, 136, 1),
    brandColor: Color.fromRGBO(67, 70, 243, 1),
  );

  @override
  ThemeExtension<MdTextTheme> copyWith({
    Color? defaultColor,
    Color? subtitleColor,
    Color? positiveColor,
    Color? negativeColor,
    Color? disabledColor,
    Color? brandColor,
  }) {
    return MdTextTheme(
      defaultColor: defaultColor ?? this.defaultColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      positiveColor: positiveColor ?? this.positiveColor,
      negativeColor: negativeColor ?? this.negativeColor,
      disabledColor: disabledColor ?? this.disabledColor,
      brandColor: brandColor ?? this.brandColor,
    );
  }

  @override
  ThemeExtension<MdTextTheme> lerp(
      ThemeExtension<MdTextTheme>? other, double t) {
    if (other is! MdTextTheme) return this;
    return MdTextTheme(
      defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
      positiveColor: Color.lerp(positiveColor, other.positiveColor, t)!,
      negativeColor: Color.lerp(negativeColor, other.negativeColor, t)!,
      disabledColor: Color.lerp(disabledColor, other.disabledColor, t)!,
      brandColor: Color.lerp(brandColor, other.brandColor, t)!,
    );
  }

  static MdTextTheme of(BuildContext context) =>
      Theme.of(context).extension<MdTextTheme>() ?? fallback;
}

/// MdText — текстовый виджет
class MdText extends StatelessWidget {
  const MdText(
    this.text, {
    super.key,
    this.type = MdTextType.title,
    this.weight = MdTextWeight.regular,
    this.color = MdTextColor.defaultColor,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final MdTextType type;
  final MdTextWeight weight;
  final MdTextColor color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final style = _buildTextStyle(context, type, weight, color);
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: style,
    );
  }

  static const MdTextPreset title = MdTextPreset(type: MdTextType.title);
  static const MdTextPreset subtitle = MdTextPreset(type: MdTextType.subtitle);
  static const MdTextPreset caption = MdTextPreset(type: MdTextType.caption);

  static TextStyle _buildTextStyle(
    BuildContext context,
    MdTextType type,
    MdTextWeight weight,
    MdTextColor color,
  ) {
    final double size = switch (type) {
      MdTextType.title => 24,
      MdTextType.subtitle => 16,
      MdTextType.caption => 14,
    };

    final fontWeight = switch (weight) {
      MdTextWeight.regular => FontWeight.w400,
      MdTextWeight.bold => FontWeight.w700,
    };

    final theme = MdTextTheme.of(context);
    final Color resolvedColor = switch (color) {
      MdTextColor.defaultColor => theme.defaultColor,
      MdTextColor.subtitleColor => theme.subtitleColor,
      MdTextColor.positiveColor => theme.positiveColor,
      MdTextColor.negativeColor => theme.negativeColor,
      MdTextColor.disabledColor => theme.disabledColor,
      MdTextColor.brandColor => theme.brandColor,
    };

    return TextStyle(
      fontFamily: 'Play',
      fontSize: size,
      fontWeight: fontWeight,
      height: 1.2,
      letterSpacing: weight == MdTextWeight.bold ? 0.2 : 0.0,
      color: resolvedColor,
    );
  }
}

// Енамчики для более удобного обращения к параметрам текста

enum MdTextType { title, subtitle, caption }

enum MdTextWeight { regular, bold }

enum MdTextColor {
  defaultColor,
  subtitleColor,
  positiveColor,
  negativeColor,
  disabledColor,
  brandColor,
}

class MdTextPreset {
  const MdTextPreset({
    required this.type,
    this.weight = MdTextWeight.regular,
    this.color = MdTextColor.defaultColor,
  });

  final MdTextType type;
  final MdTextWeight weight;
  final MdTextColor color;

  // Быстрые модификаторы
  MdTextPreset get bold => copyWith(weight: MdTextWeight.bold);
  MdTextPreset get regular => copyWith(weight: MdTextWeight.regular);

  MdTextPreset copyWith({
    MdTextType? type,
    MdTextWeight? weight,
    MdTextColor? color,
  }) {
    return MdTextPreset(
      type: type ?? this.type,
      weight: weight ?? this.weight,
      color: color ?? this.color,
    );
  }

  // Делаем пресет вызываемым как функцию, возвращает MdText
  MdText call(
    String text, {
    Key? key,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return MdText(
      text,
      key: key,
      type: type,
      weight: weight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
