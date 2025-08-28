import 'package:flutter/material.dart';
import 'package:md_ui_kit/_core/colors.dart' show MdColors;
import 'package:md_ui_kit/widgets/wave_text.dart';

class WaveItemBadge extends StatefulWidget {
  const WaveItemBadge({
    super.key,
    required this.label,
    this.style = WaveItemBadgeStyle.unselected,
    this.padding = const EdgeInsets.fromLTRB(4, 2, 4, 2),
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.backgroundColor,
    this.foregroundColor,
  });

  final String? label;
  final WaveItemBadgeStyle style;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  State<WaveItemBadge> createState() => _WaveItemBadgeState();
}

class _WaveItemBadgeState extends State<WaveItemBadge> {
  Color _resolveBg() {
    if (widget.backgroundColor != null) return widget.backgroundColor!;
    switch (widget.style) {
      case WaveItemBadgeStyle.unselected:
        return MdColors.notificationsUnselectedBg;
      case WaveItemBadgeStyle.selected:
        return MdColors.notificationsSelectedBg;
    }
  }

  Color _resolveText() {
    if (widget.foregroundColor != null) return widget.foregroundColor!;
    switch (widget.style) {
      case WaveItemBadgeStyle.unselected:
        return MdColors.notificationsUnselectedText;
      case WaveItemBadgeStyle.selected:
        return MdColors.notificationsSelectedText;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.label == null || widget.label == "") {
      return const SizedBox();
    }
    final bg = _resolveBg();
    final fg = _resolveText();

    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: widget.borderRadius,
      ),
      child: WaveText(widget.label!, type: WaveTextType.badge, color: fg),
    );
  }
}

enum WaveItemBadgeStyle { unselected, selected }
