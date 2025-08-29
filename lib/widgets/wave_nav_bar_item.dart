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
    this.gap = 0,
  });

  final int? counter;
  final NavBarIconType icon;
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
  bool _onTapDown = false;
  double _scale = 1.0;
  double _offsetY = 0.0;
  double _offsetX = 0.0;
  final Duration _animDuration = const Duration(milliseconds: 150);

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _onTapDown = true;
      _scale = 25.0 / 32.0;
      _offsetY = 8.0;
      _offsetX = 2.0;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _onTapDown = false;
      _scale = 1.0;
      _offsetY = -8.0;
      _offsetX = 0.0;
    });
    Future.delayed(_animDuration, () {
      if (mounted) {
        setState(() {
          _offsetY = 0.0;
          _offsetX = 0.0;
        });
      }
    });
    widget.onTap;
  }

  void _handleTapCancel() {
    setState(() {
      _scale = 1.0;
      _offsetY = 0.0;
      _offsetX = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = _resolveColors(
        selected: widget.selected, hover: _hover, onTapDown: _onTapDown);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                widget.icon.isStack
                    ? AnimatedContainer(
                        duration: _animDuration,
                        transform: Matrix4.identity()
                          ..translate(_offsetX, _offsetY)
                          ..scale(_scale),
                        curve: Curves.easeIn,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              widget.icon.asset,
                              width: widget.iconSize,
                              height: widget.iconSize,
                              colorFilter: ColorFilter.mode(
                                color,
                                BlendMode.srcIn,
                              ),
                            ),
                            SvgPicture.asset(
                              widget.icon.overlay!,
                              width: widget.iconSize,
                              height: widget.iconSize,
                            ),
                          ],
                        ))
                    : AnimatedContainer(
                        duration: _animDuration,
                        transform: Matrix4.identity()
                          ..translate(_offsetX, _offsetY)
                          ..scale(_scale),
                        curve: Curves.easeOut,
                        child: SvgPicture.asset(
                          widget.icon.asset,
                          width: widget.iconSize,
                          height: widget.iconSize,
                          colorFilter: ColorFilter.mode(
                            color,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                if (widget.counter != null && widget.counter != 0)
                  Positioned(
                    left: 22,
                    top: -2.5,
                    child: WaveItemBadge(
                      label: widget.counter,
                      type: widget.selected
                          ? WaveItemBadgeType.selected
                          : WaveItemBadgeType.unselected,
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
    required bool onTapDown,
  }) {
    if (onTapDown) {
      return MdColors.navBarMiddleAnimationColor;
    } else if (selected) {
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

enum NavBarIconType {
  chat(asset: PrecachedIcons.navBarChatIcon),
  link(asset: PrecachedIcons.navBarLinkIcon),
  linkBreak(asset: PrecachedIcons.navBarLinkBreakIcon),
  micOn(asset: PrecachedIcons.navBarMicOnIcon),
  micOff(
    asset: PrecachedIcons.navBarMicOnIcon,
    overlay: PrecachedIcons.navBarMicOffLineIcon,
  ),
  phone(asset: PrecachedIcons.navBarPhoneIcon),
  planet(asset: PrecachedIcons.navBarPlanetIcon);

  const NavBarIconType({
    required this.asset,
    this.overlay,
  });

  final String asset;
  final String? overlay;

  bool get isStack => overlay != null;
}
