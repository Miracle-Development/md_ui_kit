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
  bool _onTapUp = false;
  double _scale = 1.0;
  double _offsetY = 0.0;
  double _offsetX = 0.0;
  final Duration _animDuration = const Duration(milliseconds: 150);

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _onTapDown = true;
      _onTapUp = false;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _onTapDown = false;
      _onTapUp = true;
    });
    Future.delayed(_animDuration, () {
      if (mounted) {
        setState(() {
          _offsetY = 0.0;
          _offsetX = 0.0;
        });
      }
    });
  }

  void _handleTapCancel() {
    setState(() {
      _onTapDown = false;
      _onTapUp = false;
      _scale = 1.0;
      _offsetY = 0.0;
      _offsetX = 0.0;
    });
  }

  Future<void> _handleTap() async {
    if (widget.onTap != null) widget.onTap!();
    setState(() {
      _onTapDown = false;
      _onTapUp = true;
      _scale = 25.0 / 32.0;
      _offsetY = 4;
      _offsetX = 2.0;
    });
    await Future.delayed(_animDuration, () {
      if (mounted) {
        setState(() {
          _scale = 1.0;
          _offsetY = -8.0;
          _offsetX = 0.0;
        });
      }
    });
    await Future.delayed(_animDuration, () {
      if (mounted) {
        setState(() {
          _offsetY = 0.0;
          _offsetX = 0.0;
          _onTapDown = false;
          _onTapUp = false;
        });
      }
    });
  }

  Color _resolveColors({
    required bool selected,
    required bool hover,
    required bool onTapDown,
    required bool onTapUp,
  }) {
    if (onTapDown || onTapUp) {
      return MdColors.navBarMiddleAnimationColor;
    }

    if (selected) {
      return hover
          ? MdColors.navBarSelectedHoverColor
          : MdColors.navBarSelectedColor;
    }

    return hover
        ? MdColors.navBarUnselectedHoverColor
        : MdColors.navBarUnselectedColor;
  }

  @override
  Widget build(BuildContext context) {
    final targetColor = _resolveColors(
      selected: widget.selected,
      hover: _hover,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
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
                            TweenAnimationBuilder<Color?>(
                              duration: _animDuration,
                              tween: ColorTween(end: targetColor),
                              builder: (context, color, child) {
                                return SvgPicture.asset(
                                  widget.icon.asset,
                                  width: widget.iconSize,
                                  height: widget.iconSize,
                                  colorFilter: ColorFilter.mode(
                                    color ?? Colors.transparent,
                                    BlendMode.srcIn,
                                  ),
                                );
                              },
                            ),
                            SvgPicture.asset(
                              widget.icon.overlay!,
                              width: widget.iconSize,
                              height: widget.iconSize,
                            ),
                          ],
                        ),
                      )
                    : AnimatedContainer(
                        duration: _animDuration,
                        transform: Matrix4.identity()
                          ..translate(_offsetX, _offsetY)
                          ..scale(_scale),
                        curve: Curves.easeOut,
                        child: TweenAnimationBuilder<Color?>(
                          duration: _animDuration,
                          tween: ColorTween(end: targetColor),
                          builder: (context, color, child) {
                            return SvgPicture.asset(
                              widget.icon.asset,
                              width: widget.iconSize,
                              height: widget.iconSize,
                              colorFilter: ColorFilter.mode(
                                color ?? Colors.transparent,
                                BlendMode.srcIn,
                              ),
                            );
                          },
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
            TweenAnimationBuilder<Color?>(
              duration: _animDuration,
              tween: ColorTween(end: targetColor),
              builder: (context, color, child) {
                return WaveText(
                  widget.label,
                  type: WaveTextType.caption,
                  weight: WaveTextWeight.bold,
                  color: color,
                );
              },
            ),
          ],
        ),
      ),
    );
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
