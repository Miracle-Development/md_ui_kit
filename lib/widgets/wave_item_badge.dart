import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart' show MdColors;
import 'package:md_ui_kit/widgets/wave_text.dart';

class WaveItemBadge extends StatefulWidget {
  const WaveItemBadge({
    super.key,
    required this.label,
    this.type = WaveItemBadgeType.unselected,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.backgroundColor,
    this.foregroundColor,
  });

  final int? label;
  final WaveItemBadgeType type;
  final BorderRadius borderRadius;

  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  State<WaveItemBadge> createState() => _WaveItemBadgeState();
}

class _WaveItemBadgeState extends State<WaveItemBadge> {
  Color _resolveBg() {
    if (widget.backgroundColor != null) return widget.backgroundColor!;
    switch (widget.type) {
      case WaveItemBadgeType.unselected:
        return MdColors.notificationsUnselectedBg;
      case WaveItemBadgeType.selected:
        return MdColors.notificationsSelectedBg;
    }
  }

  Color _resolveText() {
    if (widget.foregroundColor != null) return widget.foregroundColor!;
    switch (widget.type) {
      case WaveItemBadgeType.unselected:
        return MdColors.notificationsUnselectedText;
      case WaveItemBadgeType.selected:
        return MdColors.notificationsSelectedText;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.label == null || widget.label == 0) {
      return const SizedBox();
    }
    final bg = _resolveBg();
    final fg = _resolveText();

    return Container(
      height: 13,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: widget.borderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 2,
                left: 4,
                right: 4,
              ),
              child: WaveText(
                widget.label! > 999 ? '999+' : widget.label!.toString(),
                type: WaveTextType.badge,
                weight: WaveTextWeight.bold,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum WaveItemBadgeType { unselected, selected }
