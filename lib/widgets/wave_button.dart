import 'dart:async';
import 'package:flutter/material.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';
import 'package:md_ui_kit/_core/colors.dart' show MdColors;

class WaveButton extends StatefulWidget {
  const WaveButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.enabled = true,
    this.type = WaveButtonType.main,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
  final bool enabled;
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
  Timer? _pressedTimer;

  _BtnState get _state {
    if (!widget.enabled || widget.onPressed == null) return _BtnState.disabled;
    if (_pressed) return _BtnState.pressed;
    if (_hover) return _BtnState.hover;
    return _BtnState.normal;
  }

  @override
  void dispose() {
    _pressedTimer?.cancel();
    super.dispose();
  }

  ({Color bg, Color text, bool shadow}) _colorsFor(_BtnState s) {
    switch (widget.type) {
      case WaveButtonType.main:
        return switch (s) {
          _BtnState.normal => (
              bg: MdColors.buttonMainDefaultBg,
              text: MdColors.buttonMainDefaultText,
              shadow: true
            ),
          _BtnState.hover => (
              bg: MdColors.buttonMainHoverBg,
              text: MdColors.buttonMainHoverText,
              shadow: true
            ),
          _BtnState.pressed => (
              bg: MdColors.buttonMainPressedBg,
              text: MdColors.buttonMainPressedText,
              shadow: true
            ),
          _BtnState.disabled => (
              bg: MdColors.buttonDisabledBg,
              text: MdColors.buttonDisabledText,
              shadow: false
            ),
        };
      case WaveButtonType.alternative:
        return switch (s) {
          _BtnState.normal => (
              bg: MdColors.buttonAltDefaultBg,
              text: MdColors.buttonAltDefaultText,
              shadow: true
            ),
          _BtnState.hover => (
              bg: MdColors.buttonAltHoverBg,
              text: MdColors.buttonAltHoverText,
              shadow: true
            ),
          _BtnState.pressed => (
              bg: MdColors.buttonAltPressedBg,
              text: MdColors.buttonAltPressedText,
              shadow: true
            ),
          _BtnState.disabled => (
              bg: MdColors.buttonDisabledBg,
              text: MdColors.buttonDisabledText,
              shadow: false
            ),
        };
      case WaveButtonType.error:
        return switch (s) {
          _BtnState.normal => (
              bg: MdColors.buttonErrorDefaultBg,
              text: MdColors.buttonErrorDefaultText,
              shadow: true
            ),
          _BtnState.hover => (
              bg: MdColors.buttonErrorHoverBg,
              text: MdColors.buttonErrorHoverText,
              shadow: true
            ),
          _BtnState.pressed => (
              bg: MdColors.buttonErrorPressedBg,
              text: MdColors.buttonErrorPressedText,
              shadow: true
            ),
          _BtnState.disabled => (
              bg: MdColors.buttonDisabledBg,
              text: MdColors.buttonDisabledText,
              shadow: false
            ),
        };
      case WaveButtonType.inactive:
        return switch (s) {
          _BtnState.normal => (
              bg: MdColors.buttonInactiveDefaultBg,
              text: MdColors.buttonInactiveDefaultText,
              shadow: false
            ),
          _BtnState.hover => (
              bg: MdColors.buttonInactiveHoverBg,
              text: MdColors.buttonInactiveHoverText,
              shadow: false
            ),
          _BtnState.pressed => (
              bg: MdColors.buttonInactivePressedBg,
              text: MdColors.buttonInactivePressedText,
              shadow: false
            ),
          _BtnState.disabled => (
              bg: MdColors.buttonDisabledBg,
              text: MdColors.buttonDisabledText,
              shadow: false
            ),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _colorsFor(_state);
    final bg = palette.bg;
    final textColor = palette.text;
    final needShadow = widget.showShadow && palette.shadow;

    final decorated = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: widget.radius,
        boxShadow: !needShadow
            ? null
            : const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextStyle.merge(
            style: TextStyle(
              color: textColor,
              fontFamily: 'Play',
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            child: WaveText(
              widget.label!,
              type: WaveTextType.caption,
              weight: WaveTextWeight.bold,
              color: WaveTextColor.inherit,
            ),
          )
        ],
      ),
    );

    final enabled = widget.enabled && widget.onPressed != null;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled
            ? (_) {
                setState(() => _pressed = false);
                widget.onPressed?.call();
              }
            : null,
        onTapCancel: () => setState(() => _pressed = false),
        child: AbsorbPointer(
          absorbing: !enabled,
          child: decorated,
        ),
      ),
    );
  }
}

enum WaveButtonType { main, alternative, error, inactive }

enum _BtnState { normal, hover, pressed, disabled }
