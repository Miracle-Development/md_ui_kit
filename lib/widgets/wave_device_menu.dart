import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/_core/precached_icons.dart';
import 'package:md_ui_kit/md_ui_kit.dart';

class WaveDeviceMenu<T> extends StatefulWidget {
  const WaveDeviceMenu({
    super.key,
    required this.items,
    this.subtitle,
    this.onChanged,
    this.initialIndex = 0,
    this.labelBuilder,
  });

  final List<T> items;
  final String? subtitle;
  final ValueChanged<T>? onChanged;
  final int initialIndex;
  final String Function(T item)? labelBuilder;

  @override
  State<WaveDeviceMenu<T>> createState() => _WaveDeviceMenuState<T>();
}

class _WaveDeviceMenuState<T> extends State<WaveDeviceMenu<T>>
    with SingleTickerProviderStateMixin {
  static const double _radius = 12;
  static const double _headerHeight = 41;
  static const double _borderWidth = 2;
  static const EdgeInsets _headerPadding = EdgeInsets.only(left: 16);

  late int _selectedIndex;
  bool _open = false;
  bool _hover = false;
  bool _pressed = false;

  final LayerLink _link = LayerLink();
  final GlobalKey _headerKey = GlobalKey();
  OverlayEntry? _entry;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fade;
  double _panelWidth = 0;
  int? _hoveredIndex;
  int? _pressedIndex;

  String _labelOf(T item) => widget.labelBuilder != null
      ? widget.labelBuilder!(item)
      : item.toString();

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        (widget.initialIndex >= 0 && widget.initialIndex < widget.items.length)
            ? widget.initialIndex
            : 0;

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _removeOverlay(immediate: true);
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected =
        widget.items.isNotEmpty ? _labelOf(widget.items[_selectedIndex]) : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CompositedTransformTarget(
          link: _link,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
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
                key: _headerKey,
                height: _headerHeight,
                padding: _headerPadding,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(_radius),
                  border: Border.all(
                      color: _resovleBorderColor(), width: _borderWidth),
                  boxShadow: const [
                    BoxShadow(color: MdColors.deviceMenuShadowDefaultColor),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: WaveText(
                        selected,
                        type: WaveTextType.subtitle,
                        color: _resolveTextColor(),
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
                        duration: const Duration(milliseconds: 120),
                        child: SvgPicture.asset(
                          PrecachedIcons.deviceMenuArrow,
                          width: 32,
                          height: 32,
                          colorFilter: ColorFilter.mode(
                            _resolveIconColor(),
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
        ),
        if (widget.subtitle != null && widget.subtitle!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 10),
            child: WaveText(
              widget.subtitle!,
              type: WaveTextType.caption,
              color: MdColors.deviceMenuSubTitleTextColor,
            ),
          ),
      ],
    );
  }

  Color _resovleBorderColor() {
    if (!_open) {
      if (_pressed) return MdColors.deviceMenuBorderClosedPressedColor;
      if (_hover) return MdColors.deviceMenuBorderClosedHoverColor;
      return MdColors.deviceMenuBorderClosedDefaultColor;
    } else {
      if (_pressed) return MdColors.deviceMenuBorderOpenPressedColor;
      if (_hover) return MdColors.deviceMenuBorderOpenHoverColor;
      return MdColors.deviceMenuBorderOpenDefaultColor;
    }
  }

  Color _resolveTextColor() {
    if (_pressed) return MdColors.deviceMenuTextPressedColor;
    if (_hover) return MdColors.deviceMenuTextHoverColor;
    return MdColors.deviceMenuTextDefaultColor;
  }

  Color _resolveIconColor() {
    if (_pressed) return MdColors.deviceMenuIconPressedColor;
    if (_hover) return MdColors.deviceMenuIconHoverColor;
    return MdColors.deviceMenuIconDefaultColor;
  }

  Color _resolveItemTextColor(int? i) {
    if (i == _hoveredIndex || i == _pressedIndex) {
      return MdColors.deviceMenuItemTextHoverPressedColor;
    } else {
      return MdColors.deviceMenuItemTextDefualtColor;
    }
  }

  Color _resolveItemShadow(int? i) {
    if (i == _hoveredIndex && i != _pressedIndex) {
      return MdColors.deviceMenuShadowHoverColor;
    } else if (i == _pressedIndex) {
      return MdColors.deviceMenuShadowPressedColor;
    } else {
      return Colors.transparent;
    }
  }

  void _toggle() {
    if (_open) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _select(int index) {
    setState(() => _selectedIndex = index);
    widget.onChanged?.call(widget.items[index]);
  }

  void _setPressed(int? i) {
    _pressedIndex = i;
    _entry?.markNeedsBuild();
  }

  void _setHovered(int? i) {
    _hoveredIndex = i;
    _entry?.markNeedsBuild();
  }

  void _removeOverlay({bool immediate = false}) {
    if (_entry == null) return;
    if (immediate) {
      _entry!.remove();
      _entry = null;
      _open = false;
      return;
    }
    _fadeCtrl.reverse().whenComplete(() {
      _entry?.remove();
      _entry = null;
      if (mounted) setState(() => _open = false);
    });
  }

  void _onTap(int i) {
    _select(i);
    _removeOverlay();
  }

  void _showOverlay() {
    final box = _headerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      _panelWidth = box.size.width;
    }

    BorderSide side =
        const BorderSide(color: MdColors.deviceMenuItemHoverColor, width: 2);

    _entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeOverlay,
              ),
            ),
            CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              offset: const Offset(0, _headerHeight + 12),
              child: FadeTransition(
                opacity: _fade,
                child: Material(
                  type: MaterialType.transparency,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: _panelWidth),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(_radius),
                        border: Border.all(
                          color: MdColors.deviceMenuItemsBorderColor,
                          width: _borderWidth,
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: MdColors.deviceMenuShadowDefaultColor),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int i = 0; i < widget.items.length; i++) ...[
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_) => _setHovered(i),
                              onExit: (_) => _setHovered(null),
                              child: GestureDetector(
                                onTapDown: (_) => _setPressed(i),
                                onTapCancel: () => _setPressed(null),
                                onTapUp: (_) => _setPressed(null),
                                onTap: () => _onTap(i),
                                child: ColoredBox(
                                  color: _resolveItemShadow(i),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: (i == _hoveredIndex)
                                            ? (i == 0)
                                                ? 44
                                                : 46
                                            : (i + 1 == _hoveredIndex)
                                                ? 42
                                                : 44,
                                        decoration: BoxDecoration(
                                          border: (i + 1) == _hoveredIndex
                                              ? null
                                              : i != _hoveredIndex
                                                  ? (i ==
                                                          widget.items.length -
                                                              1)
                                                      ? null
                                                      : const Border(
                                                          bottom: BorderSide(
                                                              color: MdColors
                                                                  .deviceMenuItemsBorderColor,
                                                              width: 2),
                                                        )
                                                  : Border(
                                                      bottom: side,
                                                      top: side,
                                                      left: side,
                                                      right: side),
                                          borderRadius: i == _hoveredIndex
                                              ? BorderRadius.circular(_radius)
                                              : null,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left:
                                                (i == _hoveredIndex) ? 14 : 16,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: (i == 0 &&
                                                        (i == _hoveredIndex))
                                                    ? 0
                                                    : (i ==
                                                                widget.items
                                                                        .length -
                                                                    1 &&
                                                            (i ==
                                                                _hoveredIndex))
                                                        ? 2
                                                        : 0,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: WaveText(
                                                  _labelOf(widget.items[i]),
                                                  type: WaveTextType.subtitle,
                                                  color:
                                                      _resolveItemTextColor(i),
                                                ),
                                              ),
                                              SizedBox(
                                                height: (i == 0 &&
                                                        (i == _hoveredIndex))
                                                    ? 2
                                                    : (i ==
                                                            widget.items
                                                                    .length -
                                                                1)
                                                        ? 0
                                                        : 0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
    setState(() => _open = true);
    _fadeCtrl.forward(from: 0);
  }
}
