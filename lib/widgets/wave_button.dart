import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';
import 'package:md_ui_kit/_core/colors.dart' show MdColors;

class WaveButton extends StatefulWidget {
  const WaveButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.type = WaveButtonType.main,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 11),
    this.radius = const BorderRadius.only(
      topLeft: Radius.circular(24),
      topRight: Radius.circular(12),
      bottomRight: Radius.circular(24),
      bottomLeft: Radius.circular(12),
    ),
    this.showShadow = true,
  }) : assert(
          label != null || child != null,
        );

  final String? label;
  final Widget? child;

  final VoidCallback? onPressed;
  final WaveButtonType type;

  final EdgeInsets padding;
  final BorderRadius radius;
  final bool showShadow;

  @override
  State<WaveButton> createState() => _WaveButtonState();
}

class _WaveButtonState extends State<WaveButton> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    const disabledTextColor = MdColors.buttonDisabledText;
    const disabledButtonColor = MdColors.buttonDisabledBg;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: enabled
                ? _pressed
                    ? widget.type.buttonPressedColor
                    : _hover
                        ? widget.type.buttonHoveredColor
                        : widget.type.buttonDefaultColor
                : disabledButtonColor,
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
                if (widget.child != null) widget.child!,
                if (widget.label != null)
                  WaveText(
                    widget.label!,
                    color: enabled
                        ? _pressed
                            ? widget.type.textPressedColor
                            : _hover
                                ? widget.type.textHoveredColor
                                : widget.type.textDefaultColor
                        : disabledTextColor,
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

// ({Color bg, Color text, bool shadow}) _colorsFor(_BtnState s) {
//   switch (widget.type) {
//     case WaveButtonType.main:
//       return switch (s) {
//         _BtnState.normal => (
//             bg: MdColors.buttonMainDefaultBg,
//             text: MdColors.buttonMainDefaultText,
//             shadow: true
//           ),
//         _BtnState.hover => (
//             bg: MdColors.buttonMainHoverBg,
//             text: MdColors.buttonMainHoverText,
//             shadow: true
//           ),
//         _BtnState.pressed => (
//             bg: MdColors.buttonMainPressedBg,
//             text: MdColors.buttonMainPressedText,
//             shadow: true
//           ),
//         _BtnState.disabled => (
//             bg: MdColors.buttonDisabledBg,
//             text: MdColors.buttonDisabledText,
//             shadow: false
//           ),
//       };
// case WaveButtonType.alternative:
//   return switch (s) {
//     _BtnState.normal => (
//         bg: MdColors.buttonAltDefaultBg,
//         text: MdColors.buttonAltDefaultText,
//         shadow: true
//       ),
//     _BtnState.hover => (
//         bg: MdColors.buttonAltHoverBg,
//         text: MdColors.buttonAltHoverText,
//         shadow: true
//       ),
//     _BtnState.pressed => (
//         bg: MdColors.buttonAltPressedBg,
//         text: MdColors.buttonAltPressedText,
//         shadow: true
//       ),
//     _BtnState.disabled => (
//         bg: MdColors.buttonDisabledBg,
//         text: MdColors.buttonDisabledText,
//         shadow: false
//       ),
//   };
// case WaveButtonType.error:
//   return switch (s) {
//     _BtnState.normal => (
//         bg: MdColors.buttonErrorDefaultBg,
//         text: MdColors.buttonErrorDefaultText,
//         shadow: true
//       ),
//     _BtnState.hover => (
//         bg: MdColors.buttonErrorHoverBg,
//         text: MdColors.buttonErrorHoverText,
//         shadow: true
//       ),
//     _BtnState.pressed => (
//         bg: MdColors.buttonErrorPressedBg,
//         text: MdColors.buttonErrorPressedText,
//         shadow: true
//       ),
//     _BtnState.disabled => (
//         bg: MdColors.buttonDisabledBg,
//         text: MdColors.buttonDisabledText,
//         shadow: false
//       ),
//   };
// case WaveButtonType.inactive:
//   return switch (s) {
//   _BtnState.normal => (
//       bg: MdColors.buttonInactiveDefaultBg,
//       text: MdColors.buttonInactiveDefaultText,
//       shadow: false
//     ),
//   _BtnState.hover => (
//       bg: MdColors.buttonInactiveHoverBg,
//       text: MdColors.buttonInactiveHoverText,
//       shadow: false
//     ),
//   _BtnState.pressed => (
//       bg: MdColors.buttonInactivePressedBg,
//       text: MdColors.buttonInactivePressedText,
//       shadow: false
//     ),
//   _BtnState.disabled => (
//       bg: MdColors.buttonDisabledBg,
//       text: MdColors.buttonDisabledText,
//       shadow: false
//     ),
// };
//   }
// }

enum WaveButtonType {
  main(
    textDefaultColor: MdColors.buttonMainDefaultText,
    textHoveredColor: MdColors.buttonMainHoverText,
    textPressedColor: MdColors.buttonMainPressedText,
    buttonDefaultColor: MdColors.buttonMainDefaultBg,
    buttonHoveredColor: MdColors.buttonMainHoverBg,
    buttonPressedColor: MdColors.buttonMainPressedBg,
    hasShadow: false,
  );
  // alternative(),
  // error(),
  // inactive();

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
