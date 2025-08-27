import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';
import 'package:md_ui_kit/_core/colors.dart' show MdColors;

class WaveTextButton extends StatefulWidget {
  const WaveTextButton({
    super.key,
    this.label = 'test-peer',
    this.child,
    this.onPressed,
    this.enabled = true,
    this.horizontalPadding = 8,
    this.verticalPadding = 2,
    this.iconGap = 12,
    this.iconDefaultAsset = 'assets/icons/code/code_default.svg',
    this.iconPressedAsset = 'assets/icons/code/code_pressed.svg',
    this.iconSize = 32,
  });

  final String label;
  final Widget? child;

  final VoidCallback? onPressed;
  final bool enabled;

  final double horizontalPadding;
  final double verticalPadding;
  final double iconGap;

  final String iconDefaultAsset;
  final String iconPressedAsset;
  final double iconSize;

  @override
  State<WaveTextButton> createState() => _WaveTextButtonState();
}

class _WaveTextButtonState extends State<WaveTextButton> {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pressedTimer?.cancel();
    super.dispose();
  }

  Color _resolveColor(_BtnState s) {
    switch (s) {
      case _BtnState.normal:
        return MdColors.textButtonDefault;
      case _BtnState.hover:
        return MdColors.textButtonHover;
      case _BtnState.pressed:
        return MdColors.textButtonPressed;
      case _BtnState.disabled:
        return MdColors.textButtonDisabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled && widget.onPressed != null;
    final color = _resolveColor(_state);

    final String iconAsset = _state == _BtnState.pressed
        ? widget.iconPressedAsset
        : widget.iconDefaultAsset;

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
                _pressedTimer?.cancel();
                setState(() => _pressed = true);
                widget.onPressed?.call();
                _pressedTimer = Timer(const Duration(seconds: 1), () {
                  if (!mounted) return;
                  setState(() => _pressed = false);
                });
              }
            : null,
        onTapCancel: () => setState(() => _pressed = false),
        child: AbsorbPointer(
          absorbing: !enabled,
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: color,
              fontFamily: 'Play',
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.horizontalPadding,
                    vertical: widget.verticalPadding,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.child ??
                          WaveText(
                            widget.label,
                            type: WaveTextType.title,
                            weight: WaveTextWeight.bold,
                            color: WaveTextColor.inherit,
                          ),
                      SizedBox(width: widget.iconGap),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 100),
                        child: SvgPicture.asset(
                          iconAsset,
                          key: ValueKey(iconAsset),
                          width: widget.iconSize,
                          height: widget.iconSize,
                          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _BtnState { normal, hover, pressed, disabled }
