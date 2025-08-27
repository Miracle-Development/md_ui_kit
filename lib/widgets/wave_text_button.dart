import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';
import 'package:md_ui_kit/_core/colors.dart' show MdColors;

class WaveTextButton extends StatefulWidget {
  const WaveTextButton({
    super.key,
    this.label = 'test-peer',
    this.onPressed,
    this.horizontalPadding = 8,
    this.verticalPadding = 2,
    this.iconGap = 12,
    this.iconSize = 32,
  });

  final String label;

  final VoidCallback? onPressed;

  final double horizontalPadding;
  final double verticalPadding;
  final double iconGap;

  final double iconSize;

  @override
  State<WaveTextButton> createState() => _WaveTextButtonState();
}

class _WaveTextButtonState extends State<WaveTextButton> {
  bool _hovered = false;
  bool _pressed = false;

  final iconDefaultAsset = 'assets/icons/copy/copy_default.svg';
  final iconPressedAsset = 'assets/icons/copy/copy_pressed.svg';

  Color _resolveColor() {
    if (_pressed) {
      return MdColors.textButtonPressed;
    }
    if (_hovered) {
      return MdColors.textButtonHover;
    }
    return MdColors.textButtonDefault;
  }

  Future<void> _onTapUpPressed() async {
    setState(() => _pressed = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final color = _resolveColor();

    final iconAsset = _pressed ? iconPressedAsset : iconDefaultAsset;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => _onTapUpPressed() : null,
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding,
            vertical: widget.verticalPadding,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: WaveText(
                  widget.label,
                  weight: WaveTextWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(width: widget.iconGap),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: SvgPicture.asset(
                  iconAsset,
                  width: widget.iconSize,
                  height: widget.iconSize,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum WaveTextButtonType { main, hovered, pressed, disabled }
