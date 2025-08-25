// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class MdSimpleButton extends StatefulWidget {
  const MdSimpleButton({
    super.key,
    this.label,
    this.onPressed,
    this.enabled = true,
    this.type = WaveSimpleButtonType.main,
  });
  final String? label;

  final VoidCallback? onPressed;
  final bool enabled;
  final WaveSimpleButtonType type;

  @override
  State<MdSimpleButton> createState() => _MdSimpleButtonState();
}

class _MdSimpleButtonState extends State<MdSimpleButton> {
  bool _hover = false;
  bool _pressed = false;

  _BtnState get _state {
    if (!widget.enabled || widget.onPressed == null) return _BtnState.disabled;
    if (_pressed) return _BtnState.pressed;
    if (_hover) return _BtnState.hover;
    return _BtnState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final p = WaveSimpleButtonColors.paletteFor(widget.type);

    // цвета по состоянию
    final Color bg, text;
    final Color? shadow;
    switch (_state) {
      case _BtnState.normal:
        bg = p.defaultBg;
        text = p.defaultText;
        shadow = p.shadow;
        break;
      case _BtnState.hover:
        bg = p.hoverBg;
        text = p.hoverText;
        shadow = p.shadow;
        break;
      case _BtnState.pressed:
        bg = p.pressedBg;
        text = p.pressedText;
        shadow = p.shadow;
        break;
      case _BtnState.disabled:
        bg = WaveSimpleButtonColors.disabledBg;
        text = WaveSimpleButtonColors.disabledText;
        shadow = null;
        break;
    }

    // внутренний текст
    final child = Text(
      widget.label!,
      style: TextStyle(
        fontFamily: 'Play',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: text,
      ),
    );

    final decorated = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      constraints:
          const BoxConstraints(minHeight: 50, minWidth: 156, maxHeight: 50),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(12),
        ),
        boxShadow: shadow == null
            ? null
            : const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
      ),
      child: Center(child: child),
    );

    return MouseRegion(
      cursor: (widget.enabled && widget.onPressed != null)
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (widget.enabled && widget.onPressed != null)
            ? (_) => setState(() => _pressed = true)
            : null,
        onTapUp: (widget.enabled && widget.onPressed != null)
            ? (_) {
                setState(() => _pressed = false);
                widget.onPressed?.call();
              }
            : null,
        onTapCancel: () => setState(() => _pressed = false),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [decorated],
        ),
      ),
    );
  }
}

// Палитры для 4 типов кнопок + disabled.
class WaveSimpleButtonColors {
  WaveSimpleButtonColors._();

  // main
  static const _Palette main = _Palette(
      defaultBg: Color.fromRGBO(67, 70, 243, 1),
      defaultText: Color.fromRGBO(220, 218, 255, 1),
      hoverBg: Color.fromRGBO(53, 56, 233, 1),
      hoverText: Color.fromRGBO(192, 189, 255, 1),
      pressedBg: Color.fromRGBO(41, 44, 224, 1),
      pressedText: Color.fromRGBO(186, 182, 251, 1));

  // alternative
  static const _Palette alternative = _Palette(
    defaultBg: Color.fromRGBO(220, 218, 255, 1),
    defaultText: Color.fromRGBO(48, 51, 212, 1),
    hoverBg: Color.fromRGBO(181, 178, 229, 1),
    hoverText: Color.fromRGBO(46, 48, 184, 1),
    pressedBg: Color.fromRGBO(157, 153, 229, 1),
    pressedText: Color.fromRGBO(39, 42, 190, 1),
    shadow: Color.fromRGBO(0, 0, 0, 0.25),
  );

  // error
  static const _Palette error = _Palette(
    defaultBg: Color.fromRGBO(223, 222, 251, 1),
    defaultText: Color.fromRGBO(109, 42, 42, 1),
    hoverBg: Color.fromRGBO(204, 178, 185, 1),
    hoverText: Color.fromRGBO(94, 33, 33, 1),
    pressedBg: Color.fromRGBO(224, 82, 84, 1),
    pressedText: Color.fromRGBO(223, 222, 251, 1),
  );

  // inactive
  static const _Palette inactive = _Palette(
      defaultBg: Color.fromRGBO(220, 218, 255, 1),
      defaultText: Color.fromRGBO(93, 93, 111, 1),
      hoverBg: Color.fromRGBO(188, 186, 223, 1),
      hoverText: Color.fromRGBO(87, 87, 104, 1),
      pressedBg: Color.fromRGBO(150, 148, 185, 1),
      pressedText: Color.fromRGBO(223, 222, 251, 1));

  // disabled
  static const Color disabledBg = Color.fromRGBO(116, 115, 140, 1);
  static const Color disabledText = Color.fromRGBO(235, 235, 238, 1);

  static _Palette paletteFor(WaveSimpleButtonType type) {
    switch (type) {
      case WaveSimpleButtonType.main:
        return main;
      case WaveSimpleButtonType.alternative:
        return alternative;
      case WaveSimpleButtonType.error:
        return error;
      case WaveSimpleButtonType.inactive:
        return inactive;
    }
  }
}

class _Palette {
  const _Palette({
    required this.defaultBg,
    required this.defaultText,
    required this.hoverBg,
    required this.hoverText,
    required this.pressedBg,
    required this.pressedText,
    this.shadow,
  });

  final Color defaultBg;
  final Color defaultText;
  final Color hoverBg;
  final Color hoverText;
  final Color pressedBg;
  final Color pressedText;
  final Color? shadow;
}

// енамчики

enum WaveSimpleButtonType { main, alternative, error, inactive }

enum _BtnState { normal, hover, pressed, disabled }
