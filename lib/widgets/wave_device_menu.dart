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

class _WaveDeviceMenuState extends State<WaveDeviceMenu>
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

  void _setHovered(int? i) {
    _hoveredIndex = i;
    _entry?.markNeedsBuild();
  }

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

  Color _borderColor() {
    if (!_open) {
      if (_pressed) return MdColors.buttonMainPressedBg;
      if (_hover) return MdColors.buttonMainHoverBg;
      return MdColors.brandFirstStrip;
    } else {
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
    if (_open) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final box = _headerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      _panelWidth = box.size.width;
    }

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
                    constraints: BoxConstraints.tightFor(width: _panelWidth),
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int i = 0; i < widget.items.length; i++) ...[
                            MouseRegion(
                              onEnter: (_) => _setHovered(i),
                              onExit: (_) => _setHovered(null),
                              child: AnimatedContainer(
                                height: 40,
                                duration: const Duration(milliseconds: 120),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: (_hoveredIndex == i)
                                      ? Border.all(
                                          color: MdColors.textButtonHover,
                                          width: 2)
                                      : null,
                                  boxShadow: (_hoveredIndex == i)
                                      ? const [
                                          BoxShadow(
                                              color: Color.fromRGBO(
                                                  177, 172, 255, 0.1))
                                        ]
                                      : null,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    _select(i);
                                    _removeOverlay();
                                  },
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: WaveText(
                                        widget.items[i],
                                        type: WaveTextType.subtitle,
                                        color: MdColors.textButtonDefault,
                                      ),
                                    ),
                                  ),
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

  void _select(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final selected =
        widget.items.isNotEmpty ? widget.items[_selectedIndex] : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CompositedTransformTarget(
          link: _link,
          child: MouseRegion(
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
        ),
        if (widget.subtitle != null && widget.subtitle!.isNotEmpty)
          AnimatedOpacity(
            opacity: _open ? 0 : 1,
            duration: const Duration(milliseconds: 120),
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 10),
              child: WaveText(
                widget.subtitle!,
                type: WaveTextType.caption,
                color: MdColors.textButtonDefault,
              ),
            ),
          ),
      ],
    );
  }
}
