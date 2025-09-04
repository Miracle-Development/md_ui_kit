import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/_core/precached_icons.dart';
import 'package:md_ui_kit/md_ui_kit.dart';

class WaveDeviceMenu extends StatefulWidget {
  const WaveDeviceMenu({
    super.key,
    required this.items,
    this.subtitle,
    this.onChanged,
    this.initialIndex = 0,
  });

  final List<String> items;
  final String? subtitle;
  final VoidCallback? onChanged;
  final int initialIndex;

  @override
  State<WaveDeviceMenu> createState() => _WaveDeviceMenuState();
}

class _WaveDeviceMenuState extends State<WaveDeviceMenu> {
  static const double _radius = 12;
  static const double _headerHeight = 41;
  static const double _borderWidth = 2;
  static const EdgeInsets _headerPadding = EdgeInsets.only(
    left: 16,
  );

  late int _selectedIndex;
  bool _open = false;
  bool _hover = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        (widget.initialIndex >= 0 && widget.initialIndex < widget.items.length)
            ? widget.initialIndex
            : 0;
  }

  Color _borderColor() {
    if (!_open) {
      if (_pressed) return MdColors.buttonMainPressedBg;
      if (_hover) return MdColors.buttonMainHoverBg;
      return MdColors.brandFirstStrip;
    } else {
      if (_pressed) return MdColors.textButtonHover;
      if (_hover) return MdColors.textButtonHover;
      return MdColors.textButtonHover;
    }
  }

  Color _textColor() {
    if (_hover) return MdColors.textButtonHover;
    if (_pressed) return const Color.fromRGBO(159, 153, 255, 1);
    return MdColors.textButtonDefault;
  }

  Color _iconColor() {
    if (_hover) return MdColors.buttonMainHoverText;
    if (_pressed) return MdColors.textButtonHover;
    return MdColors.buttonMainHoverText;
  }

  BoxDecoration _headerDecoration() {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_radius),
      border: Border.all(color: _borderColor(), width: _borderWidth),
    );
  }

  void _toggle() {
    setState(() {
      _open = !_open;
    });
  }

  void _select(int index) {
    setState(() {
      _selectedIndex = index;
      _open = false;
    });
    widget.onChanged;
  }

  @override
  Widget build(BuildContext context) {
    final selected =
        widget.items.isNotEmpty ? widget.items[_selectedIndex] : '';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MouseRegion(
              onEnter: (_) => setState(() => _hover = true),
              onExit: (_) => setState(() {
                _hover = false;
                _pressed = false;
              }),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) => setState(() => _pressed = true),
                onTapCancel: () => setState(() => _pressed = false),
                onTapUp: (_) => setState(() => _pressed = false),
                onTap: _toggle,
                child: Container(
                  height: _headerHeight,
                  padding: _headerPadding,
                  decoration: _headerDecoration(),
                  child: Row(
                    children: [
                      Expanded(
                        child: WaveText(
                          selected,
                          type: WaveTextType.subtitle,
                          color: _textColor(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 16,
                          bottom: 4.5,
                          top: 4.5,
                        ),
                        child: AnimatedRotation(
                          turns: _open ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: SvgPicture.asset(
                            PrecachedIcons.deviceMenuArrow,
                            width: 32,
                            height: 32,
                            colorFilter: ColorFilter.mode(
                              _iconColor(),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.subtitle != null &&
                widget.subtitle!.isNotEmpty &&
                !_open)
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 10),
                child: WaveText(
                  widget.subtitle!,
                  type: WaveTextType.caption,
                  color: MdColors.textButtonDefault,
                ),
              ),
          ],
        ),
        if (_open)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => setState(() => _open = false),
            ),
          ),
        Positioned(
          top: _headerHeight + 12,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: _open ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(_radius),
                border: Border.all(
                  color: MdColors.textButtonHover,
                  width: _borderWidth,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < widget.items.length; i++) ...[
                    InkWell(
                      onTap: () => _select(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 11,
                        ),
                        child: WaveText(
                          widget.items[i],
                          type: WaveTextType.subtitle,
                          color: MdColors.textButtonDefault,
                        ),
                      ),
                    ),
                    if (i != widget.items.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          height: 1,
                          thickness: 2,
                          color: MdColors.textButtonHover,
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
