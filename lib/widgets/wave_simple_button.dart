import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';
import 'package:md_ui_kit/_core/colors.dart' show MdColors;

class WaveSimpleButton extends StatefulWidget {
  const WaveSimpleButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = WaveButtonType.main,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 11,
    ),
    this.radius = const BorderRadius.only(
      topLeft: Radius.circular(24),
      topRight: Radius.circular(12),
      bottomRight: Radius.circular(24),
      bottomLeft: Radius.circular(12),
    ),
    this.showShadow = true,
  });

  final String label;

  final VoidCallback? onPressed;
  final WaveButtonType type;

  final EdgeInsets padding;
  final BorderRadius radius;
  final bool showShadow;

  @override
  State<WaveSimpleButton> createState() => _WaveSimpleButtonState();
}

class _WaveSimpleButtonState extends State<WaveSimpleButton> {
  bool _hovered = false;
  bool _pressed = false;

  List<Color> _resolveTextAndButtonColors(bool enabled) {
    Color textColor;
    Color buttonColor;

    if (enabled) {
      if (_pressed) {
        textColor = widget.type.textPressedColor;
        buttonColor = widget.type.buttonPressedColor;
      } else if (_hovered) {
        textColor = widget.type.textHoveredColor;
        buttonColor = widget.type.buttonHoveredColor;
      } else {
        textColor = widget.type.textDefaultColor;
        buttonColor = widget.type.buttonDefaultColor;
      }
    } else {
      textColor = MdColors.buttonDisabledText;
      buttonColor = MdColors.buttonDisabledBg;
    }

    return [buttonColor, textColor];
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final colors = _resolveTextAndButtonColors(enabled);

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: colors[0],
            borderRadius: widget.radius,
            boxShadow: !widget.type.hasShadow
                ? null
                : const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
          ),
          child: Padding(
            padding: widget.padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                WaveText(
                  widget.label,
                  color: colors[1],
                  weight: WaveTextWeight.bold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum WaveButtonType {
  main(
    textDefaultColor: MdColors.buttonMainDefaultText,
    textHoveredColor: MdColors.buttonMainHoverText,
    textPressedColor: MdColors.buttonMainPressedText,
    buttonDefaultColor: MdColors.buttonMainDefaultBg,
    buttonHoveredColor: MdColors.buttonMainHoverBg,
    buttonPressedColor: MdColors.buttonMainPressedBg,
    hasShadow: false,
  ),
  alternative(
    textDefaultColor: MdColors.buttonAltDefaultText,
    textHoveredColor: MdColors.buttonAltHoverText,
    textPressedColor: MdColors.buttonAltPressedText,
    buttonDefaultColor: MdColors.buttonAltDefaultBg,
    buttonHoveredColor: MdColors.buttonAltHoverBg,
    buttonPressedColor: MdColors.buttonAltPressedBg,
    hasShadow: true,
  ),
  error(
    textDefaultColor: MdColors.buttonErrorDefaultText,
    textHoveredColor: MdColors.buttonErrorHoverText,
    textPressedColor: MdColors.buttonErrorPressedText,
    buttonDefaultColor: MdColors.buttonErrorDefaultBg,
    buttonHoveredColor: MdColors.buttonErrorHoverBg,
    buttonPressedColor: MdColors.buttonErrorPressedBg,
    hasShadow: false,
  ),
  inactive(
    textDefaultColor: MdColors.buttonInactiveDefaultText,
    textHoveredColor: MdColors.buttonInactiveHoverText,
    textPressedColor: MdColors.buttonInactivePressedText,
    buttonDefaultColor: MdColors.buttonInactiveDefaultBg,
    buttonHoveredColor: MdColors.buttonInactiveHoverBg,
    buttonPressedColor: MdColors.buttonInactivePressedBg,
    hasShadow: false,
  );

  const WaveButtonType({
    required this.textDefaultColor,
    required this.textHoveredColor,
    required this.textPressedColor,
    required this.buttonDefaultColor,
    required this.buttonHoveredColor,
    required this.buttonPressedColor,
    required this.hasShadow,
  });

  final Color textDefaultColor;
  final Color textHoveredColor;
  final Color textPressedColor;

  final Color buttonDefaultColor;
  final Color buttonHoveredColor;
  final Color buttonPressedColor;

  final bool hasShadow;
}
