import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:md_ui_kit/_core/colors.dart' show MdColors;
import 'package:md_ui_kit/widgets/wave_item_badge.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';

class WaveNavBarItem extends StatefulWidget {
  const WaveNavBarItem({
    super.key,
    required this.waveItemBadge,
    required this.iconAsset,
    required this.label,
    this.selected = false,
    this.onTap,
    this.iconSize = 32,
    this.gap = 10,
  });

  final WaveItemBadge waveItemBadge;
  final String iconAsset;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  final double iconSize;
  final double gap;

  @override
  State<WaveNavBarItem> createState() => _WaveNavBarItemState();
}

class _WaveNavBarItemState extends State<WaveNavBarItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final color = _resolveColors(
      selected: widget.selected,
      hover: _hover,
    );
    _resolveBadge();
    final Color iconAndTextColor = color;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                widget.iconAsset != 'assets/icons/navbar/mic_off.svg'
                    ? SvgPicture.asset(widget.iconAsset,
                        width: widget.iconSize,
                        height: widget.iconSize,
                        color: iconAndTextColor)
                    : Stack(
                        children: [
                          SvgPicture.asset(widget.iconAsset,
                              width: widget.iconSize,
                              height: widget.iconSize,
                              color: iconAndTextColor),
                          SvgPicture.asset(
                            'assets/icons/navbar/mic_off_line.svg',
                            width: widget.iconSize,
                            height: widget.iconSize,
                          ),
                        ],
                      ),
                if ((widget.waveItemBadge.label ?? 0) > 0)
                  Positioned(
                      left: widget.iconSize - 6,
                      top: -4,
                      child: widget.waveItemBadge),
              ],
            ),
            SizedBox(height: widget.gap),
            WaveText(
              widget.label,
              type: WaveTextType.caption,
              weight: WaveTextWeight.bold,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Color _resolveColors({
    required bool selected,
    required bool hover,
  }) {
    if (selected) {
      if (hover) {
        return MdColors.navBarSelectedHoverColor;
      } else {
        return MdColors.navBarSelectedColor;
      }
    } else {
      if (hover) {
        return MdColors.navBarUnselectedHoverColor;
      } else {
        return MdColors.navBarUnselectedColor;
      }
    }
  }

  void _resolveBadge() {
    if (widget.selected) {
      widget.waveItemBadge.style = WaveItemBadgeStyle.selected;
    } else {
      widget.waveItemBadge.style = WaveItemBadgeStyle.unselected;
    }
  }
}
