import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:md_ui_kit/_core/colors.dart' show MdColors;
import 'package:md_ui_kit/_core/precached_icons.dart';
import 'package:md_ui_kit/widgets/wave_item_badge.dart';
import 'package:md_ui_kit/widgets/wave_text.dart';

class WaveNavBarItem extends StatefulWidget {
  const WaveNavBarItem({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
    this.counter,
    this.iconSize = 32,
    this.gap = 10,
  });

  final int? counter;
  final WaveNavBarIcon icon;
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

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                widget.icon.isStack
                    ? Stack(
                        children: [
                          SvgPicture.asset(
                            widget.icon.asset,
                            width: widget.iconSize,
                            height: widget.iconSize,
                            colorFilter:
                                ColorFilter.mode(color, BlendMode.srcIn),
                          ),
                          SvgPicture.asset(
                            widget.icon.overlay!,
                            width: widget.iconSize,
                            height: widget.iconSize,
                          ),
                        ],
                      )
                    : SvgPicture.asset(
                        widget.icon.asset,
                        width: widget.iconSize,
                        height: widget.iconSize,
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                      ),
                if (widget.counter != null && widget.counter != 0)
                  Positioned(
                    left: widget.iconSize - 6,
                    top: -4,
                    child: WaveItemBadge(
                      label: widget.counter,
                      state: widget.selected
                          ? WaveItemBadgeState.selected
                          : WaveItemBadgeState.unselected,
                    ),
                  ),
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
      return hover
          ? MdColors.navBarSelectedHoverColor
          : MdColors.navBarSelectedColor;
    } else {
      return hover
          ? MdColors.navBarUnselectedHoverColor
          : MdColors.navBarUnselectedColor;
    }
  }
}

enum WaveNavBarIcon {
  chat(PrecachedIcons.navBarChatIcon),
  link(PrecachedIcons.navBarLinkIcon),
  linkBreak(PrecachedIcons.navBarLinkBreakIcon),
  micOn(PrecachedIcons.navBarMicOnIcon),
  micOff(PrecachedIcons.navBarMicOnIcon,
      overlay: PrecachedIcons.navBarMicOffLineIcon),
  phone(PrecachedIcons.navBarPhoneIcon),
  planet(PrecachedIcons.navBarPlanetIcon);

  const WaveNavBarIcon(this.asset, {this.overlay});
  final String asset;
  final String? overlay;

  bool get isStack => overlay != null;
}
