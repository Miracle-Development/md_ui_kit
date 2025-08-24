import 'package:flutter/material.dart';

@immutable
class MdSimpleButtomTheme extends ThemeExtension<MdSimpleButtomTheme> {
  const MdSimpleButtomTheme(
      {required this.buttonMainDefaultBg,
      required this.buttonMainDefaultText,
      required this.buttonMainHoverBg,
      required this.buttonMainHoverText,
      required this.buttonMainPressedBg,
      required this.buttonMainPressedText,
      required this.buttonAltDefaultBg,
      required this.buttonAltDefaultText,
      required this.buttonAltHoverBg,
      required this.buttonAltHoverText,
      required this.buttonAltPressedBg,
      required this.buttonAltPressedText,
      required this.buttonAltShadow,
      required this.buttonDisabledBg,
      required this.buttonDisabledText,
      required this.buttonErrorDefaultBg,
      required this.buttonErrorDefaultText,
      required this.buttonErrorHoverBg,
      required this.buttonErrorHoverText,
      required this.buttonErrorPressedBg,
      required this.buttonErrorPressedText,
      required this.buttonInactiveDefaultBg,
      required this.buttonInactiveDefaultText,
      required this.buttonInactiveHoverBg,
      required this.buttonInactiveHoverText,
      required this.buttonInactivePressedBg,
      required this.buttonInactivePressedText});

  final Color buttonMainDefaultBg;
  final Color buttonMainDefaultText;
  final Color buttonMainHoverBg;
  final Color buttonMainHoverText;
  final Color buttonMainPressedBg;
  final Color buttonMainPressedText;

  final Color buttonAltDefaultBg;
  final Color buttonAltDefaultText;
  final Color buttonAltHoverBg;
  final Color buttonAltHoverText;
  final Color buttonAltPressedBg;
  final Color buttonAltPressedText;
  final Color buttonAltShadow;

  final Color buttonErrorDefaultBg;
  final Color buttonErrorDefaultText;
  final Color buttonErrorHoverBg;
  final Color buttonErrorHoverText;
  final Color buttonErrorPressedBg;
  final Color buttonErrorPressedText;

  final Color buttonInactiveDefaultBg;
  final Color buttonInactiveDefaultText;
  final Color buttonInactiveHoverBg;
  final Color buttonInactiveHoverText;
  final Color buttonInactivePressedBg;
  final Color buttonInactivePressedText;

  final Color buttonDisabledBg;
  final Color buttonDisabledText;

  static const MdSimpleButtomTheme fallback = MdSimpleButtomTheme(
      buttonMainDefaultBg: Color.fromRGBO(67, 70, 243, 1),
      buttonMainDefaultText: Color.fromRGBO(220, 218, 255, 1),
      buttonMainHoverBg: Color.fromRGBO(53, 56, 233, 1),
      buttonMainHoverText: Color.fromRGBO(192, 189, 255, 1),
      buttonMainPressedBg: Color.fromRGBO(41, 44, 224, 1),
      buttonMainPressedText: Color.fromRGBO(186, 182, 251, 1),
      buttonAltDefaultBg: Color.fromRGBO(220, 218, 255, 1),
      buttonAltDefaultText: Color.fromRGBO(48, 51, 212, 1),
      buttonAltHoverBg: Color.fromRGBO(181, 178, 229, 1),
      buttonAltHoverText: Color.fromRGBO(46, 48, 184, 1),
      buttonAltPressedBg: Color.fromRGBO(157, 153, 229, 1),
      buttonAltPressedText: Color.fromRGBO(39, 42, 190, 1),
      buttonAltShadow: Color.fromRGBO(0, 0, 0, 0.25),
      buttonDisabledBg: Color.fromRGBO(116, 115, 140, 1),
      buttonDisabledText: Color.fromRGBO(235, 235, 238, 1),
      buttonErrorDefaultBg: Color.fromRGBO(223, 222, 251, 1),
      buttonErrorDefaultText: Color.fromRGBO(109, 42, 42, 1),
      buttonErrorHoverBg: Color.fromRGBO(204, 178, 185, 1),
      buttonErrorHoverText: Color.fromRGBO(94, 33, 33, 1),
      buttonErrorPressedBg: Color.fromRGBO(224, 82, 84, 1),
      buttonErrorPressedText: Color.fromRGBO(223, 222, 251, 1),
      buttonInactiveDefaultBg: Color.fromRGBO(220, 218, 255, 1),
      buttonInactiveDefaultText: Color.fromRGBO(93, 93, 111, 1),
      buttonInactiveHoverBg: Color.fromRGBO(188, 186, 223, 1),
      buttonInactiveHoverText: Color.fromRGBO(87, 87, 104, 1),
      buttonInactivePressedBg: Color.fromRGBO(150, 148, 185, 1),
      buttonInactivePressedText: Color.fromRGBO(223, 222, 251, 1));

  @override
  MdSimpleButtomTheme copyWith({
    Color? buttonMainDefaultBg,
    Color? buttonMainDefaultText,
    Color? buttonMainHoverBg,
    Color? buttonMainHoverText,
    Color? buttonMainPressedBg,
    Color? buttonMainPressedText,
    Color? buttonAltDefaultBg,
    Color? buttonAltDefaultText,
    Color? buttonAltHoverBg,
    Color? buttonAltHoverText,
    Color? buttonAltPressedBg,
    Color? buttonAltPressedText,
    Color? buttonAltShadow,
    Color? buttonErrorDefaultBg,
    Color? buttonErrorDefaultText,
    Color? buttonErrorHoverBg,
    Color? buttonErrorHoverText,
    Color? buttonErrorPressedBg,
    Color? buttonErrorPressedText,
    Color? buttonInactiveDefaultBg,
    Color? buttonInactiveDefaultText,
    Color? buttonInactiveHoverBg,
    Color? buttonInactiveHoverText,
    Color? buttonInactivePressedBg,
    Color? buttonInactivePressedText,
    Color? buttonDisabledBg,
    Color? buttonDisabledText,
  }) {
    return MdSimpleButtomTheme(
      buttonMainDefaultBg: buttonMainDefaultBg ?? this.buttonMainDefaultBg,
      buttonMainDefaultText:
          buttonMainDefaultText ?? this.buttonMainDefaultText,
      buttonMainHoverBg: buttonMainHoverBg ?? this.buttonMainHoverBg,
      buttonMainHoverText: buttonMainHoverText ?? this.buttonMainHoverText,
      buttonMainPressedBg: buttonMainPressedBg ?? this.buttonMainPressedBg,
      buttonMainPressedText:
          buttonMainPressedText ?? this.buttonMainPressedText,
      buttonAltDefaultBg: buttonAltDefaultBg ?? this.buttonAltDefaultBg,
      buttonAltDefaultText: buttonAltDefaultText ?? this.buttonAltDefaultText,
      buttonAltHoverBg: buttonAltHoverBg ?? this.buttonAltHoverBg,
      buttonAltHoverText: buttonAltHoverText ?? this.buttonAltHoverText,
      buttonAltPressedBg: buttonAltPressedBg ?? this.buttonAltPressedBg,
      buttonAltPressedText: buttonAltPressedText ?? this.buttonAltPressedText,
      buttonAltShadow: buttonAltShadow ?? this.buttonAltShadow,
      buttonErrorDefaultBg: buttonErrorDefaultBg ?? this.buttonErrorDefaultBg,
      buttonErrorDefaultText:
          buttonErrorDefaultText ?? this.buttonErrorDefaultText,
      buttonErrorHoverBg: buttonErrorHoverBg ?? this.buttonErrorHoverBg,
      buttonErrorHoverText: buttonErrorHoverText ?? this.buttonErrorHoverText,
      buttonErrorPressedBg: buttonErrorPressedBg ?? this.buttonErrorPressedBg,
      buttonErrorPressedText:
          buttonErrorPressedText ?? this.buttonErrorPressedText,
      buttonInactiveDefaultBg:
          buttonInactiveDefaultBg ?? this.buttonInactiveDefaultBg,
      buttonInactiveDefaultText:
          buttonInactiveDefaultText ?? this.buttonInactiveDefaultText,
      buttonInactiveHoverBg:
          buttonInactiveHoverBg ?? this.buttonInactiveHoverBg,
      buttonInactiveHoverText:
          buttonInactiveHoverText ?? this.buttonInactiveHoverText,
      buttonInactivePressedBg:
          buttonInactivePressedBg ?? this.buttonInactivePressedBg,
      buttonInactivePressedText:
          buttonInactivePressedText ?? this.buttonInactivePressedText,
      buttonDisabledBg: buttonDisabledBg ?? this.buttonDisabledBg,
      buttonDisabledText: buttonDisabledText ?? this.buttonDisabledText,
    );
  }

  @override
  ThemeExtension<MdSimpleButtomTheme> lerp(
      ThemeExtension<MdSimpleButtomTheme>? other, double t) {
    if (other is! MdSimpleButtomTheme) return this;
    Color lerp(Color a, Color b) => Color.lerp(a, b, t)!;
    return MdSimpleButtomTheme(
      buttonMainDefaultBg: lerp(buttonMainDefaultBg, other.buttonMainDefaultBg),
      buttonMainDefaultText:
          lerp(buttonMainDefaultText, other.buttonMainDefaultText),
      buttonMainHoverBg: lerp(buttonMainHoverBg, other.buttonMainHoverBg),
      buttonMainHoverText: lerp(buttonMainHoverText, other.buttonMainHoverText),
      buttonMainPressedBg: lerp(buttonMainPressedBg, other.buttonMainPressedBg),
      buttonMainPressedText:
          lerp(buttonMainPressedText, other.buttonMainPressedText),
      buttonAltDefaultBg: lerp(buttonAltDefaultBg, other.buttonAltDefaultBg),
      buttonAltDefaultText:
          lerp(buttonAltDefaultText, other.buttonAltDefaultText),
      buttonAltHoverBg: lerp(buttonAltHoverBg, other.buttonAltHoverBg),
      buttonAltHoverText: lerp(buttonAltHoverText, other.buttonAltHoverText),
      buttonAltPressedBg: lerp(buttonAltPressedBg, other.buttonAltPressedBg),
      buttonAltPressedText:
          lerp(buttonAltPressedText, other.buttonAltPressedText),
      buttonAltShadow: lerp(buttonAltShadow, other.buttonAltShadow),
      buttonErrorDefaultBg:
          lerp(buttonErrorDefaultBg, other.buttonErrorDefaultBg),
      buttonErrorDefaultText:
          lerp(buttonErrorDefaultText, other.buttonErrorDefaultText),
      buttonErrorHoverBg: lerp(buttonErrorHoverBg, other.buttonErrorHoverBg),
      buttonErrorHoverText:
          lerp(buttonErrorHoverText, other.buttonErrorHoverText),
      buttonErrorPressedBg:
          lerp(buttonErrorPressedBg, other.buttonErrorPressedBg),
      buttonErrorPressedText:
          lerp(buttonErrorPressedText, other.buttonErrorPressedText),
      buttonInactiveDefaultBg:
          lerp(buttonInactiveDefaultBg, other.buttonInactiveDefaultBg),
      buttonInactiveDefaultText:
          lerp(buttonInactiveDefaultText, other.buttonInactiveDefaultText),
      buttonInactiveHoverBg:
          lerp(buttonInactiveHoverBg, other.buttonInactiveHoverBg),
      buttonInactiveHoverText:
          lerp(buttonInactiveHoverText, other.buttonInactiveHoverText),
      buttonInactivePressedBg:
          lerp(buttonInactivePressedBg, other.buttonInactivePressedBg),
      buttonInactivePressedText:
          lerp(buttonInactivePressedText, other.buttonInactivePressedText),
      buttonDisabledBg: lerp(buttonDisabledBg, other.buttonDisabledBg),
      buttonDisabledText: lerp(buttonDisabledText, other.buttonDisabledText),
    );
  }

  static MdSimpleButtomTheme of(BuildContext context) =>
      Theme.of(context).extension<MdSimpleButtomTheme>() ?? fallback;
}
